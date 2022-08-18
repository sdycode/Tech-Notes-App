import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/provder.dart';
import 'bullettab.dart';
import 'codetab.dart';
import 'notetab.dart';

class TabsAndroid extends StatefulWidget {
  TabsAndroid({Key? key}) : super(key: key);

  @override
  State<TabsAndroid> createState() => _TabsAndroidState();
}

class _TabsAndroidState extends State<TabsAndroid> {
  @override
  Widget build(BuildContext context) {
    Data _data = Provider.of<Data>(context);
    return Container(
      height: _data.subtags.isEmpty ? _data.h * 0.58 : _data.h * 0.54,
      width: _data.w,
      child: TabBarView(
          controller: _data.tabController,
          children: [NoteTabAndroid(), BulletTabAndroid(), CodeTabAndroid()]),
    );
  }
}
