import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/screens/main_screen.dart';
import 'package:stick_box/screens/login_screen.dart';

import 'package:stick_box/services/local_notification_service.dart';

import 'package:stick_box/utils/provder.dart';
import 'package:stick_box/utils/snackbar.dart';
import 'package:stick_box/utils/theme.dart';

import 'firebase_options.dart';
import 'utils/shared.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// Future<void> backgroundHandler(RemoteMessage remoteMessage) async {
//   print('messager backgroundHandler emoteMessageId ${remoteMessage.data}');
//   print('message backgroundHandler messageId  ${remoteMessage.messageId}');
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).catchError((d) {
    log(
      'catcherr $d',
    );
  });
  if (!kIsWeb) {
    // LocalNotificationService.initialize();
    await FirebaseAuth.instance.authStateChanges();

    // } catch (e) {}
    // await FirebaseMessaging.instance.setAutoInitEnabled(true);
    // final fcmToken = await FirebaseMessaging.instance.getToken().then((value) {
    //   print('ff ${value}');
    //   return value;
    // });
    // FirebaseMessaging messaging = FirebaseMessaging.instance;

    // NotificationSettings settings = await messaging
    //     .requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // )
    //     .then((value) {
    //   print('ff sett ${value.authorizationStatus}');
    //   return value;
    // });
    // print('settting ${settings.toString()}');
    // FirebaseMessaging.onBackgroundMessage(
    //     (message) => backgroundHandler(message));
  }

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
  void dispose() {
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
    // print('firebsss in main ${FirebaseAuth.instance}');
    print('firebsss in main cc ${FirebaseAuth.instance.currentUser}');
    if (FirebaseAuth.instance.currentUser == null) {
      Shared.setLoginStatus(false);
    }
    // Shared.setAppThememode(customTheme.currentTheme);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Data(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Notes',
          theme: CustomTheme.lightTheme,
          darkTheme: CustomTheme.darkTheme,
          themeMode: Shared.getCurrthemefromSharedPref(),
          //  ThemeData(
          //   primarySwatch: Colors.blue,

          // ),
          home: kIsWeb
              ? MainScreen()
              : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      User _user = snapshot.data as User;
                      log('_user $_user');
                      return MainScreen();
                    } else {
                      return LoginScreen();
                    }
                  },
                )),
    );
  }
}

/*
    FirebaseOptions(
    apiKey: 'AIzaSyB9eIsVS7sN-zH0TB6jNC1itTSUI22zoSk',
    appId: '1:369790879349:android:069da0d094a6beaac15a3c',
    messagingSenderId: '369790879349',
    projectId: 'flutter-notes-595a2',
    databaseURL: 'https://flutter-notes-595a2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-notes-595a2.appspot.com',
  )*/

// await MobileAds.instance.initialize();
// final RequestConfiguration requestConfiguration =
//     RequestConfiguration(tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.no);
// MobileAds.instance.updateRequestConfiguration(requestConfiguration);
// InterstitialAdsAdmob.instance;
/*


Visit this URL on this device to log in:
https://accounts.google.com/o/oauth2/auth?client_id=563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com&scope=email%20openid%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloudplatformprojects.readonly%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ffirebase%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform&response_type=code&state=50359438&redirect_uri=http%3A%2F%2Flocalhost%3A9005

Waiting for authentication...

+  Success! Use this token to login on a CI server:

1//0gnvF4W_Hz1Z5CgYIARAAGBASNwF-L9Ir9CtOluwONKglDKqJqxIM-YUqipX3bQN702ND3rcrUVGqyUydysja-wg5b34oJxtSNy8

Example: firebase deploy --token "$FIREBASE_TOKEN"

*/
