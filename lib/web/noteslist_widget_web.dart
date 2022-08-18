import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:stick_box/web/notebox_web.dart';
import 'package:stick_box/web/search_filter_web.dart';
import '../utils/provder.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/web/search_bar_web.dart';

import '../utils/provder.dart';
import '../utils/theme.dart';
class NotesListWidgetWeb extends StatelessWidget {
  const NotesListWidgetWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        Data _data = Provider.of<Data>(context);
    return  Expanded(
        child: ListView.builder(
            itemCount: _data.noteslist.length,
            itemBuilder: (c, i) {
              return NoteBoxWeb(i);
            }));
  }
}