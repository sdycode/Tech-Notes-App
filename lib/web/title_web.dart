import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/provder.dart';
import '../widgets/close_icon.dart';

class TitleWeb extends StatelessWidget {
  const TitleWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     Data _webData = Provider.of<Data>(context, listen: true);
    return Container(
      width: _webData.webSideW * (1 - 0.05),
      margin: EdgeInsets.only(left: _webData.webSideW * 0.02, right: _webData.webSideW * 0.02),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: _webData.webSideW -
                  _webData.webSideW * 0.08 -
                  _webData.webSideW * 0.08 -
                  _webData.webSideW * 0.02 -
                  _webData.webSideW * 0.05,
              child: TextField(
                controller: _webData.titleController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                minLines: 1,
                expands: false,
                cursorColor: _webData.myColors.labeltext,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: _webData.myColors.labeltext),
                    labelText: 'Title',
                    contentPadding: EdgeInsets.only(left: _webData.webSideW * 0.02),
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
                       
                          _webData.titleController.clear();
                      
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
                  width: _webData.webSideW * 0.08,
                  padding: EdgeInsets.all(_webData.webh * 0.005),
                  height:_webData. webh * 0.05,
                  child: FittedBox(
                      child: Image.asset(
                    'assets/paste1.png',
                  ))),
            ),
          ]),
    );
  }
}
