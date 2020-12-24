import 'dart:io';

import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/text_styles.dart';

class PdfViewierView extends StatefulWidget {
  final File file;

  PdfViewierView(this.file);

  @override
  _PdfViewierViewState createState() => _PdfViewierViewState();
}

class _PdfViewierViewState extends State<PdfViewierView> {
  @override
  Widget build(BuildContext context) {
    final pdfController = PdfController(
      document: PdfDocument.openFile(widget.file.path),
    );
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
              child: PdfView(
                scrollDirection: Axis.vertical,
                controller: pdfController,
              ),
            ),
            // Expanded(
            //   child: Center(
            //     child: Image.file(
            //       image,
            //       width: MediaQuery.of(context).size.width,
            //     ),
            //   ),
            // ),
            // Container(height: 50),
          ],
        ),
      ),
    );
  }
}
