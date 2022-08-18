 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/provder.dart';

Widget closeIcon() {
    return Builder(
      builder: (context) {
            Data data = Provider.of<Data>(context);
        return Icon(
          Icons.close,
          color: data.myColors.closeicon,
        );
      }
    );
  }