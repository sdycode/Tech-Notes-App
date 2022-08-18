import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stick_box/screens/main_screen.dart';
import 'package:stick_box/utils/snackbar.dart';

import '../utils/shared.dart';
import 'checkinternetconnect.dart';

class FirebaseAuthClass {
  FirebaseAuth _auth;
  FirebaseAuthClass(this._auth);

  signInWithGoogle(BuildContext context) async {
    if (!await checkInternetConnection()) {
      showSnack(context, 'Check Internet Connection');
      return;
    } else {}
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        googleAuthProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        await _auth.signInWithPopup(googleAuthProvider);
      } else {
        final GoogleSignInAccount? _currentUser = await GoogleSignIn(
          signInOption: SignInOption.standard
        ).signIn();

        print(' email ${_currentUser!.email}');

        // showSnack(context, _currentUser.email + _currentUser.id);
        final GoogleSignInAuthentication? googleAuth =
            await _currentUser.authentication;
        print('${googleAuth!.accessToken!}');
        // showSnack(context, googleAuth.accessToken!);
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
          UserCredential _userCredential =
              await _auth.signInWithCredential(credential);
              Shared.setLoginStatus(true);
              Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
        }
      }
    } catch (e) {
      print('err $e');
      if(kDebugMode){
        // showSnack(context, e.toString());
      }
      // showSnack(context, e.toString());
      // showLoadingDialog(context, e.toString());
      if (kIsWeb) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      }
    }
  }

  void showLoadingDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Text('Sign in Failed due to \n $msg'),
            ));
  }
}
