import 'package:flutter/material.dart';
import 'package:notekeeper_flutter/screens/note_list.dart';

void main() => runApp(NoteKeeperApp());

class NoteKeeperApp extends StatelessWidget {
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
