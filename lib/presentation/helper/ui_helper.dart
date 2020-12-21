// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:shimmer/shimmer.dart';
// import 'colors.dart';
//
import 'package:flutter/material.dart';

class UIHelper {

  static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(30),
    ),
  );
// static Widget spinLoading = SpinKitDoubleBounce(
//     color: CCYellow,
//     size: 30,
//   );
//
// static Widget shimmerLoading = Center(
//     child: Shimmer.fromColors(
//       baseColor: Colors.grey[300],
//       highlightColor: Colors.white,
//       child: Container(color: Colors.grey),
//     ),
//   );
//
// static  Future showSpinLoading(BuildContext context) async {
//   return await showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) {
//       return spinLoading;
//     },
//   );
// }
//
static  Future showDialogForME(BuildContext context, Widget dialog) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return dialog;
      },
    );
  }
 }

