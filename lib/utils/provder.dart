import 'package:flutter/foundation.dart';

class Data with ChangeNotifier {
  refresh() {
    notifyListeners();
  }
}
