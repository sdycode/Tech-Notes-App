
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteScreen extends StatefulWidget {
  const RemoteScreen({Key? key}) : super(key: key);

  @override
  State<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<FirebaseRemoteConfig>(
          future: setupRemoteConfig(),
          builder: (BuildContext context,
              AsyncSnapshot<FirebaseRemoteConfig> snapshot) {
            return snapshot.hasData
                ? Center(
                  child: Text(snapshot.data!.getBool('layout1')
                      .toString()),
                )
                : Container();
          },
        ),
      ),
    );
  }

  Future<FirebaseRemoteConfig> setupRemoteConfig() async {
      print('remmfff ');
  // FirebaseApp f =   await Firebase.initializeApp(
  //     // options: const FirebaseOptions(
  //         // apiKey: 'AIzaSyA7-Kt57ZhVrszuG_2JbVQAZDJUjoLmzzs',
  //         // authDomain: 'quotes-sayings-status.firebaseapp.com',
  //         // databaseURL: 'https://quotes-sayings-status.firebaseio.com',
  //         // storageBucket: 'quotes-sayings-status.appspot.com',
  //         // projectId: 'quotes-sayings-status',
  //         // messagingSenderId: '',
  //         // appId: '1:143387092652:android:eecc4d1b837bacf26b6109',
  //         // measurementId: ''
  //         // ),
  //   );
    //  print('remm fire ${f.name}');
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(minutes: 5),
    ));
    // await remoteConfig.setDefaults(<String, dynamic>{
    //   'welcome': 'default welcome',
    //   'hello': 'default hello',
    // });
     print('remmfff ${remoteConfig}');
await remoteConfig.fetchAndActivate();
    print('remm ${remoteConfig}');
   bool layout1=  remoteConfig.getBool('layout1');
    print('remm layou $layout1');
    RemoteConfigValue(null, ValueSource.valueStatic);
    return remoteConfig;
  }
}