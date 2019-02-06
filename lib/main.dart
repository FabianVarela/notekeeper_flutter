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
        primarySwatch: Colors.orange
      ),
      home: NoteList()
    );
  }
}
