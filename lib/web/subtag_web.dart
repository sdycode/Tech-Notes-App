import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/provder.dart';
import '../widgets/add_icon.dart';
import '../widgets/close_icon.dart';

class SubtagWeb extends StatelessWidget {
  const SubtagWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data _webData = Provider.of<Data>(
      context,
    );
    return Container(
      width: _webData.webSideW * (1 - 0.1),
      height: _webData.webh * 0.08,
      margin: EdgeInsets.all(_webData.webSideW * 0.02),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: _webData.webSideW -
              _webData.webSideW * 0.12 -
              _webData.webSideW * 0.06 -
              _webData.webSideW * 0.12,
          //  height: _webData.h*0.06,

          child: TextField(
            style: TextStyle(color: _webData.myColors.labeltext),
            controller: _webData.subtagController,
            decoration: InputDecoration(
                labelText: 'Subtags',
                labelStyle: TextStyle(color: _webData.myColors.labeltext),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: _webData.myColors.textfieldFocusborder ??
                            _webData.themeData.primaryColor),
                    borderRadius: BorderRadius.circular(_webData.h * 0.02)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: _webData.myColors.textfieldborder ??
                            _webData.themeData.primaryColor),
                    borderRadius: BorderRadius.circular(_webData.h * 0.02)),
                suffixIcon: IconButton(
                  iconSize: _webData.webh * 0.035,
                  onPressed: () {
                    _webData.subtagController.text = '';
                    _webData.refresh();
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
              width: _webData.webSideW * 0.08,
              padding: EdgeInsets.all(_webData.webh * 0.005),
              height: _webData.webh * 0.05,
              child: FittedBox(child: Image.asset('assets/paste1.png'))),
        ),
        InkWell(
          onTap: () {
            bool spacecount = _webData.subtagController.text.characters
                .containsAll(Characters(' '));
            List l = _webData.subtagController.text.split(' ');
            print('space $spacecount');
            if (l.length + 1 < _webData.subtagController.text.length) {
              if (_webData.subtagController.text.isNotEmpty)
                _webData.subtags.add(_webData.subtagController.text);
              _webData.subtagController.text = '';
            }
            _webData.refresh();
          },
          child: Container(
              // color: Colors.purple,
              width: _webData.webSideW * 0.08,
              padding: EdgeInsets.all(_webData.webh * 0.002),
              height: _webData.webh * 0.05,
              child: FittedBox(child: addIcon(_webData.myColors))),
        ),
      ]),
    );
  }
}
