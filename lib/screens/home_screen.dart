import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Database"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: Hive.openBox('users'),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(snapshot.data!.get('name').toString()),
                      subtitle: Text(snapshot.data!.get('age').toString()),
                      trailing: Wrap(
                        spacing: 8,
                      children: [
                      IconButton(
                        onPressed: () {
                          Text(snapshot.data!.put('name', 'HASEEB').toString());
                          Text(snapshot.data!.put('age', 20).toString());
                          setState(() {});
                        },
                        icon: const Icon(Icons.edit,color: Colors.blue,),
                      ),
                      IconButton(
                        onPressed: () {
                          Text(snapshot.data!.delete('name', ).toString());
                          Text(snapshot.data!.delete('age', ).toString());
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete, color: Colors.red,),
                      ),
                      ],
                      ),
                    )
                  ],
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var box = await Hive.openBox("users");
          await box.put('name', 'abdul haseeb');
          await box.put('age', 20);

          await box
              .put('details', {'pro': 'developer', 'nationality': 'Pakistan'});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
