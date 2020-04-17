import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper_flutter/common/custom_clipper.dart';
import 'package:notekeeper_flutter/database/database_helper.dart';
import 'package:notekeeper_flutter/models/note.dart';

class NoteDetail extends StatefulWidget {
  NoteDetail(this.note, this.appBarTitle);

  final String appBarTitle;
  final Note note;

  @override
  State<StatefulWidget> createState() => NoteDetailState();
}

class NoteDetailState extends State<NoteDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static List<String> _priorities = <String>['High', 'Low'];

  DatabaseHelper _helper = DatabaseHelper();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.note.title;
    _descriptionController.text = widget.note.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _moveToLastScreen('');
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _setHeader(),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: _setDropDown(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: _setTextField(_titleController, 'Title',
                            'Please enter title value'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: _setTextField(_descriptionController,
                            'Description', 'Please enter description value', 5),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: _setButton('Save', _save)),
                            if (widget.note.id != null) SizedBox(width: 5),
                            if (widget.note.id != null)
                              Expanded(child: _setButton('Delete', _delete)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _setHeader() {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: 180,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 32,
                    color: Theme.of(context).backgroundColor,
                  ),
                  onPressed: () => _moveToLastScreen(''),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.appBarTitle,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _setDropDown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).indicatorColor,
          ),
          value: _getPriorityAsString(widget.note.priority),
          items: _priorities.map((String dropDownListItem) {
            return DropdownMenuItem<String>(
              value: dropDownListItem,
              child: Text(
                dropDownListItem,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            );
          }).toList(),
          onChanged: (String valueSelected) {
            setState(() => _updatePriorityAsInt(valueSelected));
          },
        ),
      ),
    );
  }

  Widget _setTextField(
      TextEditingController controller, String title, String message,
      [int maxLines = 1]) {
    return TextFormField(
      controller: controller,
      cursorColor: Theme.of(context).indicatorColor,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).indicatorColor,
      ),
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w100,
          color: Theme.of(context).indicatorColor,
        ),
        errorStyle: TextStyle(fontSize: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      validator: (String value) => value.isEmpty ? message : null,
    );
  }

  Widget _setButton(String text, Function function) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      textColor: Theme.of(context).backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Text(
        text,
        textScaleFactor: 1.5,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: Theme.of(context).backgroundColor,
        ),
      ),
      onPressed: function,
    );
  }

  String _getPriorityAsString(int value) {
    switch (value) {
      case 1:
        return _priorities[0];
      case 2:
        return _priorities[1];
      default:
        return '';
    }
  }

  void _moveToLastScreen(String message) => Navigator.pop(context, message);

  void _updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        widget.note.priority = 1;
        break;
      case 'Low':
        widget.note.priority = 2;
        break;
    }
  }

  void _save() async {
    if (_formKey.currentState.validate()) {
      widget.note.title = _titleController.text;
      widget.note.description = _descriptionController.text;
      widget.note.date = DateFormat.yMMMd().format(DateTime.now());

      int result;
      if (widget.note.id != null) {
        result = await _helper.updateNote(widget.note);
      } else {
        result = await _helper.insertNote(widget.note);
      }

      if (result != 0) {
        _moveToLastScreen('Note saved successfully!!!');
      } else {
        _showAlertDialog('Status', 'An error has ocurred saving note');
      }
    }
  }

  void _delete() async {
    final int result = await _helper.deleteNote(widget.note.id);
    if (result != 0) {
      _moveToLastScreen('Note deleted successfully!!!');
    } else {
      _showAlertDialog('Status', 'An error has ocurred deleting note');
    }
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
