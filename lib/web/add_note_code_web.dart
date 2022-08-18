import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/utils/provder.dart';
import 'package:stick_box/web/add_note_elements_web.dart';

class AddCoodeNoteWeb extends StatefulWidget {
  const AddCoodeNoteWeb({Key? key}) : super(key: key);

  @override
  State<AddCoodeNoteWeb> createState() => _AddCoodeNoteWebState();
}

class _AddCoodeNoteWebState extends State<AddCoodeNoteWeb> {
  late Data _data;
  @override
  Widget build(BuildContext context) {
  _data = Provider.of(context);
  return Container(
      width: _data.webw * 0.45,
      height: _data.webh,
      color:
          // Colors.red,
          _data.myColors.addfullnoteboxbg,
      child:
      
      
       Container(
        height: _data.webh * 0.8,
        width: _data.webw,
        margin: EdgeInsets.all(_data.webw * 0.01),

        // margin: EdgeInsets.only(top: h * 0.1, left: w*0.08),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(_data.webh * 0.02),
            // topLeft: Radius.circular(w * 0.08),
            // topRight: Radius.circular(w * 0.08),
          ),
          color:
              // Colors.red,
              _data.myColors.addfullnoteboxbg,
        ),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Container(
              // color: Colors.red,
              height:  _data.webh * 0.90 ,
            ),
            Container(
              height: _data.webh * 0.84 ,
      
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(_data.w * 0.08 * 0)),
                child: SingleChildScrollView(
                  
                  child: AddNoteElementsWeb()
                  ),
              ),
            ),
            // bottomButtons(),
            Align(
              alignment: Alignment.bottomCenter,
              child: MediaQuery.of(context).viewInsets.bottom < 1
                  ? 
                  Container()
                  // bottomButtons()
                  : Container(),
            )
          ],
        ))
      
      );
    
  }
}