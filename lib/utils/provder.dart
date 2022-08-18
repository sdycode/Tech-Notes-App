import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stick_box/utils/printindebg.dart';
import 'package:stick_box/utils/snackbar.dart';
import 'package:stick_box/utils/theme.dart';

import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../models/notemodel.dart';
import '../services/data_firebase.dart';

class Data with ChangeNotifier {
  refresh() {
    notifyListeners();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  // initMyColors(BuildContext context) {
  //   _myColors = Theme.of(context).extension<MyColors>()!;
  //   _themeData = Theme.of(context);
  // }

  late MyColors myColors;
  // MyColors get myColors => _myColors;

  late ThemeData themeData;
  // ThemeData get themeData => _themeData;
  List<Note> noteslist = [];
  List<Note> fullNoteslist = [];
  Note editingNote = Note('', '');
  Map<int, String> technologiesList = {};
  Map<int, String> filteredTechnologiesList = {};
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
  late BuildContext mainContext;

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
  late TabController tabController;
  TextEditingController noteController = TextEditingController();
  TextEditingController codeTitleController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController bulletController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtagController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController mainTagsearchController = TextEditingController();
  ScrollController maintagsscrollController =
      ScrollController(initialScrollOffset: 0);
  ScrollController filterScrollController =
      ScrollController(initialScrollOffset: 0);
  List<String> selectedFilters = ['All'];
  String data = '';
 bool showSheet = false;
  void setMainContext(BuildContext ctx) {
    mainContext = ctx;
  }

  void setMyColors(MyColors mcolors) {
    myColors = mcolors;
  }

  void setThemeData(ThemeData themdata) {
    themeData = themdata;
  }

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

          value.docs.forEach((e) {
            print(e.data());

            Note note = Note.fromJson(e.data());

            fullNoteslist.add(note);
          });
        },
      );
    } catch (e) {
      showSnack(mainContext, 'errroe in getservernotes  $e');
    }
    try {
      await getMainTags();
    } catch (e) {
      showSnack(mainContext, 'errroe in getMainTags  $e');
    }
    dbg('fulllaf ${fullNoteslist.length}');
    return fullNoteslist;
  }

  Future getMainTags() async {
    await FirebaseFirestore.instance
        .collection('maintag')
        .get(GetOptions(source: Source.serverAndCache))
        .then(
      (value) {
        technologiesList.clear();
        QuerySnapshot<Map<String, dynamic>> f = value;

        int _count = 0;
        value.docs.forEach((e) {
          technologiesList[_count] = (e['maintag']);
          _count++;
        });
        filteredTechnologiesList = Map.from(technologiesList);
      },
    );
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

  String getCurrentUserEmailId() {
    return FirebaseAuth.instance.currentUser == null
        ? 'sdycode@gmail.com'
        : FirebaseAuth.instance.currentUser!.providerData[0].email.toString();
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
      // androidState(() {});
      notifyListeners();
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
    notifyListeners();
    // webState(
    //   () {},
    // );
    // androidState(() {});
  }
  void loadThisDataInEditingBox() {
    loadMainTags();
    loadTitle();
    loadSubbtags();
    loadMainNote();
    loadBulltes();
    notifyListeners();
    // loadCodes();
    // androidState(
    //   () {},
    // );
    // webState(
    //   () {},
    // );
  }

  void loadMainTags() {
    maintags.clear();
    List l = editingNote.tags.split(commonSeparator);
    maintags = List.from(l);
  }

  void loadTitle() {
    titleController.clear();
    titleController.text = editingNote.title;
  }

  void loadSubbtags() {
    subtags.clear();
    List l = editingNote.subtags.split(commonSeparator);
    subtags = List.from(l);
  }

  void loadMainNote() {
    noteController.clear();
    noteController.text = editingNote.note;
  }

  void loadBulltes() {
    bullets.clear();
    List l = editingNote.bullets.split(commonSeparator);
    bullets = List.from(l);
  }

  void modifyFilteredMaintagList(String text) {
    if (text.trim() == '') {
      print('tagg empyt called');
      filteredTechnologiesList = Map.from(technologiesList);
      return;
    }
    filteredTechnologiesList.clear();
    technologiesList.forEach((k, v) {
      List _tags = v.trim().split(' ');

      _tags.forEach((e) {
        print(
            'tagg in $e ${filteredTechnologiesList.length} ${text.toString().toLowerCase()} --  ${e.toString().toLowerCase()}');
        if (e
            .toString()
            .toLowerCase()
            .contains(text.toString().toLowerCase())) {
          filteredTechnologiesList[k] = v;
        }
      });
    });
  }
}
