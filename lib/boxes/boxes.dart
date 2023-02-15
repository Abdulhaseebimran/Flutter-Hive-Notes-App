import 'package:flutter_hive_nosql/models/notes_models.dart';
import 'package:hive/hive.dart';

class Boxes{

  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}