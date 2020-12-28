import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sptan/core/services/firebase_auth.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/views/enter_password_view.dart';
import 'package:sptan/presentation/views/set_password_view.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashView> {
  void initState() {
    super.initState();
    User user = FirebaseAuthentication().getCurrentUser();
    bool isFirstTime = user == null;
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return isFirstTime ? SetPasswordView() : EnterPasswordView(null);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Text(
            'SPTan',
            style: TSRobotoBoldStyle.copyWith(
              color: CCRed,
              fontSize: 70,
            ),
          ),
        ),
      ),
    );
  }
}
