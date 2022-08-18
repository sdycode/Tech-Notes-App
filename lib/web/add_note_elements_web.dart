

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/web/maintags_chips.dart';
import 'package:stick_box/web/subtag_web.dart';
import 'package:stick_box/web/tabs_web.dart';
import 'package:stick_box/web/title_web.dart';
import 'package:stick_box/widgets/select_text_button.dart';
import 'package:stick_box/widgets/subtagsrow.dart';
import 'package:stick_box/widgets/tabrow.dart';

import '../utils/provder.dart';

class AddNoteElementsWeb extends StatefulWidget {
  AddNoteElementsWeb({Key? key}) : super(key: key);

  @override
  State<AddNoteElementsWeb> createState() => _AddNoteElementsWebState();
}

class _AddNoteElementsWebState extends State<AddNoteElementsWeb> {
    late Data _webData;
  @override
  Widget build(BuildContext context) {
    _webData = Provider.of<Data>(context, listen: true);
    return Column(
      children: [
        Container(
          height:  _webData.h * 0.01 ,
          color: Colors.transparent,
        ),
        Container(
          width: _webData.w,
         
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SelectTechButton(),
              _webData.maintags.isNotEmpty
                  ? Expanded(child: MainTagsChipsWeb())
                  : Container(),
            ],
          ),
        ),

     
        TitleWeb(),
      
        SubtagWeb(),
        SubtagsRow(),
        TabRow(),
        SizedBox(
          height: _webData.h * 0.005,
        ),
        TabsWeb()

       
      ],
    );
  }
}