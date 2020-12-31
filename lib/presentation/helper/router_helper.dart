import 'package:flutter/material.dart';

class RouterHelper {
  static push(BuildContext context, Widget navigateTo) {
    return Navigator.push(
      context,
       PageRouteBuilder(
    pageBuilder: (_,__,___) => navigateTo,
    transitionDuration: Duration(milliseconds: 0),
    reverseTransitionDuration: Duration(milliseconds:0),
  ),
      // MaterialPageRoute(builder: (context) {
      //   return navigateTo;
      // }),
    );
  }

  static  pushReplacement(BuildContext context, Widget navigateTo) {
     return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => navigateTo,
      ),
          (route) => false,
    );
  }
}