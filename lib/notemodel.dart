// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  late String id;
  late String title;
  late String tags = '';
  late String subtags = '';
  late String note;
  late String bullets;
  late String code = '';
  late DateTime time;
  late int epoch;

  Note(this.title, this.note);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'tags': tags,
      'subtags': subtags,
      'note': note,
      'bullets':bullets,
      'code': code,
      'time': time,
      'epoch': epoch
    };
  }

  static Note fromJson(Map<String, dynamic> data) {
    Note note = Note(data['title'], data['note']);
    note.id = data['id'];
    note.epoch = 0;
    note.tags = data['tags'];
  note.bullets = data['bullets'];
    note.subtags = data['subtags'];
    Timestamp t = data['time'];
    note.time = t.toDate();
    note.code = data['code'];

    return note;
  }
}
