import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stick_box/screens/main_screen.dart';
import 'package:stick_box/services/firebaes_auth_methods.dart';

import '../constants/sizes.dart';
import '../utils/shared.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double h = Sizes().sh;
  double w = Sizes().sw;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(w * 0.05),
              child: Container(
                width: w * 0.5,
                height: w * 0.5,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(w*0.1)
                // ),
                child: Image.asset(
                  "assets/logo/noteslogo2.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: h * 0.2,
            ),
            Container(
              child: InkWell(
                onTap: () async {
                  if (!kIsWeb) {
                    FirebaseAuthClass(FirebaseAuth.instance)
                        .signInWithGoogle(context);
                  }
                },
                splashColor: Colors.grey,
                child: kIsWeb
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google.png',
                            width: h * 0.1,
                            height: h * 0.1,
                          ),
                          Text(
                            'Sign in with Google',
                            style: TextStyle(fontSize: h * 0.06),
                          )
                        ],
                      )
                    : Container(
                        padding: EdgeInsets.all(h * 0.02),
                        margin: EdgeInsets.all(h * 0.02),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0.5, 0.5),
                                  color: Colors.grey,
                                  blurRadius: 1,
                                  spreadRadius: 1)
                            ],
                            color: Colors.white,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(h * 0.016)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/google.png',
                              width: w * 0.07,
                              height: w * 0.07,
                            ),
                            SizedBox(
                              width: w * 0.05,
                            ),
                            Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: w * 0.05,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
              ),
            ),
            Center(
              child: Text(
                'OR',
                style: TextStyle(
                    fontSize: w * 0.06,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            InkWell(
              onTap: () {
                Shared.setLoginStatus(false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (c) => MainScreen()));
              },
              child: Container(
                padding: EdgeInsets.all(h * 0.02),
                margin: EdgeInsets.all(h * 0.02),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.5, 0.5),
                          color: Colors.grey,
                          blurRadius: 1,
                          spreadRadius: 1)
                    ],
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(h * 0.016)),
                child: Text(
                  'Continue without Login',
                  style: TextStyle(
                    fontSize: w * 0.05,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
