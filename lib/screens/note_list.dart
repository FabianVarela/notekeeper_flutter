import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notekeeper_flutter/database/database_helper.dart';
import 'package:notekeeper_flutter/models/note.dart';
import 'package:notekeeper_flutter/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Note> _noteList;

  @override
  void initState() {
    super.initState();

    _noteList = List<Note>();
    _updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            _setHeader(),
            _noteList.isNotEmpty ? _createNoteList() : _createEmptyMessage(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add note',
        child: Icon(Icons.add),
        onPressed: () => _navigateToDetail(Note('', 2, ''), 'Add note'),
      ),
    );
  }

  Widget _setHeader() {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                'My notes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ),
            CircleAvatar(
              child: Icon(Icons.account_circle, size: 40),
            )
          ],
        ),
      ),
    );
  }

  Widget _createEmptyMessage() {
    return Container(
      height: MediaQuery.of(context).size.height * .85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Icon(
              Icons.lightbulb_outline,
              size: 150,
            ),
          ),
          Text(
            'It\'s alone. Add a note',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).indicatorColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createNoteList() {
    return RefreshIndicator(
      key: GlobalKey<RefreshIndicatorState>(),
      onRefresh: () async => _updateListView(),
      child: Container(
        height: MediaQuery.of(context).size.height * .85,
        child: StaggeredGridView.countBuilder(
          padding: EdgeInsets.zero,
          crossAxisCount: 4,
          shrinkWrap: true,
          itemCount: _noteList.length,
          itemBuilder: (_, int index) => _createNoteItem(_noteList[index]),
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        ),
      ),
    );
  }

  Widget _createNoteItem(Note note) {
    return Card(
      elevation: 5,
      color: note.priority == 1 ? Color(0xFFCF5136) : Color(0xFFCFC336),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: GestureDetector(
        onTap: () => _navigateToDetail(note, 'Edit note'),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  note.date,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(note.priority == 1
                      ? Icons.arrow_upward
                      : Icons.arrow_downward),
                  GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () => _delete(note),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(Note note, String title) async {
    final String result = await Navigator.push(
      context,
      PageRouteBuilder<String>(
        pageBuilder: (_, __, ___) => NoteDetail(note, title),
        transitionsBuilder: (_, Animation<double> anim1, __, Widget child) {
          final Offset begin = Offset(0.0, 1.0);
          final Offset end = Offset.zero;

          final Animatable<Offset> tween = Tween<Offset>(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.ease));

          return SlideTransition(
            position: anim1.drive(tween),
            child: child,
          );
        },
      ),
    );

    if (result.isNotEmpty) {
      _showAlertDialog('Status', result);
      _updateListView();
    }
  }

  void _delete(Note note) async {
    final int result = await _databaseHelper.deleteNote(note.id);

    if (result != 0) {
      _showSnackBar('Note delete successfully');
      _updateListView();
    }
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      duration: Duration(seconds: 3),
    ));
  }

  void _updateListView() {
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();

    dbFuture.then((Database database) {
      final Future<List<Note>> noteListFuture = _databaseHelper.getNoteList();
      noteListFuture.then((List<Note> noteList) {
        setState(() => this._noteList = noteList);
      });
    });
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
    );
  }
}
