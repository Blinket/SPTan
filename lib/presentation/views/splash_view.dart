import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/views/set_password_view.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashView> {
  bool isLoggedIn = false;

  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return SetPasswordView();
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
