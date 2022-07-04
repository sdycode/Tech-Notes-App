import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stick_box/constants.dart';
import 'package:stick_box/main.dart';
import 'package:stick_box/sizes.dart';

// import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

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
  double w = Sizes().sw;
  double h = Sizes().sh;
  double iconH = 0.045;
  double webiconW = Sizes().sw * 0.045;
  double webFont = Sizes().sw * 0.02;
  double minVerticalPadding = Sizes().sh * 0.024;
  String passs = '';
  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? SafeArea(
            child: Container(
              width: max(Sizes().sw * 0.3, 200),
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: Colors.transparent,
                image: DecorationImage(
                    image: AssetImage('assets/drbg1.jpg'), fit: BoxFit.cover),
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
                      image: DecorationImage(
                          image: AssetImage('assets/bg1.jpg'),
                          fit: BoxFit.cover),
                    ),
                    child: ListView(
                      children: [
                        // Align(
                        //     alignment: Alignment.topRight,
                        //     child: InkWell(
                        //         onTap: () {
                        //           Navigator.pop(context);
                        //         },
                        //         child: Container(
                        //            margin: EdgeInsets.all(10),
                        //           child: Icon(Icons.close, size:sh * 0.04)))),
                        SizedBox(
                          height: Sizes().sh * 0.06,
                        ),

                        InkWell(
                          onTap: () {
                            // launch(C.appsharelink);

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
                              style: TextStyle(
                                  color: Colors.black, fontSize: webFont),
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
                              style: TextStyle(
                                  color: Colors.black, fontSize: webFont),
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
                              style: TextStyle(
                                  color: Colors.black, fontSize: webFont),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // launch(C.playstorelink);
                          },
                          child: ListTile(
                            minVerticalPadding: minVerticalPadding,
                            leading: Image.asset(
                              'assets/playstore.png',
                              width: webiconW,
                            ),
                            title: Text(
                              'More Apps',
                              style: TextStyle(
                                  color: Colors.black, fontSize: webFont),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // launch(C.linkedinlink);
                          },
                          child: ListTile(
                            minVerticalPadding: minVerticalPadding,
                            leading: Image.asset(
                              'assets/linkedin.png',
                              width: webiconW,
                            ),
                            title: Text(
                              'Linked In',
                              style: TextStyle(
                                  color: Colors.black, fontSize: webFont),
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
                              'assets/youtube.png',
                              width: webiconW,
                            ),
                            title: Text(
                              'YouTube',
                              style: TextStyle(
                                  color: Colors.black, fontSize: webFont),
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
                              style: TextStyle(
                                  color: Colors.black, fontSize: webFont),
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
                              style: TextStyle(
                                  color: Colors.black, fontSize: webFont),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : SafeArea(
            child: Container(
              width: Sizes().sw * 0.7,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: Colors.transparent,
                image: DecorationImage(
                    image: AssetImage('assets/drbg1.jpg'), fit: BoxFit.cover),
              ),
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top * 2,
                  bottom: MediaQuery.of(context).viewPadding.top * 2),
              // color: Colors.red,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                child: Drawer(
                  // backgroundColor: Colors.white,
                  child: Container(
                    // color: Colors.white,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: AssetImage('assets/bg1.jpg'),
                          fit: BoxFit.cover),
                    ),
                    child: ListView(
                      children: [
                        // Align(
                        //     alignment: Alignment.topRight,
                        //     child: InkWell(
                        //         onTap: () {
                        //           Navigator.pop(context);
                        //         },
                        //         child: Container(
                        //            margin: EdgeInsets.all(10),
                        //           child: Icon(Icons.close, size:sh * 0.04)))),
                        SizedBox(
                          height: Sizes().sh * 0.1,
                        ),
                        InkWell(
                          onTap: () {
                            // launch(C.appsharelink);
                          },
                          child: ListTile(
                            leading: Image.asset(
                              'assets/starr.png',
                              width: w * 0.1,
                            ),
                            title: Text(
                              'Rate Us',
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.06),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // launch(C.playstorelink);
                          },
                          child: ListTile(
                            leading: Image.asset(
                              'assets/playstore.png',
                              width: w * 0.1,
                            ),
                            title: Text(
                              'More Apps',
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.06),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // launch(C.linkedinlink);
                          },
                          child: ListTile(
                            leading: Image.asset(
                              'assets/linkedin.png',
                              width: w * 0.1,
                            ),
                            title: Text(
                              'Linked In',
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.06),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // launch(C.appsharelink);
                          },
                          child: ListTile(
                            leading: Image.asset(
                              'assets/youtube.png',
                              width: w * 0.1,
                            ),
                            title: Text(
                              'YouTube',
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.06),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            launch("https://github.com/sdycode");
                          },
                          child: ListTile(
                            leading: Image.asset(
                              'assets/git.png',
                              width: w * 0.1,
                            ),
                            title: Text(
                              'Github',
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.06),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            // Share.share(C.appsharelink);
                          },
                          child: ListTile(
                            leading: Image.asset(
                              'assets/share.png',
                              color: Colors.deepPurple,
                              width: w * 0.1,
                            ),
                            title: Text(
                              'Share',
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.06),
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
}

/*


 children: [
                // Align(
                //     alignment: Alignment.topRight,
                //     child: InkWell(
                //         onTap: () {
                //           Navigator.pop(context);
                //         },
                //         child: Container(
                //            margin: EdgeInsets.all(10),
                //           child: Icon(Icons.close, size:sh * 0.04)))),
                Container(
                  margin: EdgeInsets.all(sh*0.05),
                  height:sh * 0.3, 
                  
                  
                  child:const FittedBox( 
                    child: Text(
                      "Photo Editor\n&\nBackground\nRemover",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'LifeSavers-Regular'),
                    ) ,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: sh*0.01),
                     height:sh*0.05, 
                  child: ListTile(
                    leading: Container(
                      height:sh*0.05, 
                      child: Image.asset('assets/icons/new/help.webp', 

                      
                      fit: BoxFit.fitHeight, 
                      
                      color: Colors.black,),
                    ),
                    title: Container(
                       margin: EdgeInsets.only(left :sw*0.005),
                      height:sh*0.05, 
                      child: const Align( 
                        alignment: Alignment.centerLeft,
                        child: FittedBox( 
                          fit: BoxFit.fitHeight, 
                          child: Text('Help & Feedback', 
                          textAlign: TextAlign.left, 
                                       )),
                      )),
                    onTap: () {
                      launch("mailto:support@touchzing.com");
                    },
                  ),
                ),
                Container(
                  height:sh*0.05, 
                    margin: EdgeInsets.only(top: sh*0.01),
                  child: ListTile(
                    leading: Container(
                      height:sh*0.05, 
                      child: Image.asset('assets/icons/new/about.webp', fit: BoxFit.fitHeight,  color: Colors.black,),
                    ),
                    title:Container(
                       margin: EdgeInsets.only(left :sw*0.005),
                      height:sh*0.05, 
                      child:const Align( 
                        alignment: Alignment.centerLeft,
                        child: FittedBox( 
                          fit: BoxFit.fitHeight, 
                          child: Text('About us', 
                          textAlign: TextAlign.left, 
                                       )),
                      )),
                    onTap: () {
                      launch("https://www.touchzing.com/about.php");
                    },
                  ),
                ),
                Container(
                  height:sh*0.05,   margin: EdgeInsets.only(top: sh*0.01),
                  child: ListTile(
                    leading:
                      Container(
                      height:sh*0.05, 
                      child: Image.asset('assets/icons/new/privacy.webp',fit: BoxFit.fitHeight, color: Colors.black,),
                    ),
                    title:Container(
                       margin: EdgeInsets.only(left :sw*0.005),
                      height:sh*0.05, 
                      child:const Align( 
                        alignment: Alignment.centerLeft,
                        child: FittedBox( 
                          fit: BoxFit.fitHeight, 
                          child: Text('Privacy Policy', 
                          textAlign: TextAlign.left, 
                                       )),
                      )),
                    onTap: () {
                      launch("http://www.touchzing.com/privacy/");
                    },
                  ),
                ),
                Container
                (
                  height:sh*0.05,   margin: EdgeInsets.only(top: sh*0.01),
                  child: ListTile(
                    leading: Container(
                      height:sh*0.05, 
                      child: Image.asset('assets/icons/new/rateus.webp',fit: BoxFit.fitHeight, color: Colors.black,),
                    ),
                    title: Container(
                       margin: EdgeInsets.only(left :sw*0.005),
                      height:sh*0.05, 
                      child:const Align( 
                        alignment: Alignment.centerLeft,
                        child: FittedBox( 
                          fit: BoxFit.fitHeight, 
                          child: Text('Rate us', 
                          textAlign: TextAlign.left, 
                                       )),
                      )),
                    onTap: () {
                      // StoreRedirect.redirect(
                      //   androidAppId:
                      //       "com.tz.picture.quotes.creator.insta.caption.pics.poetry",
                      // );
                      // launch("http://www.touchzing.com/privacy/");
                    },
                  ),
                ),
          
              ],
           
*/

/*
 children: [
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                         margin: EdgeInsets.all(10),
                        child: Icon(Icons.close, size: Sizes().sh * 0.04)))),
              SizedBox(
                height: Sizes().sh * 0.08,
              ),
              ListTile(
                leading: Icon(Icons.headphones, 
                  // MdiIcons.helpCircleOutline,
                    size: Sizes().sh * 0.05),
                title: Container(
                   margin: EdgeInsets.only(left :Sizes().sw*0.005),
                  height: Sizes().sh*0.05, 
                  child: const Align( 
                    alignment: Alignment.centerLeft,
                    child: FittedBox( 
                      fit: BoxFit.fitHeight, 
                      child: Text('Help & Feedback', 
                      textAlign: TextAlign.left, 
                                   )),
                  )),
                onTap: () {
                  launch("mailto:support@touchzing.com");
                },
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined,
                    size: Sizes().sh * 0.05),
                title:Container(
                   margin: EdgeInsets.only(left :Sizes().sw*0.005),
                  height: Sizes().sh*0.05, 
                  child:const Align( 
                    alignment: Alignment.centerLeft,
                    child: FittedBox( 
                      fit: BoxFit.fitHeight, 
                      child: Text('About us', 
                      textAlign: TextAlign.left, 
                                   )),
                  )),
                onTap: () {
                  launch("https://www.touchzing.com/about.php");
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.ac_unit_outlined, 
                      
                      // MdiIcons.information, 
                       size: Sizes().sh * 0.05),
                title:Container(
                   margin: EdgeInsets.only(left :Sizes().sw*0.005),
                  height: Sizes().sh*0.05, 
                  child:const Align( 
                    alignment: Alignment.centerLeft,
                    child: FittedBox( 
                      fit: BoxFit.fitHeight, 
                      child: Text('Privacy Policy', 
                      textAlign: TextAlign.left, 
                                   )),
                  )),
                onTap: () {
                  launch("http://www.touchzing.com/privacy/");
                },
              ),
              ListTile(
                leading: Icon(Icons.rate_review, size: Sizes().sh * 0.05),
                title: Container(
                   margin: EdgeInsets.only(left :Sizes().sw*0.005),
                  height: Sizes().sh*0.05, 
                  child:const Align( 
                    alignment: Alignment.centerLeft,
                    child: FittedBox( 
                      fit: BoxFit.fitHeight, 
                      child: Text('Rate us', 
                      textAlign: TextAlign.left, 
                                   )),
                  )),
                onTap: () {
                  StoreRedirect.redirect(
                    androidAppId:
                        "com.tz.picture.quotes.creator.insta.caption.pics.poetry",
                  );
                  // launch("http://www.touchzing.com/privacy/");
                },
              ),
            ],
          

*/
