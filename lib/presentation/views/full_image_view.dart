import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/text_styles.dart';

class FullImageView extends StatelessWidget {
  final File image;

  FullImageView(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    color: Colors.grey[300],
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: CCRed,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Hero(
                    tag: 'logo',
                    child: Text(
                      'SPTan',
                      style: TSRobotoBoldStyle.copyWith(
                        color: CCRed,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Image.file(
                  image,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Container(height: 50),
          ],
        ),
      ),
    );
  }
}
