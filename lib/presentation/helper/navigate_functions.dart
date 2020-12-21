import 'package:flutter/material.dart';

class Navigate {
  static push(BuildContext context, Widget navigateTo) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return navigateTo;
      }),
    );
  }

  static  pushReplacement(BuildContext context, Widget navigateTo) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return navigateTo;
        },
      ),
    );
  }
}