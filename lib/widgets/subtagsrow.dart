

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/widgets/subtag_chip.dart';

import '../utils/provder.dart';

class SubtagsRow extends StatefulWidget {
  SubtagsRow({Key? key}) : super(key: key);

  @override
  State<SubtagsRow> createState() => _SubtagsRowState();
}

class _SubtagsRowState extends State<SubtagsRow> {
  @override
  Widget build(BuildContext context) {
    Data    _data = Provider.of<Data>(context, listen: true);
    return _data.subtags.isNotEmpty
        ? Container(
            margin: kIsWeb
                ? EdgeInsets.only(left: _data.webSideW * 0.02, right: _data.webSideW * 0.02)
                : EdgeInsets.only(left: _data.w * 0.02, right: _data.w * 0.02),
            height: _data.h * 0.05,
            width: double.infinity,
            child: ListView.builder(
                itemCount: _data.subtags.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) {
                  return SubtagChip(i);
                }))
        : Container();
  }
}