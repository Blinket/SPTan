import 'package:flutter/material.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/text_styles.dart';

class ButtonWidget extends StatelessWidget {
  final Function onTap;
  final String text;

  ButtonWidget({
    @required this.onTap,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: CCRed,
          borderRadius: BorderRadius.all(
            Radius.circular(
              7,
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TSRobotoBoldStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
