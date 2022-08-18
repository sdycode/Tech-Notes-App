import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../utils/provder.dart';
import '../widgets/close_icon.dart';

class TitleAndroid extends StatelessWidget {
  const TitleAndroid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     Data _androidData = Provider.of<Data>(context, listen: true);
    return Container(
            width: double.infinity,
            // height: _androidData.h * 0.06,
            margin: EdgeInsets.all(_androidData.w * 0.02),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _androidData.w - _androidData.w * 0.12 - _androidData.w * 0.08 - _androidData.w * 0.06,
                    //  height: _androidData.h*0.06,

                    child: TextField(
                      style: TextStyle(color: _androidData.myColors.labeltext),
                      controller: _androidData.titleController,
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
                              borderRadius: BorderRadius.circular(_androidData.h * 0.02)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: C.titleColor.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(_androidData.h * 0.02)),
                          suffixIcon: IconButton(
                            onPressed: () {
                       
                                _androidData.titleController.clear();
                          
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
                        child:
                            FittedBox(child: Image.asset('assets/paste1.png'))),
                  ),
                ]),
          );
  }
}
