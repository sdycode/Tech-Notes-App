

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../utils/provder.dart';
import '../widgets/close_icon.dart';
class NoteTabWeb extends StatefulWidget {
  NoteTabWeb({Key? key}) : super(key: key);

  @override
  State<NoteTabWeb> createState() => _NoteTabWebState();
}

class _NoteTabWebState extends State<NoteTabWeb> {
  @override
  Widget build(BuildContext context) {
    Data _data = Provider.of<Data>(context);
    return Container(
        height: _data.subtags.isEmpty ? _data.h * 0.42 : _data.h * 0.38,
        width: _data.w,
        margin: EdgeInsets.all(_data.webSideW * 0.02),
        // color: Colors.green.shade100,
        child: Column(
          children: [
            Scrollbar(
              // controller: notescrollController,
              // isAlwaysShown: true,
              child: TextField(
                style: TextStyle(color: _data.myColors.labeltext),
                controller: _data.noteController,
                keyboardType: TextInputType.multiline,
                maxLines: _data.subtags.isEmpty
                    ? (_data.h * 0.44 ~/ (_data.h * 0.025)).toInt()
                    : (_data.h * 0.38 ~/ (_data.h * 0.025)).toInt(),
                minLines: 1,
                expands: false,
                cursorColor: _data.myColors.labeltext,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: _data.myColors.labeltext),
                    labelText: 'Note',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: _data.myColors.textfieldFocusborder ??
                                _data.themeData.primaryColor),
                        borderRadius: BorderRadius.circular(_data.h * 0.02)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: _data.myColors.textfieldborder ??
                                _data.themeData.primaryColor),
                        borderRadius: BorderRadius.circular(_data.h * 0.02)),
                    suffixIcon: Column(
                      children: [
                        IconButton(
                          iconSize: kIsWeb ? _data.webh * 0.03 : _data.w * 0.06,
                          onPressed: () {
                            _data.noteController.clear();
                            _data.refresh();
                          },
                          icon: FittedBox(
                            child: closeIcon(),
                          ),
                        ),

                        //  addwithpaste
                        IconButton(
                            iconSize:
                                kIsWeb ? _data.webh * 0.03 : _data.w * 0.06,
                            onPressed: () async {
                              ClipboardData? cdata =
                                  await Clipboard.getData(Clipboard.kTextPlain);
                              _data.noteController.clear();

                              _data.noteController.text = cdata!.text!;
                              _data.refresh();
                            },
                            icon: Icon(
                              Icons.paste,
                              color: _data.myColors.pasteicon,
                            )),

                        IconButton(
                          iconSize: kIsWeb ? _data.webh * 0.03 : _data.w * 0.06,
                          onPressed: () async {
                            ClipboardData? cdata =
                                await Clipboard.getData(Clipboard.kTextPlain);
                            _data.noteController.text += cdata!.text!;
                            _data.refresh();
                          },
                          icon: Image.asset(
                            'assets/addwithpaste2.png',
                            width: _data.w * 0.06,
                            color: _data.myColors.addpasteicon,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ));
  }
}