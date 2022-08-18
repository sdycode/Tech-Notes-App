import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/provder.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/web/search_bar_web.dart';

import '../utils/provder.dart';
import '../utils/theme.dart';

class SearchFilterWeb extends StatefulWidget {
  SearchFilterWeb({Key? key}) : super(key: key);

  @override
  State<SearchFilterWeb> createState() => _SearchFilterWebState();
}

class _SearchFilterWebState extends State<SearchFilterWeb> {
  @override
  Widget build(BuildContext context) {
    Data _data = Provider.of<Data>(context);
    return Container(
        width: (_data.webw / _data.webh) > 1.5 ? _data.webMainW : _data.webw,
        height: _data.webh * 0.09,
        // color: Colors.pink,
        child: Scrollbar(
          controller: _data.filterScrollController,
          child: ListView.builder(
              controller: _data.filterScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _data.filters.length,
              itemBuilder: (c, i) {
                return FilterTabWeb(i);
              }),
        ));
  }
}

class FilterTabWeb extends StatefulWidget {
  int i;
  FilterTabWeb(this.i, {Key? key}) : super(key: key);

  @override
  State<FilterTabWeb> createState() => _FilterTabWebState(i);
}

class _FilterTabWebState extends State<FilterTabWeb> {
  int i;
  _FilterTabWebState(this.i);
  @override
  Widget build(BuildContext context) {
    Data _data = Provider.of<Data>(context);
    bool _isTagMarked = _data.selectedFilters.contains(_data.filters[i]);
    return Transform.scale(
      scale: _isTagMarked ? 1.05 : 1,
      child: InkWell(
        onTap: () {
          if (_data.filters[i] == 'All') {
            _data.selectedFilters.clear();
            _data.selectedFilters.add(_data.filters[i]);

            _data.getSearchResult();
            // if ( !kIsWeb) {
            //   modifyNotesListToShowOnlyUserNotes();
            // }
          } else {
            _data.selectedFilters.remove('All');
            if (!_data.selectedFilters.contains(_data.filters[i])) {
              _data.selectedFilters.add(_data.filters[i]);
            } else {
              _data.selectedFilters.remove(_data.filters[i]);
            }
            if (_data.selectedFilters.isEmpty) {
              _data.noteslist = List.from(_data.fullNoteslist);

              _data.selectedFilters.add('All');
            }
            _data.getSearchResult();
          }

          _data.refresh();
        },
        child: Container(
          margin: kIsWeb
              ? EdgeInsets.only(
                  bottom: _data.webh * 0.03,
                  left: _data.webMainW * 0.012 * 1,
                  top: _data.webh * 0.008,
                )
              : EdgeInsets.only(
                  // bottom: _data.h * 0.03,
                  left: _data.w * 0.012,
                  // top: _data.h * 0.008,
                ),
          child: Container(
              // height: kIsWeb? _data.webh * 0.06:_data.h* 0.03,
              // height: double.minPositive,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: _isTagMarked
                      ? _data.myColors.tabbuttonActive
                      : _data.myColors.tabbutton,
                  borderRadius: kIsWeb
                      ? BorderRadius.circular(_data.webh * 0.05)
                      : BorderRadius.circular(_data.h * 0.03),
                  boxShadow: !_isTagMarked
                      ? []
                      : [
                          BoxShadow(
                              color: _data.myColors.normaltext!,
                              offset: Offset(0.3, 0.3),
                              spreadRadius: 0.4,
                              blurRadius: 1)
                        ]
                  // border: isTagMarked ? Border.all() : null
                  ),
              margin: kIsWeb
                  ? EdgeInsets.all(_data.webh * 0.002)
                  : EdgeInsets.all(_data.h * 0.008),
              padding: kIsWeb
                  ? EdgeInsets.only(
                      left: _data.webw * 0.02,
                      right: _data.webw * 0.02,
                      top: _data.webh * 0.005,
                      bottom: _data.webh * 0.005)
                  : EdgeInsets.only(
                      left: _data.w * 0.03,
                      right: _data.w * 0.03,
                      top: _data.h * 0.001,
                      bottom: _data.h * 0.001),
              child: Text(
                _data.filters[i],
                style: TextStyle(
                    fontSize: _isTagMarked ? _data.h * 0.02 : _data.h * 0.015,
                    color: _isTagMarked
                        ? _data.myColors.normaltext
                        : _data.myColors.normaltext),
              )),
        ),
      ),
    );
  }
}
