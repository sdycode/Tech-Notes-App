import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/cloudstorescreen.dart';
import 'package:stick_box/remotescreen.dart';
import 'package:stick_box/splash.dart';
import 'package:stick_box/utils/theme.dart';

import 'firebase_options.dart';
import 'utils/shared.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await MobileAds.instance.initialize();
  // final RequestConfiguration requestConfiguration =
  //     RequestConfiguration(tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.no);
  // MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  // InterstitialAdsAdmob.instance;
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Shared.init();
  runApp(const MyApp());
}

CustomTheme customTheme = CustomTheme();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override

  @override
  void initState() {
    // TODO: implement initState
    customTheme.addListener(() {
      themeListener();
    });
    super.initState();
  }
  @override
  void dispose(){
  customTheme.removeListener(() {
      themeListener();
    });
    super.dispose();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print('theme called');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Notes',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: customTheme.currentTheme,
      //  ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home:
      
      // RemoteScreen()
       CloudStoreScreen(),
    );
  }
}
