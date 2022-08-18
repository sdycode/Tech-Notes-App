import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/widgets/close_icon.dart';

import '../utils/provder.dart';

class SubtagChip extends StatelessWidget {
  int i;
   SubtagChip(this.i,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data _data = Provider.of<Data>(context, listen: true);
    return Container(
        decoration: BoxDecoration(
          color: _data.myColors.brandColor,
          borderRadius: BorderRadius.circular(_data.h * 0.05),
          // border: Border.all()
        ),
        margin: EdgeInsets.all(_data.h * 0.006),
        padding: EdgeInsets.only(
          left: _data.w * 0.02,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FittedBox(
              child: Text(_data.subtags[i]),
            ),
            Transform.scale(
              scale: 1.15,
              child: InkWell(
                onTap: () {
                  _data.subtags.removeAt(i);
                  _data.refresh();
                },
                child: Padding(
                  padding: EdgeInsets.only(left: _data.w * 0.02),
                  child: FittedBox(
                      child: CircleAvatar(
                    backgroundColor: _data.myColors.brandColor!.withGreen(180),
                    child: closeIcon(),
                  )),
                ),
              ),
            )
          ],
        ));
  }
}
