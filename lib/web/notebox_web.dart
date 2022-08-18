import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stick_box/web/search_filter_web.dart';
import '../constants/globals.dart';
import '../services/data_firebase.dart';
import '../utils/provder.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/web/search_bar_web.dart';

import '../utils/provder.dart';
import '../utils/theme.dart';
import 'tilesubpartheading_web.dart';

class NoteBoxWeb extends StatefulWidget {
  int i;
  NoteBoxWeb(this.i, {Key? key}) : super(key: key);

  @override
  State<NoteBoxWeb> createState() => _NoteBoxWebState(i);
}

class _NoteBoxWebState extends State<NoteBoxWeb> {
  int i;
  _NoteBoxWebState(this.i);
  late Data _data;
  @override
  Widget build(BuildContext context) {
     _data = Provider.of<Data>(context);
    ScrollController controller = ScrollController();
    double tileW =
        (_data.webw / _data.webh) > 1.5 ? _data.webMainW : _data.webw;

    double indent = tileW * 0.1;
    double endIndent = tileW * 0.02;
    if (!kIsWeb) {
      indent = tileW * 0.15;
      double endIndent = tileW * 0.04;
    }
    String subtitlemaintags = _data.noteslist[i].tags.replaceAll('__', ', ');
    String subtitlesubtags = _data.noteslist[i].subtags.replaceAll('__', ', ');
    List<String> bulltesInTile = _data.noteslist[i].bullets.split('__');
    List<String> fullcodes = _data.noteslist[i].code.split('__');
    List<List<String>> codepairs = [];
    fullcodes.forEach((e) {
      List pair = e.split('_*_');
      print(' pair $pair');
      if (pair.length > 1) {
        codepairs.add([pair[0], pair[1]]);
      }
    });

    return ClipRRect(
      borderRadius: BorderRadius.circular(_data.h * 0.02),
      child: Container(
        width: tileW,
        margin: EdgeInsets.all(tileW * 0.01),
        decoration: BoxDecoration(color: _data.myColors.expansionboxbg,
            //  Color.fromARGB(255, 242, 238, 202),
            boxShadow: [BoxShadow(offset: Offset(0.5, 0.5))]),
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.platform,
          iconColor: _data.myColors.addpasteicon,
          collapsedIconColor: _data.myColors.addpasteicon,
          maintainState: true,
          textColor: _data.myColors.normaltext,
          collapsedTextColor: _data.myColors.normaltext,
          title: SingleChildScrollView(
            child: Text(
              _data.noteslist[i].title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _data.webh * 0.028,
              ),
            ),
          ),
          subtitle: SingleChildScrollView(
            child: Text(
              subtitlemaintags,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _data.webh * 0.02,
                color: Colors.grey,
              ),
            ),
          ),
          tilePadding: EdgeInsets.all(tileW * 0.005),
          children: [
            Container(
              // color: Colors.pink.shade200,
              width: tileW * 0.98,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: indent,
                    child: Text(
                      'subtag',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        // fontSize: _data.webh * 0.045,
                        fontSize: _data.webh * 0.015,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                      // width: double.maxFinite,
                      // _data.isAdmin ? tileW * 0.84 : tileW * 0.98,
                      child: SingleChildScrollView(child: Text(
                          // 'et firestore insta {tags: Native__Other, id: 8dkR0mby1U5mxHDH926z, note: xcxc, code: xzxz_*_vxvcvc__cxx_*___cxcxcx, epoch: 1654948691682, subtags: cxd__dfdf, bullets: dfdfsfd__dfdcxcxxxc__xcx__cxcx__cxcxcxcxcx, title: cxcx, time: Timestamp(seconds=1654948691, nanoseconds=682000000)}'

                          subtitlesubtags))),
                  // Spacer(),
                  (_data.isAdmin || _data.showOnlyMyNotes)
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: tileW * 0.04,
                          onPressed: () {
                            _data.editingNote = _data.noteslist[i];
                            _data.isNoteEditing = true;
                            _data.loadThisDataInEditingBox();
                            if (!kIsWeb) {
                              _data.showSheet = true;
                            }
                          },
                          icon: Icon(Icons.edit,
                              color: Colors.deepPurple, size: _data.h * 0.034))
                      : Container(),
                  _data.isAdmin || _data.showOnlyMyNotes
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: tileW * 0.04,
                          onPressed: () async {
                            await askToDelete(i);

                            _data.refresh();
                          },
                          icon: Icon(Icons.delete,
                              color: Colors.red, size: _data.h * 0.034))
                      : Container()
                ],
              ),
            ),
            Divider(
              color: _data.myColors.normaltext,
              indent: indent,
              endIndent: endIndent,
            ),
            Row(
              children: [
                TileSubpartHeading('Note', indent),
                Expanded(
                  child: Text(
                    _data.noteslist[i].note,
                    style: TextStyle(
                        // fontWeight: FontWeight.w500,
                        // fontSize: _data.webh * 0.015,
                        color: _data.myColors.normaltext),
                  ),
                ),
              ],
            ),
            Divider(
              color: _data.myColors.normaltext,
              indent: indent,
              endIndent: endIndent,
            ),
            Container(
              width: tileW,
              child: Row(
                children: [
                  TileSubpartHeading('Bullets', indent),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...(bulltesInTile.asMap().entries.map((e) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              (e.key + 1).toString() + '. ',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Expanded(child: Text(e.value))
                          ],
                        );
                      }).toList())
                    ],
                  )),
                ],
              ),
            ),
            Divider(
              color: _data.myColors.normaltext,
              indent: indent,
              endIndent: endIndent,
            ),
            Row(
              children: [
                TileSubpartHeading('Code', indent),
                Container(
                    width: tileW * 0.98 - indent,
                    height: _data.webh * 0.3,
                    // color: Colors.brown,
                    child: Scrollbar(
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      controller: controller,
                      showTrackOnHover: true,
                      child: ListView.builder(
                          shrinkWrap: true,
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          itemCount: codepairs.length,
                          // itemCount: 5,
                          itemBuilder: (c, i) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(codepairs[i][0]),

                                      // Text('fdfdsf$i'),
                                      // Divider(
                                      //   indent: 10,
                                      //   thickness: 3,
                                      //   endIndent: 10,
                                      // ),

                                      ConstrainedBox(
                                        constraints: BoxConstraints.loose(
                                            Size(tileW * 0.2, 1)),
                                        child: Container(
                                          height: 1,
                                          color: Colors.black,
                                          width: double.maxFinite,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(codepairs[i][1]),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  color: _data.myColors.normaltext,
                                  indent: 20,
                                  endIndent: 20,
                                )
                              ],
                            );
                          }),
                    )),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ' -  ' + _data.noteslist[i].author.split('@').first,
                  style: TextStyle(
                      color: isDarkTheme()
                          ? Color.fromARGB(255, 149, 232, 233)
                          : Color.fromARGB(255, 4, 38, 159),
                      fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  askToDelete(int i) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Do you want to delete this note ?',
                    style: TextStyle(fontSize: _data.h * 0.025),
                  ),
                  Text(
                    _data.noteslist[i].title,
                    style: TextStyle(fontSize: _data.h * 0.022, color: Colors.grey),
                  )
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    // print('note deleted');
                    DataService().noteInstance.doc(_data.noteslist[i].id).delete();
                    _data.noteslist.removeAt(i);
                    Navigator.pop(context);
                    _data.refresh();
                  },
                ),
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
