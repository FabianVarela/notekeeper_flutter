import 'package:flutter/material.dart';
import 'package:notekeeper_flutter/screens/note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add note',
        child: Icon(Icons.add),
        onPressed: () {
          navigateToDetail('Add note');
        }
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right)
            ),
            title: Text('Dummy Title', style: titleStyle),
            subtitle: Text('Dummy date'),
            trailing: Icon(Icons.delete, color: Colors.grey),
            onTap: () {
             navigateToDetail('Edit note');
            }
          )
        );
      }
    );
  }

  void navigateToDetail(String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(title);
    }));
  }
}
