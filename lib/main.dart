import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notekeeper_flutter/screens/note_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Keeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Titillium',
        primaryColor: Colors.orange,
        backgroundColor: Colors.white,
        accentColor: Colors.orangeAccent,
        indicatorColor: Colors.blueGrey,
        errorColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.black54),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: NoteList(),
    );
  }
}
