// ignore_for_file: unnecessary_statements

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stick_box/main.dart';
import 'package:stick_box/notemodel.dart';
import 'package:stick_box/utils/theme.dart';
import 'package:stick_box/widgets/app_drawer.dart';

import 'constants.dart';
import 'sizes.dart';
import 'utils/shared.dart';

class CloudStoreScreen extends StatefulWidget {
  const CloudStoreScreen({Key? key}) : super(key: key);

  @override
  State<CloudStoreScreen> createState() => _CloudStoreScreenState();
}

class _CloudStoreScreenState extends State<CloudStoreScreen>
    with TickerProviderStateMixin {
  CollectionReference<Map<String, dynamic>> noteInstance =
      FirebaseFirestore.instance.collection('notes');
  Stream<QuerySnapshot> notesStream =
      FirebaseFirestore.instance.collection('notes').snapshots();
  late TabController tabController;
  // ScrollController notescrollController =
  //     ScrollController(initialScrollOffset: 0);
  ScrollController maintagsscrollController =
      ScrollController(initialScrollOffset: 0);
  ScrollController filterScrollController =
      ScrollController(initialScrollOffset: 0);

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
  // DraggableScrollableController draggableScrollableController =
  //     DraggableScrollableController();
  bool isAdmin = false;
  bool isCodeEditing = false;
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
  List<String> maintags = [
    'iOS',
    'Native',
    'Android',
    'Dart',
    'Other',
    'Flutter'
  ];

  List<String> mytags = [];
  List<String> selectedFilters = [];
  String data = '';
  double webMainWFactor = 0.55;
  double webSideWFactor = 0.45;

  double webMainW = Sizes().sw * 0.55;
  double webSideW = Sizes().sw * 0.45;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kIsWeb ? loadDataFromServer() : () {};
    isAdmin = Shared.isAdmin;
    tabController = TabController(length: 3, vsync: this);

    getMainTags();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('build called  after  on post  ${Random().nextInt(5000)}');
      kIsWeb ? wetState(() {}) : hetState(() {});
      // if (mounted) {
      //   kIsWeb ? wetState(() {}) : hetState(() {});
      // }
    });
  }

  List<Note> noteslist = [];
  TextEditingController noteController = TextEditingController();
  TextEditingController codeTitleController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController bulletController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtagController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  bool showSheet = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StateSetter state = (d) {};
  StateSetter hetState = (d) {};
  StateSetter wetState = (d) {};
  late MyColors myColors;
  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    // getAdminStatus();
    //   kIsWeb ? wetState(() {}) : hetState(() {});

    myColors = Theme.of(context).extension<MyColors>()!;
    themeData = Theme.of(context);
    print('build called on ${Random().nextInt(5000)}');
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        body: kIsWeb
            ? webCode()
            : Stack(fit: StackFit.expand, children: [
                NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (c, b) => [
                    SliverAppBar(
                      automaticallyImplyLeading: true,
                      backgroundColor: Colors.deepPurple,
                      actions: [
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(h * 0.01),
                            child: Image.asset('assets/paste1.png'),
                          ),
                        ),
                        FittedBox(
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.menu,
                                color: Colors.purple.shade200,
                              )),
                        )
                      ],
                      floating: true,
                      // pinned: true,
                    ),
                    SliverList(delegate: SliverChildListDelegate([])),
                    // Text('data'),
                    // noteslist.isNotEmpty ? notesWidgets() : Container(),

                    // Container(
                    //   height: h*0.5,
                    //   child: FutureBuilder(
                    //     future: getallCacheNotes(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasData &&
                    //           snapshot.connectionState == ConnectionState.done) {
                    //         noteslist = snapshot.data as List<Note>;
                    //         print('snap list ${noteslist.length}');
                    //         return Container(
                    //           height: h * 0.5,
                    //           child: ListView.builder(
                    //               itemCount: noteslist.length,
                    //               itemBuilder: (c, i) {
                    //                 return Text(noteslist[i].note);
                    //               }),
                    //         );
                    //       } else {
                    //         return Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       }
                    //     },
                    //   ),
                    // ),

                    // StreamBuilder<QuerySnapshot>(
                    //   stream: notesStream,
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData &&
                    //         snapshot.connectionState == ConnectionState.done) {
                    //       return Container(
                    //         height: h * 0.5,
                    //         width: w,
                    //       );
                    //     } else {
                    //       return CircularProgressIndicator();
                    //     }
                    //   },
                    // ),
                  ],
                  body: Column(
                    children: [
                      Text('data'),
                      Container(
                        height: h * 0.5,
                        child: FutureBuilder(
                          future: getallCacheNotes(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              noteslist = snapshot.data as List<Note>;
                              print('snap list ${noteslist.length}');

                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter sState) {
                                state = sState;
                                return Container(
                                  height: h * 0.5,
                                  child: ListView.builder(
                                      itemCount: noteslist.length,
                                      itemBuilder: (c, i) {
                                        return Text(noteslist[i].note);
                                      }),
                                );
                              });
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                      // TextField(
                      //   controller: noteController,
                      //   decoration: InputDecoration(border: OutlineInputBorder()),
                      // ),
                      // Divider(),
                      // TextField(
                      //   controller: titleController,
                      //   decoration: InputDecoration(border: OutlineInputBorder()),
                      // ),
                      // ElevatedButton(
                      //     onPressed: () async {
                      //       await addNote();
                      //     },
                      //     child: Text('add')),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       // setState(() {
                      //       noteslist.clear();
                      //       // });
                      //     },
                      //     child: Text('clear')),
                      // ElevatedButton(
                      //     onPressed: () async {
                      //       // noteslist =
                      //       await getallCacheNotes();
                      //       // setState(() {});

                      //       noteslist.forEach((element) {
                      //         print(' note is $element');
                      //       });
                      //     },
                      //     child: Text('get'))
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter sheetStt) {
                    hetState = sheetStt;
                    return Container(
                        margin: EdgeInsets.only(
                            bottom: max(
                                MediaQuery.of(context).viewPadding.bottom,
                                MediaQuery.of(context).viewInsets.bottom)),
                        child: showSheet
                            ? addBottomSheet(context)
                            : floatingButton());
                  }),
                )

                // Container(
                //   // height: h*0.7,
                //   // width: w*0.9,
                //   margin: EdgeInsets.all(w * 0.05),
                //   color: Colors.orange,
                //   child: floatingButton(),
                // )

                // Positioned(
                //     top: h * 0.3,
                //     left: 0,
                //     child: showSheet
                //         ? addBottomSheet(context)
                //         : SizedBox(
                //             height: 0,
                //           ))

                // child: BottomSheet(
                //   // expand: false,
                //   // // onClosing: () {},

                //   builder: (
                //     context,
                //   ) =>
                //       showSheet
                //           ? addBottomSheet(context)
                //           : SizedBox(
                //               height: 0,
                //             ),
                //   onClosing: () {},
                // ),
              ]),
        resizeToAvoidBottomInset: false,
      ),
    );
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
    for (int i = 0; i < mytags.length; i++) {
      tagText += mytags[i];

      final t = i < mytags.length - 1 ? '__' : '';
      tagText += t;
    }
    print('tagtext $tagText');
    final docNote = noteInstance.doc();
    Note note = Note(titleController.text, noteController.text);
    note.code = code;
    note.tags = tagText;
    note.id = docNote.id;
    note.bullets = bulletText;

    note.subtags = subtagsText;
    note.epoch = DateTime.now().millisecondsSinceEpoch;
    note.time = DateTime.now();

    // final json = {
    //   'id': docNote.id,
    //   'title': 'this is 1st post note',
    //   'tag': 'flutter',
    //   'subtag': '',
    //   'note': 'this is full note',
    //   'code': 'here full code will come',
    //   'time': DateTime.now(),
    //   'epoch': DateTime.now().millisecondsSinceEpoch
    // };
    noteslist.add(note);
    final json = note.toJson();
    await docNote.set(json);

    // setState(() {});
  }

  // Future<List<Note>>

  Future<List<Note>> getallCacheNotes() async {
    // await noteInstance.get(GetOptions(source: Source.cache)).then(
    //   (value) {
    //     noteslist.clear();
    //     QuerySnapshot<Map<String, dynamic>> f = value;
    //     print('data  in cache ${value.docs.length}');
    //     print("get firestore insta ${f.docs.first.data()}");
    //     value.docs.forEach((e) {
    //       // Timestamp t = e.data()['time'];
    //       // DateTime d = t.toDate();
    //       Note note = Note.fromJson(e.data());
    //       // note.time = d;
    //       // print('doc ${d}');
    //       noteslist.add(note);
    //     });
    //     // print('get akk called in get ${notes}');
    //     // setState(() {
    //     //   print('notess ${noteslist.length}');
    //     // });
    //   },
    // );
    // int snaps = await noteInstance.snapshots().length;
    // print('get akk called ${snaps} && cachelength ${noteslist.length}');
    if (noteslist.length < 1) {
      //  noteInstance
      await noteInstance.get(GetOptions(source: Source.serverAndCache)).then(
        (value) {
          noteslist.clear();
          QuerySnapshot<Map<String, dynamic>> f = value;
          print('data ${value.docs.length}');
          print("get firestore insta ${f.docs.first.data()}");
          // value.docChanges.first.doc.
          value.docs.forEach((e) {
            // Timestamp t = e.data()['time'];
            // DateTime d = t.toDate();
            Note note = Note.fromJson(e.data());
            // note.time = d;
            // print('doc ${d}');
            noteslist.add(note);
          });
          // print('get akk called in get ${notes}');
          // setState(() {
          //   print('notess ${noteslist.length}');
          // });
        },
      );
    } else {
      await noteInstance.get(GetOptions(source: Source.cache)).then(
        (value) {
          noteslist.clear();
          QuerySnapshot<Map<String, dynamic>> f = value;
          print('data ${value.docs.length}');
          print("get firestore insta ${f.docs.first.data()}");

          value.docs.forEach((e) {
            // Timestamp t = e.data()['time'];
            // DateTime d = t.toDate();
            Note note = Note.fromJson(e.data());
            // note.time = d;
            // print('doc ${d}');
            noteslist.add(note);
          });
          // print('get akk called in get ${notes}');
          // setState(() {
          //   print('notess ${noteslist.length}');
          // });
        },
      );
    }
    // QuerySnapshot<Map<String, dynamic>> f =
    //     noteInstance.snapshots().first as QuerySnapshot<Map<String, dynamic>>;

    // print("get firestore insta ${f.docs.first.data()['title']}");
    // FirebaseFirestore.instance.enableNetwork();
    //  noteInstance.snapshots().map((snapshot) {
    //   print('get akk called on $snapshot');
    //   snapshot.docs.forEach((e) {
    //     Timestamp t = e.data()['time'];
    //     DateTime d = t.toDate();
    //     Note note = Note.fromJson(e.data());
    //     note.time = d;
    //     print('doc ${d}');
    //     notes.add(note);
    //   });
    print('doc   ----------over');
    // print('get akk called  ${notes}');
    // return snapshot.docs.map((doc) {
    //   return Note.fromJson(doc.data());
    // }) as Note;
    // });

    return noteslist;
  }

  notesWidgets() {
    return Container(
      height: h * 0.5,
      color: Colors.red,
      child: ListView.builder(
          itemCount: noteslist.length,
          itemBuilder: (c, i) {
            return Text(
                ' ${noteslist[i].id} \n  ${noteslist[i].epoch} \n  ${noteslist[i].title} \n ');
          }),
    );
  }

  Widget addBottomSheet(BuildContext context) {
    return Container(
        height: h * 0.8,
        width: w,
        margin: EdgeInsets.all(w * 0.04),

        // margin: EdgeInsets.only(top: h * 0.1, left: w*0.08),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(w * 0.08),
            // topLeft: Radius.circular(w * 0.08),
            // topRight: Radius.circular(w * 0.08),
          ),
          color: Color.fromARGB(255, 250, 240, 225),
        ),
        child: Stack(
          children: [
            Container(
              height: h * 0.74,
              // color: Colors.amber,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(w * 0.08 * 0)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: w * 0.05,
                        color: Colors.transparent,
                      ),
                      tagsRow(),
                      titleWidget(),
                      //  tagWidget(),
                      subtagWidget(),
                      subtagsRow(),
                      tabRow(),
                      SizedBox(
                        height: h * 0.005,
                      ),
                      tabs(),

                      // SizedBox(
                      //   height: max(MediaQuery.of(context).viewPadding.bottom,
                      //       MediaQuery.of(context).viewInsets.bottom),
                      // )
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
            // height: webh * 0.08,
            // margin: EdgeInsets.all(webSideW * 0.02),

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
                    //  height: h*0.06,

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
                          // isCollapsed: false,
                          contentPadding:
                              // EdgeInsets.zero,
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
                                wetState(() {
                                  titleController.clear();
                                });
                              },
                              icon: FittedBox(
                      child: closeIcon(),
                     ),)),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        // color: Colors.purple,
                        width: webSideW * 0.08,
                        padding: EdgeInsets.all(webh * 0.005),
                        height: webh * 0.05,
                        child: FittedBox(
                            child: Image.asset(
                          'assets/paste1.png',

                          // color: myColors.pasteicon,
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
                                hetState(() {
                                  titleController.clear();
                                });
                              },
                            icon: FittedBox(
                      child: closeIcon(),
                     ),)),
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
    //   wetState(() {});
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
                            wetState(() {
                              subtagController.text = '';
                            });
                          },
                         icon: FittedBox(
                      child: closeIcon(),
                     ),)),
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
                  wetState(() {
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
                    child: FittedBox(child: addIcon())),
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
                                hetState(() {
                                  subtagController.text = '';
                                });
                              },
                             icon: FittedBox(
                      child: closeIcon(),
                     ),)),
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
                      hetState(() {
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
                        child: FittedBox(child: addIcon())),
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
          hetState(() {
            showSheet = !showSheet;
          });
        },
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add_card, color: myColors.iconcolors,),
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
                      hetState(() {
                        showSheet = false;
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
                            '  Discard  ',
                            style: TextStyle(color: myColors.fainttext),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      wetState(() {
                        if (checkTextisValid(titleController.text) &&
                            checkTextisValid(noteController.text) &&
                            mytags.isNotEmpty) {
                          addNote();
                          showSheet = false;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              C.getSnackBar(C.noTitlenoNotenoTag));

                          // if (mytags.isEmpty &&
                          //     !checkTextisValid(titleController.text) &&
                          //     !checkTextisValid(noteController.text)) {
                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(C.getSnackBar(C.noTag));
                          // } else if (mytags.isEmpty &&
                          //     checkTextisValid(titleController.text) &&
                          //     !checkTextisValid(noteController.text)) {
                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(C.getSnackBar(C.noTitlenoTag));
                          // } else if (mytags.isEmpty &&
                          //     !checkTextisValid(titleController.text) &&
                          //     checkTextisValid(noteController.text)) {
                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(C.getSnackBar(C.noNotenoTag));
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //       C.getSnackBar(C.noTitlenoNotenoTag));
                          // }
                        }
                      });
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
                                color:Color.fromARGB(255, 19, 187, 24))
                          ],
                          borderRadius: BorderRadius.circular(h * 0.05),
                          color: myColors.pasteicon ?? themeData.primaryColor),
                      child: Padding(
                        padding: EdgeInsets.all(h * 0.005),
                        child: FittedBox(
                          child: Text(
                            '  Save  ',
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
                    hetState(() {
                      showSheet = false;
                    });
                  },
                  child: Container(
                    height: h * 0.04,
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
                          style: TextStyle(color: myColors.normaltext),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      addNote();
                      showSheet = false;
                    });
                  },
                  child: Container(
                    height: h * 0.04,
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
                        color: myColors.pasteicon ?? themeData.primaryColor),
                    child: Padding(
                      padding: EdgeInsets.all(h * 0.005),
                      child: FittedBox(
                        child: Text(
                          '  Save & Close  ',
                          style: TextStyle(color: myColors.iconcolors),
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
    bool isTagMarked = mytags.contains(maintags[i]);
    // if(mytags.contains(maintags[i])){}
    return kIsWeb
        ? Transform.scale(
            scale: isTagMarked ? 1.05 : 1,
            child: InkWell(
  onTap: () {
                        wetState(() {
                          if (!mytags.contains(maintags[i])) {
                            mytags.add(maintags[i]);
                          } else {
                            mytags.remove(maintags[i]);
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
                                  color: myColors.fainttext ?? themeData.primaryColor,
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
                      child: Text(maintags[i], 
                      style: TextStyle(
                        color: isTagMarked ? myColors.normaltext :myColors.normaltext
                      ),
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
                    hetState(() {
                      if (!mytags.contains(maintags[i])) {
                        mytags.add(maintags[i]);
                      } else {
                        mytags.remove(maintags[i]);
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
                      ? wetState(() {
                          subtags.removeAt(i);
                        })
                      : hetState(() {
                          subtags.removeAt(i);
                        });
                },
                child: Padding(
                  padding: EdgeInsets.only(left: w * 0.02),
                  child: FittedBox(
                      child: CircleAvatar(
                    backgroundColor: myColors.brandColor!.withGreen(180),
                    child:   closeIcon(),
                  )),
                ),
              ),
            )
            // IconButton(onPressed: (){},
            // iconSize: h*0.02,
            //  icon: Icon(Icons.close_rounded))
          ],
        ));
  }

  Future getMainTags() async {
    FirebaseFirestore.instance
        .collection('maintag')
        .get(GetOptions(source: Source.serverAndCache))
        .then(
      (value) {
        maintags.clear();
        QuerySnapshot<Map<String, dynamic>> f = value;
        print('data ${value.docs.length}');
        print("get firestore insta ${f.docs.first.data()}");
        value.docs.forEach((e) {
          // Timestamp t = e.data()['time'];
          // DateTime d = t.toDate();
          // Note note = Note.fromJson(e.data());
          // note.time = d;
          // print('doc ${d}');
          maintags.add(e['maintag']);
        });
        // print('get akk called in get ${notes}');
        // setState(() {
        //   print('notess ${noteslist.length}');
        // });

        print('maintagss $maintags');
        Future.delayed(Duration(seconds: 3)).then((value) {
          hetState(() {});
        });
      },
    );
  }

  tabs() {
    return Container(
      height: subtags.isEmpty ? h * 0.58 : h * 0.54,
      width: w,
      // color: Colors.blue,
      child: TabBarView(controller: tabController, children: [
        noteTab(),
        bulletTab(),
        codeTab(),
      ]),
    );
    // switch (tabIndex) {
    //   case 0:
    //     return noteTab();

    //   default:
    //     noteTab();
    // }
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
                                  ? wetState(() {
                                      noteController.clear();
                                    })
                                  : hetState(() {
                                      noteController.clear();
                                    });
                            },
                            icon: FittedBox(
                      child: closeIcon(),
                     ),),

                        //  addwithpaste
                        IconButton(
                            iconSize: kIsWeb ? webh * 0.03 : w * 0.06,
                            onPressed: () async {
                              ClipboardData? cdata =
                                  await Clipboard.getData(Clipboard.kTextPlain);
                              noteController.clear();

                              noteController.text = cdata!.text!;
                              kIsWeb
                                  ? wetState(() {})
                                  : hetState(() {
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
                                ? wetState(() {})
                                : hetState(() {
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
                            kIsWeb ? wetState(() {}) : hetState(() {});
                          },
                        icon: FittedBox(
                      child: closeIcon(),
                     ),),

                      //  addwithpaste
                      IconButton(
                          iconSize: kIsWeb ? webh * 0.03 : w * 0.06,
                          onPressed: () async {
                            ClipboardData? cdata =
                                await Clipboard.getData(Clipboard.kTextPlain);
                            bulletController.clear();

                            bulletController.text = cdata!.text!;
                            kIsWeb ? wetState(() {}) : hetState(() {});
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

                            kIsWeb ? wetState(() {}) : hetState(() {});
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

  Widget addIcon() {
    return Icon(
      Icons.add,
      color: myColors.closeicon,
    );
  }

  Widget codeTab() {
    return Container(
      height: subtags.isEmpty ? h * 0.4 : h * 0.38,

      width: webSideW,
      // color: Colors.primaries.first,
      child: Column(
        children: [
          Container(
            // color: Colors.green,
            padding: EdgeInsets.only(left: webSideW * 0.0081),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
    );
  }

  Widget tabRow() {
    print('tabController ${tabController.index}');
    tabController.addListener(() {
      wetState(() {});
    });
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
                      color: tabController.index == 2
                          ? myColors.tabiconactive
                          : myColors.tabiconInctive,
                    ),
                  )
                ],
              )),
            ],
          ),
        )
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Tab(
        //       text: 'Note',
        //       icon: Icon(Icons.notes),
        //     ),

        //   ],
        // ),
        );
  }

  webCode() {
    print(
        'snap list  on web code ${Random().nextInt(1000)}  web code${noteslist.length}');

    return LayoutBuilder(builder: (context, constraits) {
      webh = constraits.maxHeight;
      webw = constraits.maxWidth;
      webMainW = webw * webMainWFactor;
      webSideW = webw * webSideWFactor;
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter wtState) {
        wetState = wtState;
        print('isadmin $isAdmin');
        // codetabindex = codetabindex >= codetabbtnnames.length
        //     ? codetabbtnnames.length - 1
        //     : codetabindex;

        // if (isCodeEditing) {
        //   codetabindex = editCodeIndex;
        // }
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
  }

  mainScreenWeb() {
    return Container(
      width: (webw / webh) > 1.5 ? webw * 0.55 : webw,
      height: webh,
      color: myColors.addfullnoteboxbg,
      child: Column(
        children: [searchBarWeb(), searchfiltersWeb(), notesListWidget()],
      ),
    );
  }

  addNoteCodeWeb() {
    return Container(
      width: webw * 0.45,
      height: webh,
      color: myColors.addfullnoteboxbg,
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
          color: myColors.addfullnoteboxbg,
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
              // color: Colors.amber.shade100,
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
          borderRadius: BorderRadius.circular(webh * 0.05)),
      child: Padding(
          padding: EdgeInsets.all(webh * 0.005),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: webSideW * 0.03),
                child: Text(
                  bullets[i],
                  style: TextStyle(fontSize: webh * 0.025, 
                  
                  color: myColors.normaltext
                  ),
                ),
              ),
              IconButton(
                  iconSize: webh * 0.03,
                  onPressed: () {
                    kIsWeb
                        ? wetState(() {
                            bullets.removeAt(i);
                          })
                        : hetState(() {
                            bullets.removeAt(i);
                          });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
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

        tagsRow(),
        titleWidget(),
        //  tagWidget(),
        subtagWidget(),
        subtagsRow(),
        tabRow(),
        SizedBox(
          height: h * 0.005,
        ),
        tabs(),

        // SizedBox(
        //   height: max(MediaQuery.of(context).viewPadding.bottom,
        //       MediaQuery.of(context).viewInsets.bottom),
        // )
      ],
    );
  }

  codeTabBtn(int i) {
    return Transform.scale(
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
                    ? wetState(() {
                        codetabindex = i;
                        // print(' codetabindex $codetabindex and $i');
                      })
                    : hetState(() {
                        codetabindex = i;
                      });
              },
              child: FittedBox(
                child: i < 0 ? Text('New Code') : Text(codetabbtnnames[i]),
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
          : h * 0.3,
      width: webSideW,
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
                  IconButton(
                      iconSize: h * 0.03,
                      onPressed: () {
                        // int j = codetabindex - 1;
                        // codes.removeAt(codetabindex);
                        // codetabbtnnames.removeAt(codetabindex);

                        kIsWeb
                            ? wetState(() {
                                //  codeT
                                isCodeEditing = true;
                                codeTitleController.text =
                                    codetabbtnnames[cdindex];
                                codeController.text = codes[cdindex];
                                editCodeIndex = cdindex;
                                codetabindex = -1;
                              })
                            : hetState(() {});
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.deepPurple,
                      )),
                  IconButton(
                      iconSize: h * 0.03,
                      onPressed: () {
                        int j = cdindex - 1;
                        codes.removeAt(cdindex);
                        codetabbtnnames.removeAt(cdindex);

                        kIsWeb
                            ? wetState(() {
                                cdindex = j;
                                codetabindex = j;
                                // if(cd)
                                print('wetState  ${cdindex}');
                              })
                            : hetState(() {});
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ]),
                Divider( color: myColors.normaltext,),
                Expanded(
                  // height: h*0.3,
                  child: SingleChildScrollView(
                      child: Container(
                          margin: EdgeInsets.all(webSideW * 0.01),
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
        width: webSideW,
        margin: EdgeInsets.all(webSideW * 0.01),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // width: kIsWeb
              //     ? webSideW - webh * 0.05 - webSideW * 0.12
              //     : w - webh * 0.05 - webSideW * 0.12,
              child: TextField(
                controller: codeTitleController,
                keyboardType: TextInputType.multiline,
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
                            ? wetState(() {
                                codeTitleController.clear();
                              })
                            : hetState(() {
                                codeTitleController.clear();
                              });
                      },
                      child: FittedBox(
                        child: Padding(
                          padding: EdgeInsets.all(webh * 0.015),
                          child: Container(child: closeIcon()),
                        ),
                      ),
                    )

                    // IconButton(
                    //    iconSize: webh * 0.035,
                    //     onPressed: () {
                    //    kIsWeb  ? wetState(() {
                    //         titleController.clear();
                    //       }):hetState(() {
                    //         titleController.clear();
                    //       });
                    //     },
                    //     icon: Icon(
                    //       Icons.close,
                    //       color: Colors.pink,
                    //     ))
                    ),
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

                        wetState(() {
                          isCodeEditing = false;
                        });
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
                    kIsWeb ? wetState(() {}) : hetState(() {});
                  }
                },
                icon: addIcon())
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
                        wetState(() {
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
                        hetState(() {
                          codeController.clear();
                        });
                      },
                     icon: FittedBox(
                      child: closeIcon(),
                     ),)),
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
              iconSize: min(tileW * 0.06, webh * 0.04),
              padding: EdgeInsets.zero,
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
                // customTheme.toggleTheme();
              },
              icon: Icon(
                Icons.menu,
                color: myColors.danger,
              )),
          Container(
            width: tileW * 0.83,
            child: TextField(
                controller: searchController,
                cursorColor: Colors.pink,
                decoration: InputDecoration(
                  labelText: "Search any topic",
                  // ${noteslist.length}
                  labelStyle: TextStyle(color: Colors.pink),
                  // join,
                  // '${webw.round()} / ${webMainW.round()}  / ${webSideW.round()}',
                  contentPadding: EdgeInsets.all(webh * 0.005 * 0),

                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: C.titleColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(h * 0.02)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: C.titleColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(h * 0.02)),
                  prefixIcon: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.search,
                        size: webh * 0.02,
                        color: Colors.grey,
                      )),

                  suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: webh * 0.02,
                      onPressed: () {
                        wetState(() {
                          searchController.clear();
                        });
                      },
                      icon: FittedBox(
                      child: closeIcon(),
                     ),),
                  // InkWell(
                  //     onTap: () {
                  //       wetState(() {
                  //         searchController.clear();
                  //       });
                  //     },
                  //     child: Icon(
                  //       Icons.close,
                  //       size: webh * 0.02,
                  //     )),
                ),
                style: TextStyle(
                    fontSize: webh * 0.022,
                    //  height: 1.0,
                    color: Colors.black)),
          ),
          IconButton(
              iconSize: min(tileW * 0.06, webh * 0.04),
              padding: EdgeInsets.zero,
              onPressed: () {
                wetState(() {
                  getAdminStatus();
                });
              },
              icon: Icon(Icons.refresh, 
              
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

  filterTab(int i) {
    bool isTagMarked = selectedFilters.contains(filters[i]);
    return Transform.scale(
      scale: isTagMarked ? 1.05 : 1,
      child: InkWell(
        onTap: () {
          wetState(() {
            if (!selectedFilters.contains(filters[i])) {
              selectedFilters.add(filters[i]);
            } else {
              selectedFilters.remove(filters[i]);
            }
          });
        },
        child: Container(
          margin: EdgeInsets.only(
            bottom: webh * 0.03,
            left: webMainW * 0.012,
            top: webh * 0.008,
          ),
          child: Container(
              height: webh * 0.06,
              decoration: BoxDecoration(
                  color: isTagMarked
                      ? myColors.tabbuttonActive
                      : myColors.tabbutton,
                  borderRadius: BorderRadius.circular(webh * 0.05),
                  boxShadow: !isTagMarked
                      ? []
                      : [
                          BoxShadow(
                            color: myColors.normaltext!,
                              offset: Offset(0.5, 0.5),
                              spreadRadius: 0.5,
                              blurRadius: 2)
                        ]
                  // border: isTagMarked ? Border.all() : null
                  ),
              margin: EdgeInsets.all(webh * 0.002),
              padding: EdgeInsets.only(
                  left: webw * 0.02,
                  right: webw * 0.02,
                  top: webh * 0.005,
                  bottom: webh * 0.005),
              child: FittedBox(
                child: Text(filters[i], 
                
                style: TextStyle(
                  color: isTagMarked ? myColors.normaltext: myColors.normaltext
                ),
                ),
              )),
        ),
      ),
    );
  }

  notesListWidget() {
    print('notess ${noteslist.length}');
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

    String subtitlemaintags = noteslist[i].tags.replaceAll('__', ', ');
    String subtitlesubtags = noteslist[i].subtags.replaceAll('__', ', ');
    List<String> bulltesInTile = noteslist[i].bullets.split('__');
    List<String> fullcodes = noteslist[i].code.split('__');
    List<List<String>> codepairs = [];
    fullcodes.forEach((e) {
      List pair = e.split('_*_');
      print(' pair $pair');
      // codepairs.add([pair[0], pair[1]]);
    });

    return Container(
        width: tileW,
        // color: Colors.green,
        margin: EdgeInsets.all(tileW * 0.005),
        decoration: BoxDecoration(
            color:
            myColors.expansionboxbg,
            //  Color.fromARGB(255, 242, 238, 202),
            boxShadow: [BoxShadow(offset: Offset(0.5, 0.5))]),
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.platform,
          iconColor: myColors.addpasteicon,
          collapsedIconColor:myColors.addpasteicon ,
          maintainState: true,
          title: SingleChildScrollView(
            child: Text(
              noteslist[i].title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: webh * 0.035,
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
                        fontWeight: FontWeight.w200,
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
                  isAdmin
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: tileW * 0.04,
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: Colors.deepPurple,
                          ))
                      : Container(),
                  isAdmin
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: tileW * 0.04,
                          onPressed: () {
                            wetState(() {
                              noteInstance.doc(noteslist[i].id).delete();
                              noteslist.removeAt(i);
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                      : Container()
                ],
              ),
            ),
            // Divider(
            //   indent: indent,
            //   endIndent: endIndent,
            // ),
            // Row(
            //   children: [
            //     tilesubpartheading('subtags', indent),
            //     Text(
            //      subtitlesubtags,
            //       // noteslist[i].subtags,
            //       style: TextStyle(
            //         fontWeight: FontWeight.w200,
            //         // fontSize: webh * 0.045,
            //         color: Colors.black,
            //       ),
            //     ),
            //   ],
            // ),
            Divider(
              color: myColors.normaltext,
              indent: indent,
              endIndent: endIndent,
            ),
            Row(
              children: [
                tilesubpartheading('note', indent),
                Text(
                  noteslist[i].note,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    // fontSize: webh * 0.015,
                  ),
                ),
              ],
            ),
            Divider( color: myColors.normaltext,
              indent: indent,
              endIndent: endIndent,
            ),
            Container(
              width: tileW,
              child: Row(
                children: [
                  tilesubpartheading('bullets', indent),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...(bulltesInTile.asMap().entries.map((e) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text((e.key + 1).toString() + '. '),
                            Text(e.value)
                          ],
                        );
                      }).toList())
                    ],
                  )),
                ],
              ),
            ),
            Divider( color: myColors.normaltext,
              indent: indent,
              endIndent: endIndent,
            ),

            Row(
              children: [
                tilesubpartheading('code', indent),
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
                          //   // itemCount: codepairs.length+2,
                          itemCount: 5,
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
                                      // Text( codepairs[i][0]+'fdfdsf$i'),
                                      // Text( codepairs[i][1]+'fdfdsf$i'),

                                      Text('fdfdsf$i'),
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
                                      Text(
                                          'fdfdsf$i fdffffffffffffffffffffffff'),
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
          ],
        )
        // Text(noteslist[i].note),
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

  Widget tilesubpartheading(String s, double d) {
    return Container(
      width: d,
      child: Text(
        s,
        style: TextStyle(
          fontWeight: FontWeight.w200,
          fontSize: webh * 0.015,
          color: Colors.grey,
        ),
      ),
    );
  }

  void getAdminStatus() {
    isAdmin = Shared.isAdmin;
    print('isadmin status $isAdmin');
  }

  Future loadDataFromServer() async {
    noteslist = await getallCacheNotes();
    setState(() {});
  }
}

// void addNewNote() {
//   showModalBottomSheet(
//       context: context,
//       elevation: 6,
//       isDismissible: false,
//       isScrollControlled: true,
//       enableDrag: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       // anchorPoint: Offset(w*0.50, h*0.6),
//       builder: (context) {
//         return DraggableScrollableSheet(
//             controller: draggableScrollableController,
//             maxChildSize: 0.8,
//             initialChildSize: 0.8,
//             minChildSize: 0.08,
//             expand: false,
//             snap: true,
//             snapSizes: [0.08, 0.8],
//             builder: (context, sheetscrollcont) {
//               //  draggableScrollableController.addListener(() {
//               //     print('scroll con ${draggableScrollableController.size}');
//               //   });
//               return SingleChildScrollView(
//                 controller: sheetscrollcont,
//                 child: draggableScrollableController.size < 0.082
//                     ? Container(
//                         height: h * 0.082,
//                         width: w,
//                         color: Colors.orange.shade200,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               width: w * 0.7,
//                               child: FittedBox(
//                                 child: Padding(
//                                   padding: EdgeInsets.all(w * 0.05),
//                                   child: Text('Do you want to save data ?'),
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                                 padding: EdgeInsets.all(2),
//                                 iconSize: (w * 0.08),
//                                 onPressed: () {},
//                                 icon: Icon(
//                                   Icons.check,
//                                 )),
//                             IconButton(
//                                 padding: EdgeInsets.all(2),
//                                 iconSize: (w * 0.08),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 icon: Icon(
//                                   Icons.close,
//                                 )),
//                           ],
//                         ))
//                     : Container(
//                         child: Column(
//                           children: [
//                             Container(
//                               height: 2,
//                               color: Colors.transparent,
//                             ),
//                             titleWidget(),
//                             titleWidget(),

//                             titleWidget(), titleWidget(), titleWidget(),
//                             titleWidget(), titleWidget(), titleWidget(),
//                             titleWidget(), titleWidget(), titleWidget(),
//                             titleWidget(), titleWidget(), titleWidget(),
//                             SizedBox(
//                               height: max(
//                                   MediaQuery.of(context).viewPadding.bottom,
//                                   MediaQuery.of(context).viewInsets.bottom),
//                             )
//                             // tagWidget(),
//                             // subtagsWidget(),
//                           ],
//                         ),
//                       ),
//               );
//             });
//       });
// }
