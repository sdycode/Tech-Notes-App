import 'dart:io';
import 'dart:math';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stick_box/constants/constants.dart';
import 'package:stick_box/main.dart';
import 'package:stick_box/constants/sizes.dart';
import 'package:stick_box/screens/login_screen.dart';

// import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/provder.dart';
import '../utils/shared.dart';

// import '../constants/colors.dart';
// import '../constants/constants.dart';
// import '../constants/sizes.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late PackageInfo packageInfo;
  double w = Sizes().sw;
  double h = Sizes().sh;
  double iconH = 0.045;
  double webiconW = Sizes().sw * 0.045;
  double webFont = Sizes().sw * 0.02;
  double minVerticalPadding = Sizes().sh * 0.024;
  String passs = '';
  late Data pdata;
  User? _user;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pdata = Provider.of<Data>(context);
    print('firebsss ${FirebaseAuth.instance}');
    // if (!kIsWeb) {

    //      print( 'user     ------appdd ${_user?.providerData[0].email} //  ${_user?.displayName} and ${_user?.email}');
    //   StreamBuilder<User?>(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //       if (snapshot.hasData) {
    //         _user = snapshot.data as User;
    //         print( 'user appdd ${_user?.providerData[0].email} //  ${_user?.displayName} and ${_user?.email}');
    //         return Container();
    //       } else {
    //         print(
    //             'user appdd   null  ${_user?.providerData[0].email} //  ${_user?.displayName} and ${_user?.email}');
    //         return Container();
    //       }
    //     },
    //   );
    // }
    return kIsWeb ? webBar() : androidBar();
  }

  webBar() {
    return SafeArea(
      child: Container(
        width: max(Sizes().sw * 0.3, 200),
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Colors.transparent,
          // image: DecorationImage(
          //     image: AssetImage('assets/drbg1.jpg'), fit: BoxFit.cover),
        ),
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top * 2,
            bottom: MediaQuery.of(context).viewPadding.top * 2),
        // color: Colors.red,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Drawer(
            // backgroundColor: Colors.white,
            child: Container(
              // color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.transparent,
                // image: DecorationImage(
                //     image: AssetImage('assets/bg1.jpg'), fit: BoxFit.cover),
              ),
              child: ListView(
                children: [
                  SizedBox(
                    height: Sizes().sh * 0.06,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      pdata.refresh();
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Icon(
                        Icons.refresh,
                        size: webiconW * 0.8,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Refresh',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // launch(C.appsharelink);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/starr.png',
                        width: webiconW,
                      ),
                      title: Text(
                        'Rate Us',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      customTheme.toggleTheme();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/theme.png',
                        width: webiconW,
                      ),
                      title: Text(
                        customTheme.currentTheme == ThemeMode.dark
                            ? 'Light'
                            : 'Dark',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(C.playstorelink);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/playstore.png',
                        width: webiconW,
                      ),
                      title: Text(
                        'More Apps',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(C.linkedinlink);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/linkedin.png',
                        width: webiconW,
                      ),
                      title: Text(
                        'Linked In',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(C.youtubevideolink);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/youtube.png',
                        width: webiconW,
                      ),
                      title: Text(
                        'YouTube',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch("https://github.com/sdycode");
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/git.png',
                        width: webiconW,
                      ),
                      title: Text(
                        'Github',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Share.share(C.appsharelink);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/share.png',
                        color: Colors.deepPurple,
                        width: webiconW,
                      ),
                      title: Text(
                        'Share',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController pass =
                                  TextEditingController();
                              bool isPass = false;

                              return Dialog(
                                child: Container(
                                  width: w * 0.4,
                                  height: h * 0.6,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: h * 0.15,
                                        width: w * 0.36,
                                        child: TextField(
                                          controller: pass,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (isPass) {
                                            Shared.setAdmin(true);
                                            print(
                                                'isadmin after set ${Shared.isAdmin}');
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Container(
                                          width: w * 0.4,
                                          height: h * 0.15,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            if (pass.text == 'shu22396') {
                                              setState(() {
                                                isPass = true;
                                                passs = pass.text;
                                              });
                                            } else {
                                              Shared.setAdmin(false);
                                              print(
                                                  'isadmin after ${Shared.isAdmin}');
                                              pass.clear();
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text('Go')),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: ListTile(
                        minVerticalPadding: minVerticalPadding,
                        leading: Image.asset(
                          'assets/man1.webp',
                          // 'assets/man1.webp',
                          width: webiconW,
                        ),
                        title: Text(
                          'Admin',
                          style:
                              TextStyle(color: Colors.black, fontSize: webFont),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  androidBar() {
    // FirebaseAuth.instance.currentUser;
    minVerticalPadding = Sizes().sh * 0.014;
    iconH = 0.045;
    webiconW = Sizes().sw * 0.09;
    webFont = Sizes().sw * 0.05;
    return SafeArea(
      child: Container(
        width: Sizes().sw * 0.65,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Colors.transparent,
          // image: DecorationImage(
          //     image: AssetImage('assets/drbg1.jpg'), fit: BoxFit.cover),
        ),
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top * 1,
            bottom: MediaQuery.of(context).viewPadding.top * 1),
        // color: Colors.red,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Drawer(
            // backgroundColor: Colors.white,
            child: Container(
              // color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.transparent,
                // image: DecorationImage(
                //     image: AssetImage('assets/bg1.jpg'), fit: BoxFit.cover),
              ),
              child: ListView(
                children: [
                  SizedBox(
                    height: h * 0.03,
                  ),
                  if (kDebugMode)
                    Container(
                      child: FutureBuilder(
                          future: _initPackageInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              packageInfo = snapshot.data as PackageInfo;
                              return Container(
                                  child: Text(
                                      '${packageInfo.buildNumber} - ${packageInfo.version}'));
                            } else {
                              return Container();
                            }
                          }),
                    ),
              FirebaseAuth.instance.currentUser == null ? Container():     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: w*0.28,
                        width: w*0.28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            
                            scale: 0.7,
                            image: NetworkImage(FirebaseAuth
                            .instance.currentUser!.providerData[0].photoURL!))
                        ),
                        
                      )
                     
                      ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        FirebaseAuth.instance.currentUser == null
                            ? ''
                            : FirebaseAuth
                                .instance.currentUser!.providerData[0].email
                                .toString(),
                        style: TextStyle(
                            fontSize: w * 0.05,
                            color: Color.fromARGB(255, 19, 4, 75),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      pdata.refresh();
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Icon(
                        Icons.refresh,
                        size: webiconW,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Refresh',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      launch(C.appsharelink);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/starr.png',
                        width: webiconW,
                      ),
                      title: Text(
                        'Rate Us',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      customTheme.toggleTheme();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/theme.png',
                        width: webiconW,
                      ),
                      title: Text(
                        customTheme.currentTheme == ThemeMode.dark
                            ? 'Light'
                            : 'Dark',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(C.playstorelink);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/playstore.png',
                        width: webiconW,
                      ),
                      title: Text(
                        'More Apps',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(C.linkedinlink);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/linkedin.png',
                        width: webiconW,
                      ),
                      title: Text(
                        'Linked In',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(C.youtubevideolink);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/youtube.png',
                        width: webiconW,
                      ),
                      title: Text(
                        'YouTube',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch("https://github.com/sdycode");
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/git.png',
                        width: webiconW,
                      ),
                      title: Text(
                        'Github',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Share.share(C.appsharelink);
                    },
                    child: ListTile(
                      minVerticalPadding: minVerticalPadding,
                      leading: Image.asset(
                        'assets/share.png',
                        color: Colors.deepPurple,
                        width: webiconW,
                      ),
                      title: Text(
                        'Share',
                        style:
                            TextStyle(color: Colors.black, fontSize: webFont),
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey,), 
                  FirebaseAuth.instance.currentUser != null
                      ? InkWell(
                          onTap: () async {
                            await FirebaseAuth.instance
                                .signOut()
                                .then((value) async {
                        GoogleSignInAccount?  g =  await    GoogleSignIn().signOut();
                       
                           Shared.setLoginStatus(false);
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => LoginScreen())));
                              await _clearCache();
                            });
                            // FirebaseAuth.instance.userChanges();
                          },
                          child: ListTile(
                            minVerticalPadding: minVerticalPadding,
                            leading: Image.asset(
                              'assets/signout.png',
                              color: Color.fromARGB(255, 34, 26, 106),
                              width: webiconW,
                            ),
                            title: Text(
                              'Sign Out',
                              style: TextStyle(
                                  color: Colors.black, fontSize: webFont),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
                          },
                          child: ListTile(
                            minVerticalPadding: minVerticalPadding,
                            leading: Image.asset(
                      'assets/google.png',
                      width: webiconW,
                      height: webiconW),
                            title: Text(
                              'Sign In',
                              style: TextStyle(
                                  color: Colors.black, fontSize: webFont),
                            ),
                          ),
                        ),
                  // Opacity(
                  //   opacity: 0.0,
                  //   child: InkWell(
                  //     splashColor: Colors.transparent,
                  //     onLongPress: () {
                  //       launch(C.appsharelink);

                  //       showDialog(
                  //           context: context,
                  //           builder: (context) {
                  //             TextEditingController pass =
                  //                 TextEditingController();
                  //             bool isPass = false;

                  //             return Dialog(
                  //               child: Container(
                  //                 width: w * 0.4,
                  //                 height: h * 0.6,
                  //                 child: Column(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceEvenly,
                  //                   children: [
                  //                     Container(
                  //                       height: h * 0.15,
                  //                       width: w * 0.36,
                  //                       child: TextField(
                  //                         controller: pass,
                  //                       ),
                  //                     ),
                  //                     GestureDetector(
                  //                       onTap: () {
                  //                         if (isPass) {
                  //                           Shared.setAdmin(true);
                  //                           print(
                  //                               'isadmin after set ${Shared.isAdmin}');
                  //                           Navigator.pop(context);
                  //                         }
                  //                       },
                  //                       child: Container(
                  //                         // height: double.infinity,
                  //                         // width: double.infinity,
                  //                         width: w * 0.4,
                  //                         height: h * 0.15,
                  //                         color: Colors.red.shade100,
                  //                       ),
                  //                     ),
                  //                     ElevatedButton(
                  //                         onPressed: () {
                  //                           if (pass.text == 'shu22396') {
                  //                             Shared.setAdmin(true);
                  //                             Navigator.pop(context);
                  //                             setState(() {
                  //                               isPass = true;
                  //                               passs = pass.text;
                  //                             });
                  //                           } else {
                  //                             Shared.setAdmin(false);
                  //                             print(
                  //                                 'isadmin after ${Shared.isAdmin}');
                  //                             pass.clear();
                  //                             Navigator.pop(context);
                  //                           }
                  //                         },
                  //                         child: Text('Go')),
                  //                   ],
                  //                 ),
                  //               ),
                  //             );
                  //           });
                  //     },
                  //     child: ListTile(
                  //       minVerticalPadding: minVerticalPadding,
                  //       leading: Image.asset(
                  //         'assets/man1.webp',
                  //         // 'assets/man1.webp',
                  //         width: webiconW,
                  //       ),
                  //       title: Text(
                  //         'Admin',
                  //         style:
                  //             TextStyle(color: Colors.black, fontSize: webFont),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _clearCache() async {
    await _deleteCacheDir();
    await _deleteAppDir();
  }

  Future<void> _deleteCacheDir() async {
    var tempDir = await getTemporaryDirectory();

    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    var appDocDir = await getApplicationDocumentsDirectory();

    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
  }

  Future _initPackageInfo() async {
    return packageInfo = await PackageInfo.fromPlatform();
  }
}
