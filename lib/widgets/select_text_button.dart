

 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/widgets/technologies_list_dialog.dart';

import '../constants/globals.dart';
import '../utils/provder.dart';



class SelectTechButton extends StatelessWidget {
  const SelectTechButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { Data data = Provider.of<Data>(context);
    return Padding(
          padding: EdgeInsets.all(data.h * 0.01),
          child: RawChip(
            label: Text(
             
              'Select Technology',
              style: TextStyle(color: chipLightBlueColor),
            ),
            backgroundColor: chipDarkBlueColor,
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => TechnologiesChipsDialog());
            },
          ),
        );
  }
}

