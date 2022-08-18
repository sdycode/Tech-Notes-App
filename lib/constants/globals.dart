import 'package:flutter/material.dart';

import '../utils/theme.dart';

Color chipDarkBlueColor = Color.fromARGB(255, 17, 9, 69);
Color chipLightBlueColor = Color.fromARGB(255, 211, 224, 239);

isDarkTheme() {
    return CustomTheme().currentTheme == ThemeMode.dark;
  }