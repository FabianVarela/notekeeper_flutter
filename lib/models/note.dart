class Note {
  int _id;
  String _title;
  String _description;
  int _priority;
  String _date;

  Note(this._title, this._priority, this._date, [this._description]);

  Note.withId(this._id, this._title, this._priority, this._date,
      [this._description]);

  int get id => this._id;

  String get title => this._title;

  set title(String title) {
    if (title.length <= 255) {
      this._title = title;
    }
  }

  String get description => this._description;

  set description(String description) {
    if (description.length <= 255) {
      this._description = description;
    }
  }

  int get priority => this._priority;

  set priority(int priority) {
    if (priority >= 1 && priority <= 2) {
      this._priority = priority;
    }
  }

  String get date => this._date;

  set date(String date) {
    this._date = date;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map)
      : this._id = map['id'],
        this._title = map['title'],
        this._description = map['description'],
        this._priority = map['priority'],
        this._date = map['date'];
}
