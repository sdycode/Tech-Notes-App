import 'package:flutter/src/material/app.dart';
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

  static bool isDarkTheme() {
    return pref.getBool('theme') ?? false;
  }

  static void setAppThememode(ThemeMode currentTheme) {
    pref.setBool('theme', currentTheme == ThemeMode.dark ? true : false);
  }

  static ThemeMode getCurrthemefromSharedPref() {
    return isDarkTheme() ? ThemeMode.dark : ThemeMode.light;
  }

  static void setLoginStatus(bool bool) {
          pref.setBool('isLogin', bool);

  }
  static bool isLogin(){
    return  pref.getBool('isLogin') ?? false;
  } 
}
