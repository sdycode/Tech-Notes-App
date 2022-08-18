import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/provder.dart';

class TileSubpartHeading extends StatelessWidget {
  final s;
  final d;
  const TileSubpartHeading(this.s, this.d,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data _data = Provider.of<Data>(context);
    return Container(
      width: d,
      child: Text(
        s,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: _data.webh * 0.015,
          color: Colors.grey,
        ),
      ),
    );
  }
}
