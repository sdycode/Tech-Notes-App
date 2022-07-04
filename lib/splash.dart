// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// import 'constants.dart';
// import 'sizes.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   late DatabaseReference dref;
//   double h = Sizes().sh;
//   double w = Sizes().sw;
//   String data = '';
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     dref = FirebaseDatabase.instance.refFromURL(C.rootlink);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           height: h,
//           width: w,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(data),
//               StreamBuilder(
//                   stream: dref.onValue,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData &&
//                         snapshot.connectionState == ConnectionState.done) {
//                       Map l = snapshot.data as Map;
//                       print('list is $l');
//                       return Center();
//                     } else {
//                       return Center();
//                     }
//                   }),
//               ElevatedButton(onPressed: () {}, child: Text('get'))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
