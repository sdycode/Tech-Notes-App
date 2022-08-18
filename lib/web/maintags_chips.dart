import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/globals.dart';
import '../utils/provder.dart';

class MainTagsChipsWeb extends StatelessWidget {
  const MainTagsChipsWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data _webdata = Provider.of<Data>(context);
    return Container(
      width: double.infinity,
      height: _webdata.h * 0.06,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _webdata.maintags.length,
          itemBuilder: (c, i) {
            return Padding(
              padding: EdgeInsets.all(_webdata.h * 0.01),
              child: Chip(
                label: Text(_webdata.maintags[i]),
                backgroundColor: chipLightBlueColor,
                labelStyle: TextStyle(fontSize: 13),
              ),
            );
          }),
    );
  }
}
