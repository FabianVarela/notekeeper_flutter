import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
        textTheme: GoogleFonts.titilliumWebTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: Colors.orange,
        backgroundColor: Colors.white,
        accentColor: Colors.orangeAccent,
        indicatorColor: Colors.blueGrey,
        errorColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.black54),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: GoogleFonts.titilliumWeb(),
        ),
      ),
      home: NoteList(),
    );
  }
}
