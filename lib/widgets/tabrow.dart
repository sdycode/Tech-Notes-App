

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/provder.dart';

class TabRow extends StatelessWidget {
  const TabRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
       Data _data = Provider.of<Data>(context, listen: true);
     double _textSize = kIsWeb ? _data.webSideW * 0.035 : _data.w * 0.035;
    print('_data.tabController ${_data.tabController.index}');
    // _data.tabController.addListener(() {
    //   webState(() {});
    // });
    return Container(
        height: _data.h * 0.05,
        width: _data.w,
        child: DefaultTabController (
          length: 3,
          child: TabBar(
            indicatorColor: _data.myColors.tabiconactive,
            controller: _data.tabController,
            tabs: [
              Tab(
                  icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.notes,
                    color: _data.tabController.index == 0
                        ? _data.myColors.tabiconactive
                        : _data.myColors.tabiconInctive,
                  ),
                  Text(
                    'Note',
                    style: TextStyle(
                      fontSize: _textSize,
                      color: _data.tabController.index == 0
                          ? _data.myColors.tabiconactive
                          : _data.myColors.tabiconInctive,
                    ),
                  )
                ],
              )),
              Tab(
                  icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.all(_data.h * 0.008),
                    child: Image.asset(
                      'assets/bullet.png',
                      fit: BoxFit.cover,
                      color: _data.tabController.index == 1
                          ? _data.myColors.tabiconactive
                          : _data.myColors.tabiconInctive,
                    ),
                  ),
                  Text(
                    'Bullets',
                    style: TextStyle(
                      fontSize: _textSize,
                      color: _data.tabController.index == 1
                          ? _data.myColors.tabiconactive
                          : _data.myColors.tabiconInctive,
                    ),
                  )
                ],
              )),
              Tab(
                  icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.all(_data.h * 0.008),
                    child: Image.asset(
                      'assets/curly.png',
                      fit: BoxFit.contain,
                      color: _data.tabController.index == 2
                          ? _data.myColors.tabiconactive
                          : _data.myColors.tabiconInctive,
                    ),
                  ),
                  Text(
                    'Code',
                    style: TextStyle(
                      fontSize: _textSize,
                      color: _data.tabController.index == 2
                          ? _data.myColors.tabiconactive
                          : _data.myColors.tabiconInctive,
                    ),
                  )
                ],
              )),
            ],
          ),
        )
       
        );
  }
}