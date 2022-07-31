import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// CustomTheme customTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    print('theme $_isDarkTheme');
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      extensions: <ThemeExtension<dynamic>>[
        const MyColors(
          brandColor: Color.fromARGB(255, 234, 238, 242),
          danger: Color.fromARGB(255, 236, 168, 167),
          iconcolors: Color.fromARGB(255, 9, 15, 21),
          tabiconactive: Color.fromARGB(255, 30, 3, 64),
          tabiconInctive: Color.fromARGB(255, 60, 61, 133),
          closeicon: Color.fromARGB(255, 122, 18, 0),
          pasteicon: Color.fromARGB(255, 4, 137, 24),
          addpasteicon: Color.fromARGB(255, 49, 19, 131),
          labeltext: Color.fromARGB(255, 50, 7, 7),
          textfieldborder: Color.fromARGB(255, 224, 148, 129),
          textfieldFocusborder: Color.fromARGB(255, 120, 35, 14),
          tabbutton: Color.fromARGB(255, 239, 235, 168),
          tabbuttonActive: Color.fromARGB(255, 236, 228, 84),
          normaltext: Color.fromARGB(255, 34, 18, 7),
          fainttext: Color.fromARGB(255, 154, 151, 151),
          deleteicon: Color.fromARGB(255, 226, 3, 3),
          editicon: Color.fromARGB(255, 9, 64, 147),
          expansionboxbg: Color.fromARGB(255, 233, 231, 177),
          addfullnoteboxbg: Color.fromARGB(255, 246, 246, 233),
        ),
      ],
      primaryColor: Color.fromARGB(255, 14, 18, 60),
      accentColor: Colors.white,
      backgroundColor: Colors.white,
      cardColor: Color.fromARGB(255, 231, 226, 188),
      scaffoldBackgroundColor: Colors.white,
       appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 246, 226, 169)
      ),
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.black),
        headline2: TextStyle(color: Color.fromARGB(255, 72, 7, 7)),
        bodyText1: TextStyle(color: Color.fromARGB(255, 2, 16, 74)),
        bodyText2: TextStyle(color: Color.fromARGB(255, 4, 60, 40)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      extensions: <ThemeExtension<dynamic>>[
        const MyColors(
          brandColor: Color.fromARGB(255, 36, 111, 60),
          danger: Color.fromARGB(255, 146, 11, 8),
          iconcolors: Color.fromARGB(255, 236, 239, 242),
          tabiconactive: Color.fromARGB(255, 216, 202, 233),
          tabiconInctive: Color.fromARGB(255, 196, 150, 210),
          closeicon: Color.fromARGB(255, 199, 201, 204),
          pasteicon: Color.fromARGB(255, 187, 242, 195),
          addpasteicon: Color.fromARGB(255, 243, 242, 187),
          labeltext: Color.fromARGB(255, 252, 196, 159),
          textfieldborder: Color.fromARGB(255, 113, 68, 57),
          textfieldFocusborder: Color.fromARGB(255, 252, 187, 171),
          tabbutton: Color.fromARGB(255, 85, 73, 73),
          tabbuttonActive: Color.fromARGB(255, 132, 81, 81),
          normaltext: Color.fromARGB(255, 243, 237, 234),
          fainttext: Color.fromARGB(255, 154, 151, 151),
          deleteicon: Color.fromARGB(255, 226, 77, 77),
          editicon: Color.fromARGB(255, 141, 188, 234),
          expansionboxbg: Color.fromARGB(255, 12, 17, 21),
          addfullnoteboxbg: Color.fromARGB(255, 30, 36, 42),
        ),
      ],
      primaryColor: Color.fromARGB(255, 241, 198, 198),
      accentColor: Color.fromARGB(255, 3, 3, 3),
      backgroundColor: Color.fromARGB(255, 22, 13, 13),
      scaffoldBackgroundColor: Color.fromARGB(255, 16, 12, 12),
         cardColor: Color.fromARGB(255, 50, 44, 39),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 49, 27, 19)
      ),
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.white),
        headline2: TextStyle(color: Color.fromARGB(255, 226, 189, 189)),
        bodyText1: TextStyle(color: Color.fromARGB(255, 180, 222, 238)),
        bodyText2: TextStyle(color: Color.fromARGB(255, 194, 241, 207)),
      ),
    );
  }
}

@immutable
class MyColors extends ThemeExtension<MyColors> {
  const MyColors(
      {this.brandColor,
      this.danger,
      this.iconcolors,
      this.tabiconactive,
      this.tabiconInctive,
      this.closeicon,
      this.pasteicon,
      this.addpasteicon,
      this.labeltext,
      this.textfieldborder,
      this.textfieldFocusborder,
      this.tabbutton,
      this.tabbuttonActive,
      this.normaltext,
      this.fainttext,
      this.deleteicon,
      this.editicon,
      this.expansionboxbg,
      this.addfullnoteboxbg});

  final Color? danger;
  final Color? brandColor;
  final Color? iconcolors;
  final Color? tabiconactive;
  final Color? tabiconInctive;
  final Color? closeicon;
  final Color? pasteicon;
  final Color? addpasteicon;
  final Color? labeltext;
  final Color? textfieldborder;
  final Color? textfieldFocusborder;
  final Color? tabbutton;
  final Color? tabbuttonActive;
  final Color? normaltext;
  final Color? fainttext;
  final Color? deleteicon;
  final Color? editicon;
  final Color? expansionboxbg;
  final Color? addfullnoteboxbg;

  @override
  MyColors copyWith({Color? brandColor, Color? danger}) {
    return MyColors(
      // brandColor: brandColor ?? this.brandColor,
      // danger: danger ?? this.danger,

      danger: danger ?? this.danger,
      brandColor: brandColor ?? this.brandColor,
      iconcolors: iconcolors ?? this.iconcolors,
      tabiconactive: tabiconactive ?? this.tabiconactive,
      tabiconInctive: tabiconInctive ?? this.tabiconInctive,
      closeicon: closeicon ?? this.closeicon,
      pasteicon: pasteicon ?? this.pasteicon,
      addpasteicon: addpasteicon ?? this.addpasteicon,
      labeltext: labeltext ?? this.labeltext,
      textfieldborder: textfieldborder ?? this.textfieldborder,
      textfieldFocusborder: textfieldFocusborder ?? this.textfieldFocusborder,
      tabbutton: tabbutton ?? this.tabbutton,
      tabbuttonActive: tabbuttonActive ?? this.tabbuttonActive,
      normaltext: normaltext ?? this.normaltext,
      fainttext: fainttext ?? this.fainttext,
      deleteicon: deleteicon ?? this.deleteicon,
      editicon: editicon ?? this.editicon,
      expansionboxbg: expansionboxbg ?? this.expansionboxbg,
      addfullnoteboxbg: addfullnoteboxbg ?? this.addfullnoteboxbg,
    );
  }

  @override
  MyColors lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) {
      return this;
    }
    return MyColors(
      // brandColor: Color.lerp(brandColor, other.brandColor, t),
      // danger: Color.lerp(danger, other.danger, t),
      danger: Color.lerp(danger, other.danger, t),
      brandColor: Color.lerp(brandColor, other.brandColor, t),
      iconcolors: Color.lerp(iconcolors, other.iconcolors, t),
      tabiconactive: Color.lerp(tabiconactive, other.tabiconactive, t),
      tabiconInctive: Color.lerp(tabiconInctive, other.tabiconInctive, t),
      closeicon: Color.lerp(closeicon, other.closeicon, t),
      pasteicon: Color.lerp(pasteicon, other.pasteicon, t),
      addpasteicon: Color.lerp(addpasteicon, other.addpasteicon, t),
      labeltext: Color.lerp(labeltext, other.labeltext, t),
      textfieldborder: Color.lerp(textfieldborder, other.textfieldborder, t),
      textfieldFocusborder:
          Color.lerp(textfieldFocusborder, other.textfieldFocusborder, t),
      tabbutton: Color.lerp(tabbutton, other.tabbutton, t),
      tabbuttonActive: Color.lerp(tabbuttonActive, other.tabbuttonActive, t),
      normaltext: Color.lerp(normaltext, other.normaltext, t),
      fainttext: Color.lerp(fainttext, other.fainttext, t),
      deleteicon: Color.lerp(deleteicon, other.deleteicon, t),
      editicon: Color.lerp(editicon, other.editicon, t),
      expansionboxbg: Color.lerp(expansionboxbg, other.expansionboxbg, t),
      addfullnoteboxbg: Color.lerp(addfullnoteboxbg, other.addfullnoteboxbg, t),
    );
  }

  // // Optional
  // @override
  // String toString() => 'MyColors(brandColor: $brandColor, danger: $danger)';
}
/*

List of colors to use
iconcolors
tabiconactive
tabiconInctive
closeicon
pasteicon
addpasteicon
labeltext
textfieldborder
tabbutton
normaltext
fainttext
deleteicon
editicon
expansionboxbg
addfullnoteboxbg



*/
/*



                             "danger",
                             "brandColor",
                             "iconcolors",
                             "tabiconactive",
                             "tabiconInctive",
                             "closeicon",
                             "pasteicon",
                             "addpasteicon",
                             "labeltext",
                             "textfieldborder",
                             "textfieldFocusborder",
                             "tabbutton",
                             "tabbuttonActive",
                             "normaltext",
                             "fainttext",
                             "deleteicon",
                             "editicon",
                             "expansionboxbg",
                             "addfullnoteboxbg",
*/
