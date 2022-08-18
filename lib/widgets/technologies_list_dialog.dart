import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/globals.dart';
import '../utils/provder.dart';

class TechnologiesChipsDialog extends StatelessWidget {
  const TechnologiesChipsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data data = Provider.of<Data>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(data.h * 0.015)),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter dialogState) {
          bool _isKeybordOpen =
              WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                  ? true
                  : false;

          return Container(
            height: data.h * 0.8,
            width: data.w,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: data.mainTagsearchController,
                          cursorColor: chipDarkBlueColor,
                          style: TextStyle(color: chipDarkBlueColor),
                          onChanged: (d) {
                            dialogState(
                              () {
                                data.modifyFilteredMaintagList(d);
                              },
                            );
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              labelStyle: TextStyle(
                                  decorationColor:
                                      data.myColors.textfieldborder ??
                                          data.themeData.primaryColor),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: data.myColors.textfieldborder ??
                                          data.themeData.primaryColor),
                                  borderRadius:
                                      BorderRadius.circular(data.h * 0.02)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: data.myColors.textfieldborder ??
                                          data.themeData.primaryColor),
                                  borderRadius:
                                      BorderRadius.circular(data.h * 0.02)),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    dialogState(() {
                                      data.mainTagsearchController.clear();
                                      data.modifyFilteredMaintagList('');
                                    });
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ))),
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.pop(context);
                        data.refresh();
                      },
                      elevation: 2.0,
                      fillColor: Colors.grey.shade200,
                      child: Icon(
                        Icons.close,
                        size: 16.0,
                      ),
                      padding: EdgeInsets.all(6.0),
                      shape: CircleBorder(),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          ...data.filteredTechnologiesList.entries.map((e) {
                            // int i = _technologiesList.indexOf(e);
                            int i = e.key;
                            double _sidePadding =
                                kIsWeb ? data.webSideW * 0.015 : data.w * 0.015;
                            bool _isSelected =
                                data.maintags.contains(e.value.trim());
                            return Container(
                              margin: EdgeInsets.fromLTRB(_sidePadding,
                                  _sidePadding, _sidePadding, _sidePadding),
                              child: RawChip(
                                  showCheckmark: false,
                                  selected: _isSelected,
                                  selectedColor: chipDarkBlueColor,
                                  backgroundColor: chipLightBlueColor,
                                  onPressed: () {
                                    if (data.maintags.contains(e.value.trim())) {
                                      data.maintags.remove(e.value.trim());
                                    } else {
                                      data.maintags.add(e.value.trim());
                                    }
                                    dialogState(() {});
                                  },
                                  // onSelected: (d) {
                                  //   dialogState(() {
                                  //     if (d) {}
                                  //   });
                                  // },
                                  label: Text(
                                    e.value,
                                    style: TextStyle(
                                        color: _isSelected
                                            ? chipLightBlueColor
                                            : chipDarkBlueColor,
                                        fontSize: data.h * 0.015),
                                  )),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(),
                Container(
                  height: data.h * 0.2,
                  width: data.w,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      children: [
                        ...data.maintags.map((e) {
                          double _sidePadding =
                              kIsWeb ? data.webSideW * 0.015 : data.w * 0.015;
                          return Container(
                              margin: EdgeInsets.fromLTRB(_sidePadding,
                                  _sidePadding, _sidePadding, _sidePadding),
                              child: Chip(
                                backgroundColor:
                                    chipDarkBlueColor.withAlpha(240),
                                label: Text(
                                  e,
                                  style: TextStyle(
                                      color: chipLightBlueColor,
                                      fontSize: data.h * 0.015),
                                ),
                                onDeleted: () {},
                                deleteIcon: CircleAvatar(
                                  backgroundColor: chipLightBlueColor,
                                  child: Center(
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          dialogState(() {
                                            data.maintags.remove(e);
                                          });
                                        },
                                        iconSize: 18,
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ));
                        })
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
