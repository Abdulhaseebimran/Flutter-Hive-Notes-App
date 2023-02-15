import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hive_nosql/boxes/boxes.dart';
import 'package:flutter_hive_nosql/models/notes_models.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final titleController = TextEditingController();
  final descriptionsController = TextEditingController();
  List<Color> colors = [
    Colors.purple,
    Colors.black38,
    Colors.green,
    Colors.blue,
    Colors.red
  ];

  Random random = Random(3);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          return ListView.builder(
              itemCount: box.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var data = box.values.toList().cast<NotesModel>();
                return Card(
                  color: colors[random.nextInt(3)],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data[index].title.toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              InkWell(
                                  onTap: () {
                                    _editDialog(
                                        data[index],
                                        data[index].title.toString(),
                                        data[index].descriptions.toString());
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  )),
                              const SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                  onTap: () {
                                    delete(data[index]);
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                          Text(
                            data[index].descriptions.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          )
                        ]),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editDialog(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionsController.text = description;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionsController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    notesModel.title = titleController.text.toString();
                    notesModel.descriptions =
                        descriptionsController.text.toString();

                    notesModel.save();
                    descriptionsController.clear();
                    titleController.clear();

                    Navigator.pop(context);
                  },
                  child: const Text('Edit')),
            ],
          );
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionsController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: titleController.text,
                        descriptions: descriptionsController.text);

                    final box = Boxes.getData();
                    box.add(data);

                    // data.save() ;

                    titleController.clear();
                    descriptionsController.clear();

                    Navigator.pop(context);
                  },
                  child: const Text('Add')),
            ],
          );
        });
  }
}
