import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notekeeper_flutter/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}notes.db';

    final Database notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT);');
  }

  // CRUD operations

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    final Database db = await this.database;

    final List<Map<String, dynamic>> result =
        await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    final Database db = await this.database;

    final int result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    final Database db = await this.database;

    final int result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: <dynamic>[note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    final Database db = await this.database;

    final int result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    final Database db = await this.database;
    final List<Map<String, dynamic>> queryCount =
        await db.rawQuery('SELECT COUNT(*) FROM $noteTable');

    final int result = Sqflite.firstIntValue(queryCount);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    final List<Map<String, dynamic>> noteMapList = await getNoteMapList();
    final List<Note> noteList = List<Note>();

    for (int index = 0; index < noteMapList.length; index++) {
      noteList.add(Note.fromMapObject(noteMapList[index]));
    }

    return noteList;
  }
}
