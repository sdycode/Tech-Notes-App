// ignore_for_file: unnecessary_statements

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stick_box/constants/globals.dart';
import 'package:stick_box/main.dart';
import 'package:stick_box/models/notemodel.dart';
import 'package:stick_box/screens/web_screen.dart';
import 'package:stick_box/services/data_firebase.dart';
import 'package:stick_box/utils/provder.dart';
import 'package:stick_box/utils/snackbar.dart';
import 'package:stick_box/utils/theme.dart';
import 'package:stick_box/web/main_web_screen.dart';
import 'package:stick_box/widgets/app_drawer.dart';

import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../services/local_notification_service.dart';
import '../utils/shared.dart';
import '../widgets/add_icon.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  FocusNode _androidFocusNode = FocusNode();
  late TabController tabController = TabController(length: 3, vsync: this);
  // ScrollController notescrollController =
  //     ScrollController(initialScrollOffset: 0);
  ScrollController maintagsscrollController =
      ScrollController(initialScrollOffset: 0);
  ScrollController filterScrollController =
      ScrollController(initialScrollOffset: 0);
  Note _editingNote = Note('', '');
  Map<int, String> _technologiesList = {};
  Map<int, String> _filteredTechnologiesList = {};
  List<String> bullets = [];
  List<String> filters = [
    'All',
    'Technology',
    'Title',
    'Tag',
    'Notes',
    'Bullets',
    'Code Title'
  ];

  bool showOnlyMyNotes = false;
  bool isAdmin = false;
  bool isCodeEditing = false;

  bool isNoteEditing = false;
  int editCodeIndex = -1;
  int codetabindex = -1;
  int tabIndex = 0;
  double h = Sizes().sh;
  double w = Sizes().sw;
  double webh = Sizes().sh;
  double webw = Sizes().sw;
  List<String> subtags = [];
  List<String> codetabbtnnames = [];
  List<String> codes = [];
  List<String> maintags = [];
  double webMainWFactor = 0.55;
  double webSideWFactor = 0.45;

  double webMainW = Sizes().sw * 0.55;
  double webSideW = Sizes().sw * 0.45;

  List<String> selectedFilters = ['All'];
  String data = '';

  late Data webData;
  late Data androidData;
  late Data _data;
  @override
  void initState() {
    super.initState();
    Data dataNolisten = Provider.of<Data>(context, listen: false);
    dataNolisten.tabController = TabController(length: 3, vsync: this);
    isAdmin = Shared.isAdmin;
    tabController = TabController(length: 3, vsync: this);
  }

  List<Note> noteslist = [];
  List<Note> fullNoteslist = [];
  TextEditingController noteController = TextEditingController();
  TextEditingController codeTitleController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController bulletController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtagController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController mainTagsearchController = TextEditingController();
  bool showSheet = false;
  StateSetter state = (d) {};
  StateSetter androidState = (d) {};
  StateSetter webState = (d) {};
  late MyColors myColors;
  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    Data _data = Provider.of<Data>(context, listen: false);
    myColors = Theme.of(context).extension<MyColors>()!;
    themeData = Theme.of(context);
    _data.setMyColors(myColors);
    _data.setThemeData(themeData);
    _data.setMainContext(context);
    return WillPopScope(
      onWillPop: () async {
        if (FirebaseAuth.instance.currentUser == null) {
          return true;
        } else {
          exit(0);
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: themeData.backgroundColor,
          key: _data.scaffoldKey,
          drawer: AppDrawer(),
          body: kIsWeb ? 
          WebScreen()
          // webCode()
           : androidCode(),
          resizeToAvoidBottomInset: false,
        ),
      ),
    );
  }

  Future updateNote() async {
    String code = '';
    for (int i = 0; i < codes.length; i++) {
      code += codetabbtnnames[i] + '_*_';
      code += codes[i];
      final s = i < codes.length - 1 ? '__' : '';
      code += s;
    }
    String bulletText = '';
    for (int i = 0; i < bullets.length; i++) {
      bulletText += bullets[i];

      final b = i < bullets.length - 1 ? '__' : '';
      bulletText += b;
    }

    String subtagsText = '';
    for (int i = 0; i < subtags.length; i++) {
      subtagsText += subtags[i];

      final t = i < subtags.length - 1 ? '__' : '';
      subtagsText += t;
    }
    String tagText = '';
    for (int i = 0; i < maintags.length; i++) {
      tagText += maintags[i];

      final t = i < maintags.length - 1 ? '__' : '';
      tagText += t;
    }
    print('tagtext $tagText');
    final docNote = DataService().noteInstance.doc(_editingNote.id);
    Note note = Note(titleController.text, noteController.text);
    note.code = code;
    note.tags = tagText;
    note.id = docNote.id;
    note.bullets = bulletText;

    note.subtags = subtagsText;
    note.epoch = DateTime.now().millisecondsSinceEpoch;
    note.time = DateTime.now();
    if (kIsWeb) {
      note.author = _editingNote.author;
    } else {
      note.author = _editingNote.author;
    }
    fullNoteslist.removeWhere((e) {
      return e.id == _editingNote.id;
    });
    fullNoteslist.add(note);
    final json = note.toJson();
    await docNote.update(json);
  }

  Future addNote() async {
    String code = '';
    for (int i = 0; i < codes.length; i++) {
      code += codetabbtnnames[i] + '_*_';
      code += codes[i];
      final s = i < codes.length - 1 ? '__' : '';
      code += s;
    }
    String bulletText = '';
    for (int i = 0; i < bullets.length; i++) {
      bulletText += bullets[i];

      final b = i < bullets.length - 1 ? '__' : '';
      bulletText += b;
    }

    String subtagsText = '';
    for (int i = 0; i < subtags.length; i++) {
      subtagsText += subtags[i];

      final t = i < subtags.length - 1 ? '__' : '';
      subtagsText += t;
    }
    String tagText = '';
    for (int i = 0; i < maintags.length; i++) {
      tagText += maintags[i];

      final t = i < maintags.length - 1 ? '__' : '';
      tagText += t;
    }
    print('tagtext $tagText');
    final docNote = DataService().noteInstance.doc();
    Note note = Note(titleController.text, noteController.text);
    note.code = code;
    note.tags = tagText;
    note.id = docNote.id;
    note.bullets = bulletText;

    note.subtags = subtagsText;
    note.epoch = DateTime.now().millisecondsSinceEpoch;
    note.time = DateTime.now();
    note.author = getCurrentUserEmailId();
    fullNoteslist.add(note);
    final json = note.toJson();
    await docNote.set(json);

    // setState(() {});
  }

  // Future<List<Note>>
  Future<List<Note>> getallServerNotes() async {
    try {
      await DataService()
          .noteInstance
          .get(GetOptions(source: Source.serverAndCache))
          .then(
        (value) {
          fullNoteslist.clear();
          QuerySnapshot<Map<String, dynamic>> f = value;
          print('data ${value.docs.length}');
          print("get firestore insta ${f.docs.first.data()}");
          // value.docChanges.first.doc.
          value.docs.forEach((e) {
            print(e.data());
            // Timestamp t = e.data()['time'];
            // DateTime d = t.toDate();
            Note note = Note.fromJson(e.data());
            // note.time = d;
            // print('doc ${d}');
            fullNoteslist.add(note);
          });
        },
      );
    } catch (e) {
      showSnack(context, 'Error $e');
    }
    await getMainTags();
    return fullNoteslist;
  }

  Future<List<Note>> getallCacheNotes() async {
    // if (fullNoteslist.length < 1) {
    //  DataService().noteInstance
    QuerySnapshot<Map<String, dynamic>>? value;
    await FirebaseFirestore.instance.disableNetwork();
    await FirebaseFirestore.instance.enableNetwork();
    try {
      value = await DataService()
          .noteInstance
          .get(GetOptions(source: Source.serverAndCache));
    } catch (e) {
      print('notes err $e');
      //  notes err [cloud_firestore/unavailable] The service is currently unavailable. This is a most likely a transient condition and may be corrected by retrying with a backoff.
      showSnackbar('notes err $e');
    }
    if (value != null) {
      fullNoteslist.clear();

      print('data ${value.docs.length}');
      print("get firestore insta ${value.docs.first.data()}");

      value.docs.forEach((e) {
        print(e.data());

        Note note = Note.fromJson(e.data());

        fullNoteslist.add(note);
      });
    }

    await getMainTags();

    return fullNoteslist;
  }

  Future getDatatoJsonAndShareJsonFile() async {
    var dir = await getExternalStorageDirectory();
    var path = dir!.path;
    // var no = (DateTime.now().millisecondsSinceEpoch / 10000).toString();
    File newjsonFile = File('$path/1000_file.json');
    Map sampleMap = {};
    print('ffff ${newjsonFile.path}');
    fullNoteslist.forEach((e) {
      sampleMap[e.id.toString()] = e.toJsonWithStringValues();
      // sampleMap = e.toJsonWithStringValues();
      // print('kson data ${e.toJsonWithStringValues()}');
    });
    print('kson data ${sampleMap}');
    File f = await newjsonFile.writeAsString(jsonEncode(sampleMap));
    // // File f = await newjsonFile.writeAsString('nod ddattt');
    // print('ffff afer  ${f.path}');
    await Share.shareFiles([f.path]);
  }

  Widget addBottomSheetAndroid(BuildContext context) {
    return Container(
        height: h * 0.9,
        width: w,
        margin: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(w * 0.04),
          ),
          color: themeData.cardColor,
        ),
        child: Stack(
          children: [
            Container(
              height: h * 0.74,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(w * 0.08 * 0)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: w * 0.01,
                        color: Colors.transparent,
                      ),
                      Container(
                        width: w,
                        // height: h*0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            selectTechButton(),
                            maintags.isNotEmpty
                                ? Expanded(child: _mainTagsChipsRow())
                                : Container(),
                          ],
                        ),
                      ),

                      // tagsRow(),
                      titleWidget(),
                      //  tagWidget(),
                      subtagWidget(),
                      subtagsRow(),
                      tabRow(),
                      SizedBox(
                        height: h * 0.005,
                      ),
                      tabs(),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: MediaQuery.of(context).viewInsets.bottom < 1
                  ? bottomButtons()
                  : Container(),
            )
          ],
        ));
  }

  titleWidget() {
    return kIsWeb
        ? Container(
            width: webSideW * (1 - 0.05),
            margin:
                EdgeInsets.only(left: webSideW * 0.02, right: webSideW * 0.02),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: webSideW -
                        webSideW * 0.08 -
                        webSideW * 0.08 -
                        webSideW * 0.02 -
                        webSideW * 0.05,
                    child: TextField(
                      controller: titleController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      minLines: 1,
                      expands: false,
                      cursorColor: myColors.labeltext,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: myColors.labeltext),
                          labelText: 'Title',
                          contentPadding:
                              EdgeInsets.only(left: webSideW * 0.02),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: myColors.textfieldFocusborder ??
                                      themeData.primaryColor),
                              borderRadius: BorderRadius.circular(h * 0.02)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: myColors.textfieldborder ??
                                      themeData.primaryColor),
                              borderRadius: BorderRadius.circular(h * 0.02)),
                          suffixIcon: IconButton(
                            iconSize: webh * 0.035,
                            onPressed: () {
                              webState(() {
                                titleController.clear();
                              });
                            },
                            icon: FittedBox(
                              child: closeIcon(),
                            ),
                          )),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        width: webSideW * 0.08,
                        padding: EdgeInsets.all(webh * 0.005),
                        height: webh * 0.05,
                        child: FittedBox(
                            child: Image.asset(
                          'assets/paste1.png',
                        ))),
                  ),
                ]),
          )
        : Container(
            width: double.infinity,
            // height: h * 0.06,
            margin: EdgeInsets.all(w * 0.02),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: w - w * 0.12 - w * 0.08 - w * 0.06,
                    //  height: h*0.06,

                    child: TextField(
                      style: TextStyle(color: myColors.labeltext),
                      controller: titleController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      minLines: 1,
                      expands: false,
                      cursorColor: Colors.pink,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.pink),
                          labelText: 'Title',
                          isCollapsed: false,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: C.titleColor.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(h * 0.02)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: C.titleColor.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(h * 0.02)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              androidState(() {
                                titleController.clear();
                              });
                            },
                            icon: FittedBox(
                              child: closeIcon(),
                            ),
                          )),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        // color: Colors.purple,
                        width: w * 0.12,
                        padding: EdgeInsets.all(h * 0.005),
                        height: h * 0.05,
                        child:
                            FittedBox(child: Image.asset('assets/paste1.png'))),
                  ),
                ]),
          );
  }

  tagsRow() {
    // maintagsscrollController.addListener(() {
    //   webState(() {});
    // });
    return kIsWeb
        ? Container(
            height: webh * 0.1,
            width: webSideW,
            margin:
                EdgeInsets.only(left: webSideW * 0.02, right: webSideW * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: webSideW * 0.01),
                  child: Text(
                    'Technology',
                    style: TextStyle(
                        color: myColors.fainttext, fontSize: webh * 0.02),
                  ),
                ),
                Container(
                  height: webh * 0.07,
                  width: webSideW,
                  child: Scrollbar(
                    scrollbarOrientation: ScrollbarOrientation.bottom,
                    // isAlwaysShown: true,
                    controller: maintagsscrollController,
                    child: ListView.builder(
                        controller: maintagsscrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: maintags.length,
                        itemBuilder: (c, i) {
                          return mainTag(i);
                        }),
                  ),
                ),
              ],
            ),
          )
        :

        // Android Mobile
        Container(
            height: h * 0.05,
            width: w,
            margin: EdgeInsets.only(left: w * 0.02, right: w * 0.02),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: maintags.length,
                itemBuilder: (c, i) {
                  return mainTag(i);
                }),
          );
  }

  subtagWidget() {
    return kIsWeb
        ? Container(
            width: webSideW * (1 - 0.1),
            height: webh * 0.08,
            margin: EdgeInsets.all(webSideW * 0.02),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                width: webSideW -
                    webSideW * 0.12 -
                    webSideW * 0.06 -
                    webSideW * 0.12,
                //  height: h*0.06,

                child: TextField(
                  style: TextStyle(color: myColors.labeltext),
                  controller: subtagController,
                  decoration: InputDecoration(
                      labelText: 'Subtags',
                      labelStyle: TextStyle(color: myColors.labeltext),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: myColors.textfieldFocusborder ??
                                  themeData.primaryColor),
                          borderRadius: BorderRadius.circular(h * 0.02)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: myColors.textfieldborder ??
                                  themeData.primaryColor),
                          borderRadius: BorderRadius.circular(h * 0.02)),
                      suffixIcon: IconButton(
                        iconSize: webh * 0.035,
                        onPressed: () {
                          webState(() {
                            subtagController.text = '';
                          });
                        },
                        icon: FittedBox(
                          child: closeIcon(),
                        ),
                      )),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {},
                child: Container(
                    // color: Colors.purple,
                    width: webSideW * 0.08,
                    padding: EdgeInsets.all(webh * 0.005),
                    height: webh * 0.05,
                    child: FittedBox(child: Image.asset('assets/paste1.png'))),
              ),
              InkWell(
                onTap: () {
                  webState(() {
                    bool spacecount = subtagController.text.characters
                        .containsAll(Characters(' '));
                    List l = subtagController.text.split(' ');
                    print('space $spacecount');
                    if (l.length + 1 < subtagController.text.length) {
                      if (subtagController.text.isNotEmpty)
                        subtags.add(subtagController.text);
                      subtagController.text = '';
                    }
                  });
                },
                child: Container(
                    // color: Colors.purple,
                    width: webSideW * 0.08,
                    padding: EdgeInsets.all(webh * 0.002),
                    height: webh * 0.05,
                    child: FittedBox(child: addIcon(myColors))),
              ),
            ]),
          )
        : Container(
            width: double.infinity,
            height: h * 0.06,
            margin: EdgeInsets.all(w * 0.02),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: w - w * 0.12 - w * 0.08 - w * 0.06 - w * 0.12,
                    //  height: h*0.06,

                    child: TextField(
                      style: TextStyle(color: myColors.labeltext),
                      controller: subtagController,
                      decoration: InputDecoration(
                          labelText: 'Subtags',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: myColors.textfieldFocusborder ??
                                      themeData.primaryColor),
                              borderRadius: BorderRadius.circular(h * 0.02)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: myColors.textfieldborder ??
                                      themeData.primaryColor),
                              borderRadius: BorderRadius.circular(h * 0.02)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              androidState(() {
                                subtagController.text = '';
                              });
                            },
                            icon: FittedBox(
                              child: closeIcon(),
                            ),
                          )),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        // color: Colors.purple,
                        width: w * 0.12,
                        padding: EdgeInsets.all(h * 0.005),
                        height: h * 0.05,
                        child:
                            FittedBox(child: Image.asset('assets/paste1.png'))),
                  ),
                  InkWell(
                    onTap: () {
                      androidState(() {
                        bool spacecount = subtagController.text.characters
                            .containsAll(Characters(' '));
                        List l = subtagController.text.split(' ');
                        print('space $spacecount');
                        if (l.length + 1 < subtagController.text.length) {
                          if (subtagController.text.isNotEmpty)
                            subtags.add(subtagController.text);
                          subtagController.text = '';
                        }
                      });
                    },
                    child: Container(
                        // color: Colors.purple,
                        width: w * 0.10,
                        padding: EdgeInsets.all(h * 0.002),
                        height: h * 0.05,
                        child: FittedBox(child: addIcon(myColors))),
                  ),
                ]),
          );
  }

  Widget subtagsRow() {
    return subtags.isNotEmpty
        ? Container(
            margin: kIsWeb
                ? EdgeInsets.only(left: webSideW * 0.02, right: webSideW * 0.02)
                : EdgeInsets.only(left: w * 0.02, right: w * 0.02),
            height: h * 0.05,
            width: double.infinity,
            child: ListView.builder(
                itemCount: subtags.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) {
                  return subtag(i);
                }))
        : Container();
  }

// tagWidget() {
//     return Container(
//       width: double.infinity,
//       height: h * 0.06,
//       margin: EdgeInsets.all(w * 0.03),
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Container(
//           width: w  - w * 0.12 - w * 0.08 -w*0.06,
//           //  height: h*0.06,

//           child: TextField(
//             controller: titleController,
//             decoration: InputDecoration(
//                 labelText: 'Title',
//                 focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         width: 1, color: Color.fromARGB(255, 10, 150, 80)),
//                     borderRadius: BorderRadius.circular(h * 0.02)),
//                 enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         width: 1, color: Color.fromARGB(255, 10, 150, 80)),
//                     borderRadius: BorderRadius.circular(h * 0.02)),
//                 suffixIcon:
//                     IconButton(onPressed: () {}, icon: Icon(Icons.close))),
//           ),
//         ),
//         InkWell(
//           onTap: () {},
//           child: Container(
//               // color: Colors.purple,
//               width: w * 0.12,
//               padding: EdgeInsets.all(h * 0.005),
//               height: h * 0.05,
//               child: FittedBox(child: Image.asset('assets/paste1.png'))),
//         ),
//       ]),
//     );
//   }

  floatingButton() {
    return Container(
      margin: EdgeInsets.all(showSheet ? w * 0.03 : w * 0.07),
      child: InkWell(
        onTap: () {
          showSheet = !showSheet;
          androidData.refresh();
          // androidState(() {

          // });
        },
        child: CircleAvatar(
          backgroundColor: isDarkTheme()
              ? Color.fromARGB(255, 220, 98, 77)
              : Color.fromARGB(255, 19, 10, 58),
          child: Icon(
            Icons.add_card,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  bottomButtons() {
    return kIsWeb
        ? Padding(
            padding: EdgeInsets.only(right: w * 0.02),
            child: Container(
              // color: Colors.purple,
              margin: EdgeInsets.all(h * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      webState(() {
                        noteController.clear();
                        codeTitleController.clear();
                        codeController.clear();
                        bulletController.clear();
                        titleController.clear();
                        subtagController.clear();
                        subtags.clear();
                        bullets.clear();
                        codes.clear();
                        isNoteEditing = false;
                      });
                    },
                    child: Container(
                      height: h * 0.04,
                      margin: EdgeInsets.only(left: w * 0.011),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 0.7,
                                spreadRadius: 0.6,
                                offset: Offset(0.5, 0.5),
                                color: myColors.deleteicon ??
                                    themeData.primaryColor)
                          ],
                          borderRadius: BorderRadius.circular(h * 0.05),
                          color: myColors.deleteicon ?? themeData.primaryColor),
                      child: Padding(
                        padding: EdgeInsets.all(h * 0.005),
                        child: FittedBox(
                          child: Text(
                            '  Clear  ',
                            style: TextStyle(color: themeData.cardColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (checkTextisValid(titleController.text) &&
                          checkTextisValid(noteController.text) &&
                          maintags.isNotEmpty) {
                        if (isNoteEditing) {
                          await updateNote();
                        } else {
                          await addNote();
                        }

                        showSheet = false;
                        updateState();
                        // setState(() {});
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(C.getSnackBar(C.noTitlenoNotenoTag));

                        // if (maintags.isEmpty &&
                        //     !checkTextisValid(titleController.text) &&
                        //     !checkTextisValid(noteController.text)) {
                        //   ScaffoldMessenger.of(context)
                        //       .showSnackBar(C.getSnackBar(C.noTag));
                        // } else if (maintags.isEmpty &&
                        //     checkTextisValid(titleController.text) &&
                        //     !checkTextisValid(noteController.text)) {
                        //   ScaffoldMessenger.of(context)
                        //       .showSnackBar(C.getSnackBar(C.noTitlenoTag));
                        // } else if (maintags.isEmpty &&
                        //     !checkTextisValid(titleController.text) &&
                        //     checkTextisValid(noteController.text)) {
                        //   ScaffoldMessenger.of(context)
                        //       .showSnackBar(C.getSnackBar(C.noNotenoTag));
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //       C.getSnackBar(C.noTitlenoNotenoTag));
                        // }
                      }
                    },
                    child: Container(
                      height: h * 0.04,
                      margin: EdgeInsets.only(left: w * 0.01),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 0.7,
                                spreadRadius: 0.6,
                                offset: Offset(0.5, 0.5),
                                color: Color.fromARGB(255, 19, 187, 24))
                          ],
                          borderRadius: BorderRadius.circular(h * 0.05),
                          color: myColors.pasteicon ?? themeData.primaryColor),
                      child: Padding(
                        padding: EdgeInsets.all(h * 0.005),
                        child: FittedBox(
                          child: Text(
                            isNoteEditing ? ' Update ' : '  Save  ',
                            style: TextStyle(color: myColors.normaltext),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.all(w * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    androidState(() {
                      noteController.clear();
                      codeTitleController.clear();
                      codeController.clear();
                      bulletController.clear();
                      titleController.clear();
                      subtagController.clear();
                      subtags.clear();
                      bullets.clear();
                      codes.clear();
                    });
                  },
                  child: Container(
                    height: h * 0.03,
                    margin: EdgeInsets.only(left: w * 0.04),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0.7,
                              spreadRadius: 0.6,
                              offset: Offset(0.5, 0.5),
                              color: Colors.lightBlue)
                        ],
                        borderRadius: BorderRadius.circular(h * 0.05),
                        color: Color.fromARGB(255, 7, 15, 54)),
                    child: Padding(
                      padding: EdgeInsets.all(h * 0.005),
                      child: FittedBox(
                        child: Text(
                          '  Clear  ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    androidState(() {
                      showSheet = false;
                      isNoteEditing = false;
                      _androidFocusNode.nextFocus();
                    });
                  },
                  child: Container(
                    height: h * 0.03,
                    margin: EdgeInsets.only(left: w * 0.04),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0.7,
                              spreadRadius: 0.6,
                              offset: Offset(0.5, 0.5),
                              color:
                                  myColors.deleteicon ?? themeData.primaryColor)
                        ],
                        borderRadius: BorderRadius.circular(h * 0.05),
                        color: myColors.deleteicon ?? themeData.primaryColor),
                    child: Padding(
                      padding: EdgeInsets.all(h * 0.005),
                      child: FittedBox(
                        child: Text(
                          '  Discard  ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (checkTextisValid(titleController.text) &&
                        checkTextisValid(noteController.text) &&
                        maintags.isNotEmpty) {
                      if (isNoteEditing) {
                        updateNote();
                      } else {
                        addNote();
                      }

                      setState(() {
                        showSheet = false;
                      });
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(C.getSnackBar(C.noTitlenoNotenoTag));
                    }
                  },
                  child: Container(
                    height: h * 0.03,
                    margin: EdgeInsets.only(left: w * 0.04),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0.7,
                              spreadRadius: 0.6,
                              offset: Offset(0.5, 0.5),
                              color:
                                  myColors.pasteicon ?? themeData.primaryColor)
                        ],
                        borderRadius: BorderRadius.circular(h * 0.05),
                        color:
                            // Color
                            myColors.pasteicon ?? themeData.primaryColor),
                    child: Padding(
                      padding: EdgeInsets.all(h * 0.005),
                      child: FittedBox(
                        child: Text(
                          isNoteEditing ? ' Update ' : '  Save & Close  ',
                          style: TextStyle(color: themeData.accentColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget mainTag(int i) {
    bool isTagMarked = maintags.contains(maintags[i]);
    // if(maintags.contains(maintags[i])){}
    return kIsWeb
        ? Transform.scale(
            scale: isTagMarked ? 1.05 : 1,
            child: InkWell(
              onTap: () {
                webState(() {
                  if (!maintags.contains(maintags[i])) {
                    maintags.add(maintags[i]);
                  } else {
                    maintags.remove(maintags[i]);
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: webh * 0.01),
                child: Container(
                    height: webh * 0.1,
                    decoration: BoxDecoration(
                        color: isTagMarked
                            ? myColors.tabbuttonActive
                            : myColors.tabbutton,
                        borderRadius: BorderRadius.circular(webh * 0.05),
                        boxShadow: !isTagMarked
                            ? []
                            : [
                                BoxShadow(
                                    color: myColors.fainttext ??
                                        themeData.primaryColor,
                                    offset: Offset(0.5, 0.5),
                                    spreadRadius: 0.5,
                                    blurRadius: 2)
                              ]
                        // border: isTagMarked ? Border.all() : null
                        ),
                    margin: EdgeInsets.all(webh * 0.01),
                    padding: EdgeInsets.only(
                        left: webw * 0.02,
                        right: webw * 0.02,
                        top: webh * 0.005,
                        bottom: webh * 0.005),
                    child: FittedBox(
                      child: Text(
                        maintags[i],
                        style: TextStyle(
                            color: isTagMarked
                                ? myColors.normaltext
                                : myColors.normaltext),
                      ),
                    )),
              ),
            ),
          )
        : Transform.scale(
            scale: isTagMarked ? 1.05 : 1,
            child: Container(
                decoration: BoxDecoration(
                    color: isTagMarked
                        ? myColors.tabbuttonActive
                        : myColors.tabbutton,
                    borderRadius: BorderRadius.circular(h * 0.05),
                    boxShadow: !isTagMarked
                        ? []
                        : [
                            BoxShadow(
                                offset: Offset(0.5, 0.5),
                                spreadRadius: 0.5,
                                blurRadius: 2)
                          ]
                    // border: isTagMarked ? Border.all() : null
                    ),
                margin: EdgeInsets.all(h * 0.006),
                padding: EdgeInsets.only(
                    left: w * 0.02,
                    right: w * 0.02,
                    top: h * 0.005,
                    bottom: h * 0.005),
                child: InkWell(
                  onTap: () {
                    androidState(() {
                      if (!maintags.contains(maintags[i])) {
                        maintags.add(maintags[i]);
                      } else {
                        maintags.remove(maintags[i]);
                      }
                    });
                  },
                  child: FittedBox(
                    child: Text(maintags[i]),
                  ),
                )),
          );
  }

  Widget subtag(int i) {
    return Container(
        decoration: BoxDecoration(
          color: myColors.brandColor,
          borderRadius: BorderRadius.circular(h * 0.05),
          // border: Border.all()
        ),
        margin: EdgeInsets.all(h * 0.006),
        padding: EdgeInsets.only(
          left: w * 0.02,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FittedBox(
              child: Text(subtags[i]),
            ),
            Transform.scale(
              scale: 1.15,
              child: InkWell(
                onTap: () {
                  kIsWeb
                      ? webState(() {
                          subtags.removeAt(i);
                        })
                      : androidState(() {
                          subtags.removeAt(i);
                        });
                },
                child: Padding(
                  padding: EdgeInsets.only(left: w * 0.02),
                  child: FittedBox(
                      child: CircleAvatar(
                    backgroundColor: myColors.brandColor!.withGreen(180),
                    child: closeIcon(),
                  )),
                ),
              ),
            )
          ],
        ));
  }

  Future getMainTags() async {
    await FirebaseFirestore.instance
        .collection('maintag')
        .get(GetOptions(source: Source.serverAndCache))
        .then(
      (value) {
        _technologiesList.clear();
        QuerySnapshot<Map<String, dynamic>> f = value;

        int _count = 0;
        value.docs.forEach((e) {
          _technologiesList[_count] = (e['maintag']);
          _count++;
        });
        _filteredTechnologiesList = Map.from(_technologiesList);
      },
    );
  }

  tabs() {
    return Container(
      height: subtags.isEmpty ? h * 0.58 : h * 0.54,
      width: w,
      child: TabBarView(controller: tabController, children: [
        noteTab(),
        bulletTab(),
        codeTab(),
      ]),
    );
  }

  Widget noteTab() {
    return Container(
        height: subtags.isEmpty ? h * 0.42 : h * 0.38,
        width: w,
        margin: EdgeInsets.all(webSideW * 0.02),
        // color: Colors.green.shade100,
        child: Column(
          children: [
            Scrollbar(
              // controller: notescrollController,
              // isAlwaysShown: true,
              child: TextField(
                style: TextStyle(color: myColors.labeltext),
                controller: noteController,
                keyboardType: TextInputType.multiline,
                maxLines: subtags.isEmpty
                    ? (h * 0.44 ~/ (h * 0.025)).toInt()
                    : (h * 0.38 ~/ (h * 0.025)).toInt(),
                minLines: 1,
                expands: false,
                cursorColor: myColors.labeltext,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: myColors.labeltext),
                    labelText: 'Note',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: myColors.textfieldFocusborder ??
                                themeData.primaryColor),
                        borderRadius: BorderRadius.circular(h * 0.02)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: myColors.textfieldborder ??
                                themeData.primaryColor),
                        borderRadius: BorderRadius.circular(h * 0.02)),
                    suffixIcon: Column(
                      children: [
                        IconButton(
                          iconSize: kIsWeb ? webh * 0.03 : w * 0.06,
                          onPressed: () {
                            kIsWeb
                                ? webState(() {
                                    noteController.clear();
                                  })
                                : androidState(() {
                                    noteController.clear();
                                  });
                          },
                          icon: FittedBox(
                            child: closeIcon(),
                          ),
                        ),

                        //  addwithpaste
                        IconButton(
                            iconSize: kIsWeb ? webh * 0.03 : w * 0.06,
                            onPressed: () async {
                              ClipboardData? cdata =
                                  await Clipboard.getData(Clipboard.kTextPlain);
                              noteController.clear();

                              noteController.text = cdata!.text!;
                              kIsWeb
                                  ? webState(() {})
                                  : androidState(() {
                                      // titleController.clear();
                                    });
                            },
                            icon: Icon(
                              Icons.paste,
                              color: myColors.pasteicon,
                            )),

                        IconButton(
                          iconSize: kIsWeb ? webh * 0.03 : w * 0.06,
                          onPressed: () async {
                            ClipboardData? cdata =
                                await Clipboard.getData(Clipboard.kTextPlain);
                            noteController.text += cdata!.text!;
                            kIsWeb
                                ? webState(() {})
                                : androidState(() {
                                    // titleController.clear();
                                  });
                          },
                          icon: Image.asset(
                            'assets/addwithpaste2.png',
                            width: w * 0.06,
                            color: myColors.addpasteicon,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ));
  }

  Widget bulletTab() {
    return Container(
        height:
            // h*0.54,

            kIsWeb
                ? subtags.isEmpty
                    ? h * 0.50
                    : h * 0.54
                : subtags.isEmpty
                    ? h * 0.50
                    : h * 0.38,
        width: w,
        margin: EdgeInsets.all(webSideW * 0.02),
        // color: Colors.green.shade100,
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: myColors.labeltext),
              controller: bulletController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              minLines: 1,
              expands: false,
              cursorColor: myColors.labeltext,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: myColors.labeltext),
                  labelText: 'Bullet',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: myColors.textfieldFocusborder ??
                              themeData.primaryColor),
                      borderRadius: BorderRadius.circular(h * 0.02)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: myColors.textfieldborder ??
                              themeData.primaryColor),
                      borderRadius: BorderRadius.circular(h * 0.02)),
                  suffixIcon: Column(
                    children: [
                      IconButton(
                        iconSize: kIsWeb ? webh * 0.03 : w * 0.06,
                        onPressed: () {
                          bulletController.clear();
                          kIsWeb ? webState(() {}) : androidState(() {});
                        },
                        icon: FittedBox(
                          child: closeIcon(),
                        ),
                      ),

                      //  addwithpaste
                      IconButton(
                          iconSize: kIsWeb ? webh * 0.03 : w * 0.06,
                          onPressed: () async {
                            ClipboardData? cdata =
                                await Clipboard.getData(Clipboard.kTextPlain);
                            bulletController.clear();

                            bulletController.text = cdata!.text!;
                            kIsWeb ? webState(() {}) : androidState(() {});
                          },
                          icon: Icon(
                            Icons.paste,
                            color: myColors.addpasteicon,
                          )),
                      IconButton(
                          iconSize: kIsWeb ? webh * 0.03 : w * 0.06,
                          onPressed: () {
                            bool spacecount = bulletController.text.characters
                                .containsAll(Characters(' '));
                            List l = subtagController.text.split(' ');
                            print('space $spacecount');
                            if (l.length + 1 < bulletController.text.length) {
                              if (bulletController.text.isNotEmpty)
                                bullets.add(bulletController.text);
                              bulletController.clear();
                            }

                            updateState();
                          },
                          icon: Icon(
                            Icons.add_card,
                            color: myColors.iconcolors,
                          )),
                    ],
                  )),
            ),
            Container(
              height: kIsWeb
                  ? (subtags.isEmpty ? h * 0.35 : h * 0.24)
                  : subtags.isEmpty
                      ? h * 0.36
                      : h * 0.28,
              width: w,
              // color: Colors.lightBlue,
              child: ListView.builder(
                  itemCount: bullets.length,
                  itemBuilder: (c, i) {
                    return bulletCard(i);
                  }),
            )
          ],
        ));
  }

  Widget closeIcon() {
    return Icon(
      Icons.close,
      color: myColors.closeicon,
    );
  }

  Widget codeTab() {
    return kIsWeb
        ? Container(
            height: subtags.isEmpty ? h * 0.4 : h * 0.38,

            width: webSideW,
            // color: Colors.primaries.first,
            child: Column(
              children: [
                Container(
                  // color: Colors.green,
                  padding: EdgeInsets.only(left: webSideW * 0.0081),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: webSideW * 0.12,
                          margin: EdgeInsets.only(right: webSideW * 0.008),
                          child: FittedBox(
                            child: codeTabBtn(-1),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(webSideW * 0.005),
                          width: 2,
                          height: webh * 0.02,
                          color: codetabbtnnames.isNotEmpty
                              ? myColors.iconcolors
                              : Colors.transparent,
                        ),
                        Container(
                          width: webSideW * (1 - 0.24) - 3,
                          // double.infinity,
                          // webSideW*0.6,
                          height: webh * 0.04,
                          // color: Colors.orange,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: codetabbtnnames.length,
                              itemBuilder: (c, i) {
                                return codeTabBtn(i);
                              }),
                        )
                      ]),
                ),
                codeBox(codetabindex)
              ],
            ),
          )
        : Container(
            height: subtags.isEmpty ? h * 0.4 : h * 0.38,

            width: w,
            // color: Colors.primaries.first,
            child: Column(
              children: [
                Container(
                  // color: Colors.green,
                  padding: EdgeInsets.only(left: w * 0.0081),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: w * 0.22,
                          margin: EdgeInsets.only(right: w * 0.008),
                          child: FittedBox(
                            child: codeTabBtn(-1),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(w * 0.005),
                          width: 2,
                          height: h * 0.02,
                          color: codetabbtnnames.isNotEmpty
                              ? myColors.iconcolors
                              : Colors.transparent,
                        ),
                        Container(
                          width: w * (1 - 0.34) - 3,
                          // double.infinity,
                          // w*0.6,
                          height: h * 0.04,
                          // color: Colors.orange,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: codetabbtnnames.length,
                              itemBuilder: (c, i) {
                                return codeTabBtn(i);
                              }),
                        )
                      ]),
                ),
                codeBox(codetabindex)
              ],
            ),
          );
  }

  Widget tabRow() {
    double _textSize = kIsWeb ? webSideW * 0.035 : w * 0.035;
    print('tabController ${tabController.index}');
    // tabController.addListener(() {
    //   webState(() {});
    // });
    return Container(
        height: h * 0.05,
        width: w,
        child: DefaultTabController(
          length: 3,
          child: TabBar(
            indicatorColor: myColors.tabiconactive,
            controller: tabController,
            tabs: [
              Tab(
                  icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.notes,
                    color: tabController.index == 0
                        ? myColors.tabiconactive
                        : myColors.tabiconInctive,
                  ),
                  Text(
                    'Note',
                    style: TextStyle(
                      fontSize: _textSize,
                      color: tabController.index == 0
                          ? myColors.tabiconactive
                          : myColors.tabiconInctive,
                    ),
                  )
                ],
              )),
              Tab(
                  icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.all(h * 0.008),
                    child: Image.asset(
                      'assets/bullet.png',
                      fit: BoxFit.cover,
                      color: tabController.index == 1
                          ? myColors.tabiconactive
                          : myColors.tabiconInctive,
                    ),
                  ),
                  Text(
                    'Bullets',
                    style: TextStyle(
                      fontSize: _textSize,
                      color: tabController.index == 1
                          ? myColors.tabiconactive
                          : myColors.tabiconInctive,
                    ),
                  )
                ],
              )),
              Tab(
                  icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.all(h * 0.008),
                    child: Image.asset(
                      'assets/curly.png',
                      fit: BoxFit.contain,
                      color: tabController.index == 2
                          ? myColors.tabiconactive
                          : myColors.tabiconInctive,
                    ),
                  ),
                  Text(
                    'Code',
                    style: TextStyle(
                      fontSize: _textSize,
                      color: tabController.index == 2
                          ? myColors.tabiconactive
                          : myColors.tabiconInctive,
                    ),
                  )
                ],
              )),
            ],
          ),
        ));
  }

  webCode() {
    print(
        'v list  on web code ${math.Random().nextInt(1000)}  web code${noteslist.length}');

    return FutureBuilder(
      future: getallServerNotes(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          fullNoteslist = snapshot.data as List<Note>;
          noteslist = List.from(fullNoteslist);
          print('snap list ${noteslist.length}');
          return LayoutBuilder(builder: (context, constraits) {
            webh = constraits.maxHeight;
            webw = constraits.maxWidth;
            webMainW = webw * webMainWFactor;
            webSideW = webw * webSideWFactor;
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter wtState) {
              webState = wtState;
              webData = Provider.of<Data>(context);
              print(
                  'isadmin $isAdmin  webState  called  ${math.Random().nextInt(5000)}');

              return Container(
                width: webw,
                height: webh,
                child: Row(
                  children: [
                    mainScreenWeb(),
                    (webw / webh) > 1.5 ? addNoteCodeWeb() : Container()
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

  mainScreenWeb() {
    return Container(
      width: (webw / webh) > 1.5 ? webw * 0.55 : webw,
      height: webh,
      color: myColors.addfullnoteboxbg!,
      child: Column(
        children: [searchBarWeb(), searchfiltersWeb(), notesListWidget()],
      ),
    );
  }

  addNoteCodeWeb() {
    return Container(
      width: webw * 0.45,
      height: webh,
      color:
          // Colors.red,
          myColors.addfullnoteboxbg,
      child: addNoteSheetWeb(context),
    );
  }

  addNoteSheetWeb(BuildContext context) {
    return Container(
        height: webh * 0.8,
        width: webw,
        margin: EdgeInsets.all(webw * 0.01),

        // margin: EdgeInsets.only(top: h * 0.1, left: w*0.08),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(webh * 0.02),
            // topLeft: Radius.circular(w * 0.08),
            // topRight: Radius.circular(w * 0.08),
          ),
          color:
              // Colors.red,
              myColors.addfullnoteboxbg,
        ),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Container(
              // color: Colors.red,
              height: kIsWeb ? webh * 0.90 : h * 0.74,
            ),
            Container(
              height: kIsWeb ? webh * 0.84 : h * 0.74,
              // color: Colors.red.shade100,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(w * 0.08 * 0)),
                child: SingleChildScrollView(child: columnElemets()),
              ),
            ),
            // bottomButtons(),
            Align(
              alignment: Alignment.bottomCenter,
              child: MediaQuery.of(context).viewInsets.bottom < 1
                  ? bottomButtons()
                  : Container(),
            )
          ],
        ));
  }

  Widget bulletCard(int i) {
    return Container(
      margin: EdgeInsets.only(top: webh * 0.005, bottom: webh * 0.005),
      // padding: EdgeInsets.all(webh * 0.001),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 226, 238, 152),
          borderRadius: BorderRadius.circular(webh * 0.02)),
      child: Padding(
          padding: EdgeInsets.all(webh * 0.001 * 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: webSideW * 0.03),
                  child: Text(
                    bullets[i],
                    style:
                        TextStyle(fontSize: webh * 0.02, color: Colors.black),
                  ),
                ),
              ),
              IconButton(
                  iconSize: h * 0.022,
                  onPressed: () {
                    showBulletEditdialog(i);

                    // kIsWeb
                    //     ? webState(() {
                    //         bullets.removeAt(i);
                    //       })
                    //     : androidState(() {
                    //         bullets.removeAt(i);
                    //       });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: chipDarkBlueColor,
                    size: h * 0.022,
                  )),
              IconButton(
                  iconSize: h * 0.022,
                  onPressed: () {
                    bullets.removeAt(i);
                    updateState();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: h * 0.022,
                  ))
            ],
          )),
    );
  }

  columnElemets() {
    return Column(
      children: [
        Container(
          height: kIsWeb ? h * 0.01 : h * 0.03,
          color: Colors.transparent,
        ),
        Container(
          width: w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              selectTechButton(),
              maintags.isNotEmpty
                  ? Expanded(child: _mainTagsChipsRow())
                  : Container(),
            ],
          ),
        ),
        titleWidget(),
        subtagWidget(),
        subtagsRow(),
        tabRow(),
        SizedBox(
          height: h * 0.005,
        ),
        tabs(),
      ],
    );
  }

  codeTabBtn(int i) {
    return kIsWeb
        ? Transform.scale(
            scale: i == codetabindex ? 1.05 : 1,
            child: Container(
              // margin: EdgeInsets.only(bottom: webh * 0.01),
              child: Container(
                  // height: webh * 0.041,
                  // width: webSideW*0.08,
                  decoration: BoxDecoration(
                      color: i == codetabindex
                          ? Colors.orange.shade200
                          : Colors.orange.shade200,
                      borderRadius: BorderRadius.circular(webh * 0.05),
                      boxShadow: i != codetabindex
                          ? []
                          : [
                              BoxShadow(
                                  offset: Offset(0.5, 0.5),
                                  spreadRadius: 0.5,
                                  blurRadius: 2)
                            ]
                      // border: isTagMarked ? Border.all() : null
                      ),
                  margin: EdgeInsets.all(webh * 0.005),
                  padding: EdgeInsets.only(
                      left: webSideW * 0.02,
                      right: webSideW * 0.02,
                      top: webh * 0.005,
                      bottom: webh * 0.005),
                  child: InkWell(
                    onTap: () {
                      // print(' codetabindex $codetabindex  a           nd $i');
                      kIsWeb
                          ? webState(() {
                              codetabindex = i;
                              // print(' codetabindex $codetabindex and $i');
                            })
                          : androidState(() {
                              codetabindex = i;
                            });
                    },
                    child: FittedBox(
                      child: i < 0
                          ? Text(
                              'New Code',
                              style: TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.w600),
                            )
                          : Text(
                              codetabbtnnames[i],
                              style: TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  )),
            ),
          )
        : Transform.scale(
            scale: i == codetabindex ? 1.05 : 1,
            child: Container(
              // margin: EdgeInsets.only(bottom: webh * 0.01),
              child: Container(
                  // height: webh * 0.041,
                  // width: w*0.08,
                  decoration: BoxDecoration(
                      color: i == codetabindex
                          ? Colors.orange.shade200
                          : Colors.orange.shade200,
                      borderRadius: BorderRadius.circular(h * 0.05),
                      boxShadow: i != codetabindex
                          ? []
                          : [
                              BoxShadow(
                                  offset: Offset(0.5, 0.5),
                                  spreadRadius: 0.5,
                                  blurRadius: 2)
                            ]
                      // border: isTagMarked ? Border.all() : null
                      ),
                  margin: EdgeInsets.all(h * 0.005),
                  padding: EdgeInsets.only(
                      left: w * 0.02,
                      right: w * 0.02,
                      top: h * 0.005,
                      bottom: h * 0.005),
                  child: InkWell(
                    onTap: () {
                      // print(' codetabindex $codetabindex  a           nd $i');
                      kIsWeb
                          ? webState(() {
                              codetabindex = i;
                              // print(' codetabindex $codetabindex and $i');
                            })
                          : androidState(() {
                              codetabindex = i;
                            });
                    },
                    child: FittedBox(
                      child: i < 0
                          ? Text(
                              'New Code',
                              style: TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.w600),
                            )
                          : Text(
                              codetabbtnnames[i],
                              style: TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  )),
            ),
          );
  }

  codeBox(int cdindex) {
    return Container(
      height: kIsWeb
          ? subtags.isEmpty
              ? webh * 0.54
              : webh * 0.49
          : h * 0.55,
      width: kIsWeb ? webSideW : w,
      // color: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cdindex == -1
            ? [codetitle(), codeBlock()]
            : [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    margin: EdgeInsets.all(webSideW * 0.01),
                    child: Text(
                      codetabbtnnames[cdindex],
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Spacer(),
                  true
                      ? IconButton(
                          iconSize: h * 0.03,
                          onPressed: () {
                            // int j = codetabindex - 1;
                            // codes.removeAt(codetabindex);
                            // codetabbtnnames.removeAt(codetabindex);

                            kIsWeb
                                ? webState(() {
                                    //  codeT
                                    isCodeEditing = true;
                                    codeTitleController.text =
                                        codetabbtnnames[cdindex];
                                    codeController.text = codes[cdindex];
                                    editCodeIndex = cdindex;
                                    codetabindex = -1;
                                  })
                                : androidState(() {
                                    isCodeEditing = true;
                                    codeTitleController.text =
                                        codetabbtnnames[cdindex];
                                    codeController.text = codes[cdindex];
                                    editCodeIndex = cdindex;
                                    codetabindex = -1;
                                  });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.deepPurple,
                          ))
                      : Container(),
                  true
                      ? IconButton(
                          iconSize: h * 0.03,
                          onPressed: () async {
                            // showDialog()
                            int j = cdindex - 1;
                            codes.removeAt(cdindex);
                            codetabbtnnames.removeAt(cdindex);
                            cdindex = j;
                            codetabindex = j;
                            webState(() {});
                            androidState(() {});
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                      : Container()
                ]),
                Divider(
                  color: myColors.normaltext,
                ),
                Expanded(
                  // height: h*0.3,
                  child: SingleChildScrollView(
                      child: Container(
                          margin: kIsWeb
                              ? EdgeInsets.all(webSideW * 0.01)
                              : EdgeInsets.all(w * 0.01),
                          child: Text(
                            codes[cdindex],
                            textAlign: TextAlign.start,
                          ))),
                )
              ],
      ),
    );
  }

  codetitle() {
    return Container(
        // height: kIsWeb? webh * 0.06: h * 0.05,
        // color: Colors.amber,
        width: kIsWeb ? webSideW : w,
        margin:
            kIsWeb ? EdgeInsets.all(webSideW * 0.01) : EdgeInsets.all(w * 0.01),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // width: kIsWeb
              //     ? webSideW - webh * 0.05 - webSideW * 0.12
              //     : w - webh * 0.05 - webSideW * 0.12,
              child: TextField(
                style: TextStyle(color: myColors.labeltext),
                controller: codeTitleController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                minLines: 1,
                expands: false,
                cursorColor: Colors.pink,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.pink),
                    labelText: 'Code Title',
                    isCollapsed: false,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: C.titleColor.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(h * 0.02)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: C.titleColor.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(h * 0.02)),
                    suffixIcon: InkWell(
                      onTap: () {
                        kIsWeb
                            ? webState(() {
                                codeTitleController.clear();
                              })
                            : androidState(() {
                                codeTitleController.clear();
                              });
                      },
                      child: FittedBox(
                        child: Padding(
                          padding: kIsWeb
                              ? EdgeInsets.all(webh * 0.015)
                              : EdgeInsets.all(h * 0.015),
                          child: Container(child: closeIcon()),
                        ),
                      ),
                    )),
              ),
            ),
            isCodeEditing
                ? IconButton(
                    onPressed: () {
                      List l = codeController.text.split(' ');

                      List ct = codeTitleController.text.split(' ');
                      print(
                          'lengthh $l and $ct ** ${ct.length}  // ${codeTitleController.text.length} ');
                      if (l.length - 1 < codeController.text.length &&
                          ct.length - 1 < codeTitleController.text.length) {
                        print('lengthh true $l and $ct ');
                        if (codeController.text.isNotEmpty &&
                            codeTitleController.text.isNotEmpty)
                          codes[editCodeIndex] = codeController.text;

                        // codes.isNotEmpty
                        //     ? '__' + codeController.text
                        //     : "" + codeController.text;
                        // codetabbtnnames.add(codeTitleController.text);
                        codetabbtnnames[editCodeIndex] =
                            codeTitleController.text;
                        codeController.clear();
                        codeTitleController.clear();
                        isCodeEditing = false;
                        webState(() {});

                        androidState(() {});
                      }
                    },
                    icon: Icon(Icons.check))
                : Container(),
            IconButton(
                onPressed: () {
                  List l = codeController.text.split(' ');

                  List ct = codeTitleController.text.split(' ');
                  print(
                      'lengthh $l and $ct ** ${ct.length}  // ${codeTitleController.text.length} ');
                  if (l.length - 1 < codeController.text.length &&
                      ct.length - 1 < codeTitleController.text.length) {
                    print('lengthh true $l and $ct ');
                    if (codeController.text.isNotEmpty &&
                        codeTitleController.text.isNotEmpty)
                      codes.add(codeController.text

                          // codes.isNotEmpty
                          //   ? '__' + codeController.text
                          //   : "" + codeController.text
                          );
                    codetabbtnnames.add(codeTitleController.text);
                    codeController.clear();
                    codeTitleController.clear();
                    kIsWeb ? webState(() {}) : androidState(() {});
                  }
                },
                icon: addIcon(myColors))
          ],
        ));
  }

  codeBlock() {
    return kIsWeb
        ? Container(
            height: webh * 0.45,
            width: webSideW,
            margin: EdgeInsets.all(webSideW * 0.01),
            child: TextField(
              style: TextStyle(color: myColors.labeltext),
              controller: codeController,
              keyboardType: TextInputType.multiline,
              maxLines: 26,
              minLines: 1,
              expands: false,
              cursorColor: Colors.pink,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.pink),
                  labelText: 'Code',
                  isCollapsed: false,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: C.titleColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(h * 0.02)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: C.titleColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(h * 0.02)),
                  suffixIcon: IconButton(
                    iconSize: webh * 0.03,
                    onPressed: () {
                      webState(() {
                        codeController.clear();
                      });
                    },
                    icon: FittedBox(
                      child: closeIcon(),
                    ),
                  )),
            ),
          )
        : Container(
            height: h * 0.45,
            width: w,
            margin: EdgeInsets.all(w * 0.01),
            child: TextField(
              style: TextStyle(color: myColors.labeltext),
              controller: codeController,
              keyboardType: TextInputType.multiline,
              maxLines: 26,
              minLines: 1,
              expands: false,
              cursorColor: Colors.pink,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.pink),
                  labelText: 'Code',
                  isCollapsed: false,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: C.titleColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(h * 0.02)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: C.titleColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(h * 0.02)),
                  suffixIcon: IconButton(
                    iconSize: h * 0.03,
                    onPressed: () {
                      androidState(() {
                        codeController.clear();
                      });
                    },
                    icon: FittedBox(
                      child: closeIcon(),
                    ),
                  )),
            ),
          );
  }

  searchBarWeb() {
    String join = selectedFilters.join(' ');
    double tileW = (webw / webh) > 1.5 ? webMainW : webw;
    return Container(
      width: tileW,
      // webMainW,
      height: webh * 0.04,
      margin: EdgeInsets.all(webh * 0.01),
      // color: Colors.pink.shade100,
      child: Row(
        children: [
          IconButton(
              iconSize: math.min(tileW * 0.06, webh * 0.04),
              padding: EdgeInsets.zero,
              onPressed: () async {
                _data.scaffoldKey.currentState!.openDrawer();
                // customTheme.toggleTheme();
              },
              icon: Icon(
                Icons.menu,
                color: myColors.normaltext,
              )),
          Container(
            width: tileW * 0.83,
            child: TextField(
              style: TextStyle(
                  fontSize: webh * 0.022,
                  //  height: 1.0,
                  color: myColors.labeltext),
              controller: searchController,
              cursorColor: myColors.normaltext!,
              onSubmitted: (d) {
                getSearchResult();
              },
              decoration: InputDecoration(
                labelText: "Search any topic",
                // ${noteslist.length}
                labelStyle: TextStyle(color: myColors.normaltext!),
                // join,
                // '${webw.round()} / ${webMainW.round()}  / ${webSideW.round()}',
                contentPadding: EdgeInsets.only(left: webMainW * 0.015),

                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: myColors.normaltext!),
                    borderRadius: BorderRadius.circular(h * 0.02)),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: myColors.normaltext!),
                    borderRadius: BorderRadius.circular(h * 0.02)),
                // prefixIcon: InkWell(
                //     onTap: () {},
                //     child: Icon(
                //       Icons.search,
                //       size: webh * 0.02,
                //       color: Colors.grey,
                //     )),

                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: webh * 0.02,
                  onPressed: () {
                    webState(() {
                      searchController.clear();
                      getSearchResult();
                    });
                  },
                  icon: FittedBox(
                    child: closeIcon(),
                  ),
                ),
                // InkWell(
                //     onTap: () {
                //       webState(() {
                //         searchController.clear();
                //       });
                //     },
                //     child: Icon(
                //       Icons.close,
                //       size: webh * 0.02,
                //     )),
              ),
            ),
          ),
          IconButton(
              iconSize: math.min(tileW * 0.06, webh * 0.04),
              padding: EdgeInsets.zero,
              onPressed: () {
                // webState(() {
                //   getAdminStatus();
                // });
                getSearchResult();
              },
              icon: Icon(
                Icons.search,
                color: myColors.iconcolors,
              )),
        ],
      ),
    );
  }

  searchfiltersWeb() {
    return Container(
        width: (webw / webh) > 1.5 ? webMainW : webw,
        height: webh * 0.09,
        // color: Colors.pink,
        child: Scrollbar(
          controller: filterScrollController,
          child: ListView.builder(
              controller: filterScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (c, i) {
                return filterTab(i);
              }),
        ));
  }

  searchBarAndroid() {
    String join = selectedFilters.join(' ');
    double tileW = w * 0.72;
    return Container(
      width: tileW,
      // webMainW,
      height: h * 0.04,
      margin: EdgeInsets.all(h * 0.01),
      // color: Colors.pink.shade100,
      child: Container(
        width: tileW - h * 0.06,
        child: TextField(
          focusNode: _androidFocusNode,
          style: TextStyle(
              fontSize: h * 0.022,
              //  height: 1.0,
              color: myColors.labeltext),
          controller: searchController,
          cursorColor: myColors.normaltext,
          onChanged: (d) {
            getSearchResult();
          },
          decoration: InputDecoration(
            labelText: "Search any topic",
            // ${noteslist.length}
            labelStyle: TextStyle(color: myColors.normaltext),
            // join,
            // '${webw.round()} / ${webMainW.round()}  / ${webSideW.round()}',
            contentPadding: EdgeInsets.only(left: w * 0.05),

            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 1, color: C.titleColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(h * 0.02)),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 1, color: C.titleColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(h * 0.02)),

            suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              iconSize: h * 0.02,
              onPressed: () {
                androidState(() {
                  searchController.clear();
                  getSearchResult();
                });
              },
              icon: FittedBox(
                child: closeIcon(),
              ),
            ),
            // InkWell(
            //     onTap: () {
            //       webState(() {
            //         searchController.clear();
            //       });
            //     },
            //     child: Icon(
            //       Icons.close,
            //       size: h * 0.02,
            //     )),
          ),
        ),
      ),
    );
  }

  searchfiltersAndroid() {
    Color _darkColor = Color.fromARGB(255, 11, 5, 57);
    Color _lightColor = Color.fromARGB(255, 204, 220, 240);
    print('isdark ${isDarkTheme()}');
    return Container(
      height: h * 0.05,
      width: w,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.all(w * 0.01),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        isDarkTheme()
                            ? (showOnlyMyNotes ? _lightColor : _darkColor)
                            : (showOnlyMyNotes ? _darkColor : _lightColor)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        isDarkTheme()
                            ? (showOnlyMyNotes ? _darkColor : _lightColor)
                            : (showOnlyMyNotes ? _lightColor : _darkColor)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: Color.fromARGB(255, 15, 5, 96))))),
                onPressed: () {
                  androidState(
                    () {
                      if (!Shared.isLogin() ||
                          FirebaseAuth.instance.currentUser == null) {
                        showSnackbar(
                            'Please sign in with google to create personal notes ${!Shared.isLogin()}');
                      } else {
                        showOnlyMyNotes = !showOnlyMyNotes;
                        getSearchResult();
                      }
                    },
                  );
                },
                child: Text('My Notes')),
          ),
          showOnlyMyNotes
              ? Icon(
                  Icons.check,
                  color: myColors.addpasteicon,
                )
              : Container(),
          SizedBox(
            width: w * 0.02,
          ),
          Expanded(
            child: ListView.builder(

                // controller: filterScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (c, i) {
                  return
                      // Text('button $i              ');
                      filterTab(i);
                }),
          )
        ],
      ),
    );
  }

  filterTab(int i) {
    bool _isTagMarked = selectedFilters.contains(filters[i]);
    return Transform.scale(
      scale: _isTagMarked ? 1.05 : 1,
      child: InkWell(
        onTap: () {
          if (filters[i] == 'All') {
            selectedFilters.clear();
            selectedFilters.add(filters[i]);

            getSearchResult();
            // if ( !kIsWeb) {
            //   modifyNotesListToShowOnlyUserNotes();
            // }
          } else {
            selectedFilters.remove('All');
            if (!selectedFilters.contains(filters[i])) {
              selectedFilters.add(filters[i]);
            } else {
              selectedFilters.remove(filters[i]);
            }
            if (selectedFilters.isEmpty) {
              noteslist = List.from(fullNoteslist);

              selectedFilters.add('All');
            }
            getSearchResult();
          }

          webState(() {});
          // androidState(() {});
        },
        child: Container(
          margin: kIsWeb
              ? EdgeInsets.only(
                  bottom: webh * 0.03,
                  left: webMainW * 0.012 * 1,
                  top: webh * 0.008,
                )
              : EdgeInsets.only(
                  // bottom: h * 0.03,
                  left: w * 0.012,
                  // top: h * 0.008,
                ),
          child: Container(
              // height: kIsWeb? webh * 0.06:h* 0.03,
              // height: double.minPositive,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: _isTagMarked
                      ? myColors.tabbuttonActive
                      : myColors.tabbutton,
                  borderRadius: kIsWeb
                      ? BorderRadius.circular(webh * 0.05)
                      : BorderRadius.circular(h * 0.03),
                  boxShadow: !_isTagMarked
                      ? []
                      : [
                          BoxShadow(
                              color: myColors.normaltext!,
                              offset: Offset(0.3, 0.3),
                              spreadRadius: 0.4,
                              blurRadius: 1)
                        ]
                  // border: isTagMarked ? Border.all() : null
                  ),
              margin: kIsWeb
                  ? EdgeInsets.all(webh * 0.002)
                  : EdgeInsets.all(h * 0.008),
              padding: kIsWeb
                  ? EdgeInsets.only(
                      left: webw * 0.02,
                      right: webw * 0.02,
                      top: webh * 0.005,
                      bottom: webh * 0.005)
                  : EdgeInsets.only(
                      left: w * 0.03,
                      right: w * 0.03,
                      top: h * 0.001,
                      bottom: h * 0.001),
              child: Text(
                filters[i],
                style: TextStyle(
                    fontSize: _isTagMarked ? h * 0.02 : h * 0.015,
                    color: _isTagMarked
                        ? myColors.normaltext
                        : myColors.normaltext),
              )),
        ),
      ),
    );
  }

  // filterTabAndroid(int i) {
  //   print('filterTabAndroid');
  //   bool isTagMarked = selectedFilters.contains(filters[i]);
  //   return Transform.scale(
  //     scale: isTagMarked ? 1.05 : 1,
  //     child: InkWell(
  //       onTap: () {
  //         webState(() {
  //           if (!selectedFilters.contains(filters[i])) {
  //             selectedFilters.add(filters[i]);
  //           } else {
  //             selectedFilters.remove(filters[i]);
  //           }
  //         });
  //       },
  //       child: Container(
  //         margin: EdgeInsets.only(
  //           bottom: h * 0.03,
  //           left: webMainW * 0.012,
  //           top: h * 0.008,
  //         ),
  //         child: Container(
  //             height: h * 0.06,
  //             decoration: BoxDecoration(
  //                 color: isTagMarked
  //                     ? myColors.tabbuttonActive
  //                     : myColors.tabbutton,
  //                 borderRadius: BorderRadius.circular(h * 0.05),
  //                 boxShadow: !isTagMarked
  //                     ? []
  //                     : [
  //                         BoxShadow(
  //                             color: myColors.normaltext!,
  //                             offset: Offset(0.5, 0.5),
  //                             spreadRadius: 0.5,
  //                             blurRadius: 2)
  //                       ]),
  //             margin: EdgeInsets.all(h * 0.002),
  //             padding: EdgeInsets.only(
  //                 left: w * 0.02,
  //                 right: w * 0.02,
  //                 top: h * 0.005,
  //                 bottom: h * 0.005),
  //             child: FittedBox(
  //               child: Text(
  //                 filters[i],
  //                 style: TextStyle(
  //                     color: isTagMarked
  //                         ? myColors.normaltext
  //                         : myColors.normaltext),
  //               ),
  //             )),
  //       ),
  //     ),
  //   );
  // }

  notesListWidget() {
    // print('notess ${noteslist.length}');
    return Expanded(
        child: ListView.builder(
            itemCount: noteslist.length,
            itemBuilder: (c, i) {
              return noteBox(i);
            }));
  }

  noteBox(int i) {
    ScrollController controller = ScrollController();
    double tileW = (webw / webh) > 1.5 ? webMainW : webw;

    double indent = tileW * 0.1;
    double endIndent = tileW * 0.02;
    if (!kIsWeb) {
      indent = tileW * 0.15;
      double endIndent = tileW * 0.04;
    }
    String subtitlemaintags = noteslist[i].tags.replaceAll('__', ', ');
    String subtitlesubtags = noteslist[i].subtags.replaceAll('__', ', ');
    List<String> bulltesInTile = noteslist[i].bullets.split('__');
    List<String> fullcodes = noteslist[i].code.split('__');
    List<List<String>> codepairs = [];
    fullcodes.forEach((e) {
      List pair = e.split('_*_');
      print(' pair $pair');
      if (pair.length > 1) {
        codepairs.add([pair[0], pair[1]]);
      }
    });

    return ClipRRect(
      borderRadius: BorderRadius.circular(h * 0.02),
      child: Container(
        width: tileW,
        margin: EdgeInsets.all(tileW * 0.01),
        decoration: BoxDecoration(color: myColors.expansionboxbg,
            //  Color.fromARGB(255, 242, 238, 202),
            boxShadow: [BoxShadow(offset: Offset(0.5, 0.5))]),
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.platform,
          iconColor: myColors.addpasteicon,
          collapsedIconColor: myColors.addpasteicon,
          maintainState: true,
          textColor: myColors.normaltext,
          collapsedTextColor: myColors.normaltext,
          title: SingleChildScrollView(
            child: Text(
              noteslist[i].title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: webh * 0.028,
              ),
            ),
          ),
          subtitle: SingleChildScrollView(
            child: Text(
              subtitlemaintags,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: webh * 0.02,
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
                        // fontSize: webh * 0.045,
                        fontSize: webh * 0.015,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                      // width: double.maxFinite,
                      // isAdmin ? tileW * 0.84 : tileW * 0.98,
                      child: SingleChildScrollView(child: Text(
                          // 'et firestore insta {tags: Native__Other, id: 8dkR0mby1U5mxHDH926z, note: xcxc, code: xzxz_*_vxvcvc__cxx_*___cxcxcx, epoch: 1654948691682, subtags: cxd__dfdf, bullets: dfdfsfd__dfdcxcxxxc__xcx__cxcx__cxcxcxcxcx, title: cxcx, time: Timestamp(seconds=1654948691, nanoseconds=682000000)}'

                          subtitlesubtags))),
                  // Spacer(),
                  (isAdmin || showOnlyMyNotes)
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: tileW * 0.04,
                          onPressed: () {
                            _editingNote = noteslist[i];
                            isNoteEditing = true;
                            loadThisDataInEditingBox();
                            if (!kIsWeb) {
                              androidState(() {
                                showSheet = true;
                              });
                            }
                          },
                          icon: Icon(Icons.edit,
                              color: Colors.deepPurple, size: h * 0.034))
                      : Container(),
                  isAdmin || showOnlyMyNotes
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: tileW * 0.04,
                          onPressed: () async {
                            await askToDelete(i);

                            webState(() {});
                          },
                          icon: Icon(Icons.delete,
                              color: Colors.red, size: h * 0.034))
                      : Container()
                ],
              ),
            ),
            Divider(
              color: myColors.normaltext,
              indent: indent,
              endIndent: endIndent,
            ),
            Row(
              children: [
                _tilesubpartheading('Note', indent),
                Expanded(
                  child: Text(
                    noteslist[i].note,
                    style: TextStyle(
                        // fontWeight: FontWeight.w500,
                        // fontSize: webh * 0.015,
                        color: myColors.normaltext),
                  ),
                ),
              ],
            ),
            Divider(
              color: myColors.normaltext,
              indent: indent,
              endIndent: endIndent,
            ),
            Container(
              width: tileW,
              child: Row(
                children: [
                  _tilesubpartheading('Bullets', indent),
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
              color: myColors.normaltext,
              indent: indent,
              endIndent: endIndent,
            ),
            Row(
              children: [
                _tilesubpartheading('Code', indent),
                Container(
                    width: tileW * 0.98 - indent,
                    height: webh * 0.3,
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
                                  color: myColors.normaltext,
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
                  ' -  ' + noteslist[i].author.split('@').first,
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

  bool checkTextisValid(String s) {
    bool b = false;
    bool spacecount = s.characters.containsAll(Characters(' '));
    List l = s.split(' ');
    print('space $spacecount');
    if (l.length + 1 < s.length) {
      if (s.isNotEmpty) {
        b = true;
      }
    }
    return b;
  }

  Widget _tilesubpartheading(String s, double d) {
    return Container(
      width: d,
      child: Text(
        s,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: webh * 0.015,
          color: Colors.grey,
        ),
      ),
    );
  }

  void getAdminStatus() {
    // isAdmin = Shared.isAdmin;
    bool isAdmin = Shared.getAdminStat();
    print('isadmin status $isAdmin');
  }

  // Future loadDataFromServer() async {
  //   fullNoteslist = await getallCacheNotes();
  //   setState(() {});
  // }

  androidCode() {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (c, b) => [
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: themeData.appBarTheme.backgroundColor,
          actions: [
            InkWell(
              onTap: () async {
                // await getDatatoJsonAndShareJsonFile();
                _androidFocusNode.nextFocus();
                _data.scaffoldKey.currentState!.openDrawer();

                // addNewMainTags();
              },
              child: Padding(
                padding: EdgeInsets.all(h * 0.01),
                child: Icon(Icons.menu, color: myColors.iconcolors
                    //  myColors.iconcolors,
                    ),
              ),
            ),
            searchBarAndroid(),
            InkWell(
              onTap: () {
                getSearchResult();
                _androidFocusNode.nextFocus();
              },
              child: Padding(
                padding: EdgeInsets.all(h * 0.01),
                child: Icon(Icons.search, color: myColors.iconcolors
                    //  myColors.iconcolors,
                    ),
              ),
            ),
          ],
          floating: true,
          // pinned: true,
        ),
        SliverList(delegate: SliverChildListDelegate([])),
      ],
      body: FutureBuilder(
        future: getallCacheNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            fullNoteslist = snapshot.data as List<Note>;
            noteslist = List.from(fullNoteslist);
            print('snap list ${noteslist.length}');

            return StatefulBuilder(
                builder: (BuildContext context, StateSetter android_State) {
              androidData = Provider.of<Data>(context);
              androidState = android_State;
              if (showOnlyMyNotes) {
                modifyNotesListToShowOnlyUserNotes();
              }
              print('snap list in andoird state ${noteslist.length}');
              return Container(
                color: themeData.backgroundColor,
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (!showSheet) searchfiltersAndroid(),
                        if (!showSheet)
                          Expanded(
                            child: noteslist.isNotEmpty
                                ? ListView.builder(
                                    itemCount: noteslist.length,
                                    itemBuilder: (c, i) {
                                      return Container(
                                          color: themeData.backgroundColor,
                                          child: noteBox(i));
                                      // Text(noteslist[i].note);
                                    })
                                : Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(w * 0.05),
                                      child: Text(
                                        'You dont have any notes !!!\n Please click on add button to add note',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: isDarkTheme()
                                                ? Color.fromARGB(
                                                    255, 215, 227, 233)
                                                : Color.fromARGB(
                                                    255, 34, 10, 76),
                                            fontSize: h * 0.03,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                          ),
                      ],
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            child: showSheet
                                ? addBottomSheetAndroid(context)
                                : floatingButton()))
                  ],
                ),
              );
            });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void showSnackbar(String s) {
    SnackBar snackBar = SnackBar(
      content: Text(s),
      action: SnackBarAction(
        label: 'CLOSE',
        textColor: Colors.blue,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getSearchResult() {
    if (selectedFilters.contains('All') && selectedFilters.length == 1) {
      noteslist = List.from(fullNoteslist);
      if (searchController.text.isNotEmpty) {
        noteslist.clear();
        for (Note e in fullNoteslist) {
          if (checkIsThisTextContains(e.tags.toLowerCase()) ||
              checkIsThisTextContains(e.title.toLowerCase()) ||
              checkIsThisTextContains(e.subtags.toLowerCase()) ||
              checkIsThisTextContains(e.code.toLowerCase()) ||
              checkIsThisTextContains(e.bullets.toLowerCase()) ||
              checkIsThisTextContains(e.note.toLowerCase())) {
            noteslist.add(e);

            continue;
          }
        }
      }

      if (showOnlyMyNotes) {
        // for (int i = 0; i < fullNoteslist.length;i++) {
        //   if(notes)
        // }
        noteslist.removeWhere((e) {
          return e.author != getCurrentUserEmailId();
        });
      }
      androidState(() {});
      return;
    }
    noteslist.clear();

    for (Note e in fullNoteslist) {
      print('noteis ${e.tags.toString()}');

      if (showOnlyMyNotes) {
        if (e.author != getCurrentUserEmailId()) {
          continue;
        }
      }
      if (selectedFilters.contains('Technology')) {
        print('iff techno');
        if (checkIsThisTextContains(e.tags.toLowerCase())) {
          noteslist.add(e);

          continue;
        }
      }

      if (selectedFilters.contains('Title')) {
        print('iff title');
        if (checkIsThisTextContains(e.title.toLowerCase())) {
          noteslist.add(e);

          continue;
        }

        print('tagggs after ${noteslist.length}');

        // fullNoteslist.forEach((e) {

        ;
      }

      if (selectedFilters.contains('Notes')) {
        print('iff Notes');
        if (checkIsThisTextContains(e.note.toLowerCase())) {
          noteslist.add(e);

          continue;
        }
      }
      if (selectedFilters.contains('Code Title')) {
        String codetitle = e.code;
        // print('iff codet tile ${e.code}');
        if (checkIsThisTextContains(e.code.toLowerCase())) {
          noteslist.add(e);

          continue;
        }
      }

      if (selectedFilters.contains('Bullets')) {
        // print('iff bullets');
        if (checkIsThisTextContains(e.bullets.toLowerCase())) {
          noteslist.add(e);

          continue;
        }

        // print('tagggs ${e.tags}');
      }
      // print('iff Tag');
      if (selectedFilters.contains('Tag')) {
        if (checkIsThisTextContains(e.subtags.toLowerCase())) {
          noteslist.add(e);

          continue;
        }
      }
    }
    webState(
      () {},
    );
    androidState(() {});
  }

  void loadThisDataInEditingBox() {
    loadMainTags();
    loadTitle();
    loadSubbtags();
    loadMainNote();
    loadBulltes();

    androidState(
      () {},
    );
    webState(
      () {},
    );
  }

  void loadMainTags() {
    maintags.clear();
    List l = _editingNote.tags.split(commonSeparator);
    maintags = List.from(l);
  }

  void loadTitle() {
    titleController.clear();
    titleController.text = _editingNote.title;
  }

  void loadSubbtags() {
    subtags.clear();
    List l = _editingNote.subtags.split(commonSeparator);
    subtags = List.from(l);
  }

  void loadMainNote() {
    noteController.clear();
    noteController.text = _editingNote.note;
  }

  void loadBulltes() {
    bullets.clear();
    List l = _editingNote.bullets.split(commonSeparator);
    bullets = List.from(l);
  }

  String getCurrentUserEmailId() {
    return FirebaseAuth.instance.currentUser == null
        ? 'sdycode@gmail.com'
        : FirebaseAuth.instance.currentUser!.providerData[0].email.toString();
  }

  bool checkIsThisTextContains(String textContentInWhichToSearch) {
    bool _hasText = false;
    List _words = searchController.text.trim().toLowerCase().split(' ');
    for (var e in _words) {
      if (textContentInWhichToSearch.contains(e.trim())) {
        _hasText = true;
        return true;
      }
    }

    return false;
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
                    style: TextStyle(fontSize: h * 0.025),
                  ),
                  Text(
                    noteslist[i].title,
                    style: TextStyle(fontSize: h * 0.022, color: Colors.grey),
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
                    DataService().noteInstance.doc(noteslist[i].id).delete();
                    noteslist.removeAt(i);
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

  void modifyNotesListToShowOnlyUserNotes() {
    noteslist.removeWhere((e) {
      return e.author != getCurrentUserEmailId();
    });
    androidState(() {});
  }

  void updateState() {
    if (kIsWeb) {
      webState(
        () {},
      );
      webData.refresh();
    } else {
      androidState(
        () {},
      );
      androidData.refresh();
    }
  }

  void addNewMainTags() {
    String fulls = '''Aasaan
,Advanced Java Course
,Amazon_web_services
,Android Development Course
,Appointment Booking
,Automation Testing Course
,AWS Cloud Training & Certification
,Azure
,Big Data
,Blockchain
,Blog
,Blog
,Business Excel Course
,C,C++
,C++ Institute
,CakePHP
,Campus Services
,Career
,Careers
,Cart
,CCIE
,CCNA
,CCNA Collaboration
,CCNA Data Center
,CCNA Routing and Switching
,CCNA Security
,CCNA Voice
,CCNA Wireless
,CCNP
,CCNP Data Center
,CCNP Main
,CCNP Routing and Switching
,CCNP Security
,CCNP Troubleshooting
,CCNP Wireless
,Certiport
,CertNexus
,CertNexus Certification
,CHD
,CHD Webinar
,Checkout
,Cisco''';
    // List<String> fsl = fulls.split(',');
    // _technologiesList = fsl;
    // Future.forEach(fsl, (e) async {
    //   final docNote = mainTagsInstance.doc();
    //   await docNote.set({'maintag': e.toString().trim()});
    // });
  }

  selectTechButton() {
    return Padding(
      padding: EdgeInsets.all(h * 0.01),
      child: RawChip(
        label: Text(
          // Shared.isDarkTheme().toString() +
          //     '  ${Shared.getCurrthemefromSharedPref().toString()}  '
          'Select Technology',
          style: TextStyle(color: chipLightBlueColor),
        ),
        backgroundColor: chipDarkBlueColor,
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => technologiesChipsDialog());
        },
      ),
    );
  }

  void _modifyFilteredMaintagList(String text) {
    if (text.trim() == '') {
      print('tagg empyt called');
      _filteredTechnologiesList = Map.from(_technologiesList);
      return;
    }
    _filteredTechnologiesList.clear();
    _technologiesList.forEach((k, v) {
      List _tags = v.trim().split(' ');

      _tags.forEach((e) {
        print(
            'tagg in $e ${_filteredTechnologiesList.length} ${text.toString().toLowerCase()} --  ${e.toString().toLowerCase()}');
        if (e
            .toString()
            .toLowerCase()
            .contains(text.toString().toLowerCase())) {
          _filteredTechnologiesList[k] = v;
        }
      });
    });
  }

  technologiesChipsDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(h * 0.015)),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter dialogState) {
          bool _isKeybordOpen =
              WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                  ? true
                  : false;

          return Container(
            height: h * 0.8,
            width: w,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: mainTagsearchController,
                          cursorColor: chipDarkBlueColor,
                          style: TextStyle(color: chipDarkBlueColor),
                          onChanged: (d) {
                            dialogState(
                              () {
                                _modifyFilteredMaintagList(d);
                              },
                            );
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              labelStyle: TextStyle(
                                  decorationColor: myColors.textfieldborder ??
                                      themeData.primaryColor),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: myColors.textfieldborder ??
                                          themeData.primaryColor),
                                  borderRadius:
                                      BorderRadius.circular(h * 0.02)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: myColors.textfieldborder ??
                                          themeData.primaryColor),
                                  borderRadius:
                                      BorderRadius.circular(h * 0.02)),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    dialogState(() {
                                      mainTagsearchController.clear();
                                      _modifyFilteredMaintagList('');
                                    });
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ))),
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.pop(context);
                        updateState();
                      },
                      elevation: 2.0,
                      fillColor: Colors.grey.shade200,
                      child: Icon(
                        Icons.close,
                        size: 16.0,
                      ),
                      padding: EdgeInsets.all(6.0),
                      shape: CircleBorder(),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          ..._filteredTechnologiesList.entries.map((e) {
                            // int i = _technologiesList.indexOf(e);
                            int i = e.key;
                            double _sidePadding =
                                kIsWeb ? webSideW * 0.015 : w * 0.015;
                            bool _isSelected =
                                maintags.contains(e.value.trim());
                            return Container(
                              margin: EdgeInsets.fromLTRB(_sidePadding,
                                  _sidePadding, _sidePadding, _sidePadding),
                              child: RawChip(
                                  showCheckmark: false,
                                  selected: _isSelected,
                                  selectedColor: chipDarkBlueColor,
                                  backgroundColor: chipLightBlueColor,
                                  onPressed: () {
                                    if (maintags.contains(e.value.trim())) {
                                      maintags.remove(e.value.trim());
                                    } else {
                                      maintags.add(e.value.trim());
                                    }
                                    dialogState(() {});
                                  },
                                  // onSelected: (d) {
                                  //   dialogState(() {
                                  //     if (d) {}
                                  //   });
                                  // },
                                  label: Text(
                                    e.value,
                                    style: TextStyle(
                                        color: _isSelected
                                            ? chipLightBlueColor
                                            : chipDarkBlueColor,
                                        fontSize: h * 0.015),
                                  )),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(),
                Container(
                  height: h * 0.2,
                  width: w,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      children: [
                        ...maintags.map((e) {
                          double _sidePadding =
                              kIsWeb ? webSideW * 0.015 : w * 0.015;
                          return Container(
                              margin: EdgeInsets.fromLTRB(_sidePadding,
                                  _sidePadding, _sidePadding, _sidePadding),
                              child: Chip(
                                backgroundColor:
                                    chipDarkBlueColor.withAlpha(240),
                                label: Text(
                                  e,
                                  style: TextStyle(
                                      color: chipLightBlueColor,
                                      fontSize: h * 0.015),
                                ),
                                onDeleted: () {},
                                deleteIcon: CircleAvatar(
                                  backgroundColor: chipLightBlueColor,
                                  child: Center(
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          dialogState(() {
                                            maintags.remove(e);
                                          });
                                        },
                                        iconSize: 18,
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ));
                        })
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _mainTagsChipsRow() {
    return Container(
      // margin: EdgeInsets.all(h*0.01),
      width: double.infinity,
// color: Colors.red,
      height: h * 0.06,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: maintags.length,
          itemBuilder: (c, i) {
            return Padding(
              padding: EdgeInsets.all(h * 0.01),
              child: Chip(
                label: Text(maintags[i]),
                backgroundColor: chipLightBlueColor,
                labelStyle: TextStyle(fontSize: 13),
              ),
            );
          }),
    );
  }

  void showBulletEditdialog(int i) {
    TextEditingController _tempBulletCont =
        TextEditingController(text: bullets[i]);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: TextField(
                controller: _tempBulletCont,
                maxLines: 10,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: myColors.textfieldFocusborder ??
                                themeData.primaryColor),
                        borderRadius: BorderRadius.circular(h * 0.02)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: myColors.textfieldborder ??
                                themeData.primaryColor),
                        borderRadius: BorderRadius.circular(h * 0.02)),
                    suffixIcon: IconButton(
                      iconSize: h * 0.035,
                      onPressed: () {
                        _tempBulletCont.clear();
                        updateState();
                      },
                      icon: FittedBox(
                        child: closeIcon(),
                      ),
                    )),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () async {
                    bullets[i] = _tempBulletCont.text;
                    updateState();
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
