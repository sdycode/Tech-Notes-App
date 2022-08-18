import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/web/add_note_code_web.dart';

import '../constants/sizes.dart';
import '../models/notemodel.dart';
import '../utils/provder.dart';
import '../web/main_web_screen.dart';

class WebScreen extends StatefulWidget {
  WebScreen({Key? key}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {

  late Data _data;
 
  StateSetter webState = (fn) {};
  @override
  Widget build(BuildContext context) {
    _data = Provider.of(context, listen: false);
    return FutureBuilder(
      future: _data.getallServerNotes(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          _data.fullNoteslist = snapshot.data as List<Note>;
          _data.noteslist = List.from(_data.fullNoteslist);

          return LayoutBuilder(builder: (context, constraits) {
            _data.webh = constraits.maxHeight;
            _data.webw = constraits.maxWidth;
            _data.webMainW = _data.webw * _data.webMainWFactor;
            _data.webSideW = _data.webw * _data.webSideWFactor;
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter wtState) {
              webState = wtState;
             Data webData = Provider.of<Data>(context);
            ;

              return Container(
                width: _data.webw,
                height: _data.webh,
                // color: Colors.pink,
                child: Row(
                  children: [
                    MainScreenWeb(),
                    (_data.webw / _data.webh) > 1.5 ? AddCoodeNoteWeb() : Container()
                  ],
                ),
              );
            });
          });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
