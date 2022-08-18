import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/provder.dart';
import '../widgets/add_icon.dart';
import '../widgets/close_icon.dart';

class SubtagAndoird extends StatelessWidget {
  const SubtagAndoird({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data _androidData = Provider.of<Data>(
      context,
    );
    return Container(
      width: double.infinity,
      height: _androidData.h * 0.06,
      margin: EdgeInsets.all(_androidData.w * 0.02),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          width: _androidData.w -
              _androidData.w * 0.12 -
              _androidData.w * 0.08 -
              _androidData.w * 0.06 -
              _androidData.w * 0.12,
          //  height: _androidData.h*0.06,

          child: TextField(
            style: TextStyle(color: _androidData.myColors.labeltext),
            controller: _androidData.subtagController,
            decoration: InputDecoration(
                labelText: 'Subtags',
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: _androidData.myColors.textfieldFocusborder ??
                            _androidData.themeData.primaryColor),
                    borderRadius: BorderRadius.circular(_androidData.h * 0.02)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: _androidData.myColors.textfieldborder ??
                            _androidData.themeData.primaryColor),
                    borderRadius: BorderRadius.circular(_androidData.h * 0.02)),
                suffixIcon: IconButton(
                  onPressed: () {
                    _androidData.subtagController.text = '';
                    _androidData.refresh();
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
              width: _androidData.w * 0.12,
              padding: EdgeInsets.all(_androidData.h * 0.005),
              height: _androidData.h * 0.05,
              child: FittedBox(child: Image.asset('assets/paste1.png'))),
        ),
        InkWell(
          onTap: () {
            bool spacecount = _androidData.subtagController.text.characters
                .containsAll(Characters(' '));
            List l = _androidData.subtagController.text.split(' ');
            print('space $spacecount');
            if (l.length + 1 < _androidData.subtagController.text.length) {
              if (_androidData.subtagController.text.isNotEmpty)
                _androidData.subtags.add(_androidData.subtagController.text);
              _androidData.subtagController.text = '';
            }
            _androidData.refresh();
          },
          child: Container(
              // color: Colors.purple,
              width: _androidData.w * 0.10,
              padding: EdgeInsets.all(_androidData.h * 0.002),
              height: _androidData.h * 0.05,
              child: FittedBox(child: addIcon(_androidData.myColors))),
        ),
      ]),
    );
  }
}
