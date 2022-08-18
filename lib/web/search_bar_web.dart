import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/utils/provder.dart';
import 'dart:math' as math;

import '../widgets/close_icon.dart';

class SearchBarWeb extends StatelessWidget {
  const SearchBarWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data _webData = Provider.of<Data>(context);
    String join = _webData.selectedFilters.join(' ');
    double tileW = (_webData.webw / _webData.webh) > 1.5
        ? _webData.webMainW
        : _webData.webw;
    return Container(
      width: tileW,

      height: _webData.webh * 0.04,
      margin: EdgeInsets.all(_webData.webh * 0.01),

      child: Row(
        children: [
          IconButton(
              iconSize: math.min(tileW * 0.06, _webData.webh * 0.04),
              padding: EdgeInsets.zero,
              onPressed: () async {
                _webData.scaffoldKey.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: _webData.myColors.normaltext,
              )),
          Container(
            width: tileW * 0.83,
            child: TextField(
              style: TextStyle(
                  fontSize: _webData.webh * 0.022,
                  //  height: 1.0,
                  color: _webData.myColors.labeltext),
              controller: _webData.searchController,
              cursorColor: _webData.myColors.normaltext!,
              onSubmitted: (d) {
                _webData.getSearchResult();
              },
              decoration: InputDecoration(
                labelText: "Search any topic",
                labelStyle: TextStyle(color: _webData.myColors.normaltext!),
                contentPadding:
                    EdgeInsets.only(left: _webData.webMainW * 0.015),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: _webData.myColors.normaltext!),
                    borderRadius: BorderRadius.circular(_webData.h * 0.02)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: _webData.myColors.normaltext!),
                    borderRadius: BorderRadius.circular(_webData.h * 0.02)),
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: _webData.webh * 0.02,
                  onPressed: () {
                    _webData.searchController.clear();
                    _webData.getSearchResult();

                    _webData.refresh();
                  },
                  icon: FittedBox(
                    child: closeIcon(),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
              iconSize: math.min(tileW * 0.06, _webData.webh * 0.04),
              padding: EdgeInsets.zero,
              onPressed: () {
                _webData.getSearchResult();
              },
              icon: Icon(
                Icons.search,
                color: _webData.myColors.iconcolors,
              )),
        ],
      ),
    );
  }
}
