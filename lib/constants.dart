import 'package:flutter/material.dart';

class C {
  static String rootlink =
      'https://flutter-notes-595a2-default-rtdb.asia-southeast1.firebasedatabase.app/';

  static Color titleColor = Colors.pink;
  static String noTitlenoNotenoTag =
      'Please enter Title, Note & select Technology';
  static String noTitlenoNote = 'Please enter Title & Note';
  static String noTitlenoTag = 'Please enter Title & select Technology';
  static String noNotenoTag = 'Please enter Note & select Technology';
  static String noTag = 'Please select Technology';
  static SnackBar getSnackBar(String msg) {
    final snackBar = SnackBar(
      content:  Text(msg),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    return snackBar;
  }
}
