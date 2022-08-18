import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/web/bullettabweb.dart';
import 'package:stick_box/web/codetabweb.dart';
import 'package:stick_box/web/notetabweb.dart';

import '../utils/provder.dart';

class TabsWeb extends StatefulWidget {
  TabsWeb({Key? key}) : super(key: key);

  @override
  State<TabsWeb> createState() => _TabsWebState();
}

class _TabsWebState extends State<TabsWeb> {
  @override
  Widget build(BuildContext context) {
  Data _data = Provider.of<Data>(context);
    return   Container(
      height: _data.subtags.isEmpty ? _data.h * 0.58 : _data.h * 0.54,
      width: _data.w,
      
      child: TabBarView(controller: _data.tabController, children: [
    
        NoteTabWeb(), 
        BulletTabWeb(),
        CodeTabWeb()
   
      ]),
    );
  }
}