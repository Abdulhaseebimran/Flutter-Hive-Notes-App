import 'package:flutter/material.dart';
import 'package:flutter_hive_nosql/models/notes_models.dart';
import 'package:flutter_hive_nosql/screens/home_screen.dart';
import 'package:flutter_hive_nosql/screens/notes_screen.dart';
import 'package:flutter_hive_nosql/screens/splash_screens.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NotesModelAdapter()) ;
  await Hive.openBox<NotesModel>('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hive NoSql Database',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.red,
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const NotesScreen(),
      },
    );
  }
}
