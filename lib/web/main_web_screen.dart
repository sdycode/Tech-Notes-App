import 'package:flutter/material.dart';
import 'package:stick_box/web/noteslist_widget_web.dart';
import 'package:stick_box/web/search_filter_web.dart';
import '../utils/provder.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/web/search_bar_web.dart';

import '../utils/provder.dart';
import '../utils/theme.dart';

class MainScreenWeb extends StatefulWidget {
  const MainScreenWeb({Key? key}) : super(key: key);

  @override
  State<MainScreenWeb> createState() => _MainScreenWebState();
}

class _MainScreenWebState extends State<MainScreenWeb> {
  @override
  Widget build(BuildContext context) {
    Data _webData = Provider.of<Data>(context);
    MyColors _myColors = Theme.of(context).extension<MyColors>()!;
    

    _myColors = Theme.of(context).extension<MyColors>()!;
    ThemeData _themeData = Theme.of(context);

    return Container(
      width: (_webData.webw / _webData.webh) > 1.5
          ? _webData.webw * 0.55
          : _webData.webw,
      height: _webData.webh,
      color: _myColors.addfullnoteboxbg!,
      child: Column(
        children: [
          
          
          SearchBarWeb(), 
          
          SearchFilterWeb(), 
          NotesListWidgetWeb()
          ],
      ),
    );
  }
}
