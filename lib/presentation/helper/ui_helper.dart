import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class UIHelper {



  static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey[600],
      width: 1.5,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(30),
    ),
  );

  static const Widget SpinLoading = SpinKitSquareCircle(
    color: Color(0xffEE564D),
    duration: Duration(milliseconds: 1500),
    size: 30,
  );

  static const Widget HourGlassLoading = SpinKitHourGlass(
    color: Color(0xffEE564D),
    duration: Duration(milliseconds: 1800),
    size: 40,
  );

  // static Widget shimmerLoading = Center(
  //   child: Shimmer.fromColors(
  //     baseColor: Colors.grey[300],
  //     highlightColor: Colors.white,
  //     child: Container(color: Colors.grey),
  //   ),
  // );

  static Future showSpinLoading(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return SpinLoading;
      },
    );
  }

  static Future showDialogForME(BuildContext context, Widget dialog) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return dialog;
      },
    );
  }
}
