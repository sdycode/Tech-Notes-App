import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static late SharedPreferences pref;
  static Future init() async {
    pref = await SharedPreferences.getInstance();
  }

  static bool isAdmin = pref.getBool('admin') ?? false;
  static setAdmin(bool b) {
    pref.setBool('admin', b);
  }

  static bool getAdminStat() {
    return pref.getBool('admin') ?? false;
  }
}
