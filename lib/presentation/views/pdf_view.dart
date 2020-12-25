import 'dart:io';

import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:share/share.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/navigate_functions.dart';
import 'package:sptan/presentation/helper/text_styles.dart';

import 'chat_view.dart';
import 'enter_password_view.dart';

class PdfViewierView extends StatefulWidget {
  final File file;
  final String fileName;
  final String chatId;

  PdfViewierView({
    @required this.file,
    @required this.fileName,
    @required this.chatId,
  });

  @override
  _PdfViewierViewState createState() => _PdfViewierViewState();
}

class _PdfViewierViewState extends State<PdfViewierView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused)
      setState(() {
        _requestPassword = true;
      });
  }

  bool _requestPassword = false;

  @override
  Widget build(BuildContext context) {
    final pdfController = PdfController(
      document: PdfDocument.openFile(widget.file.path),
    );
    if (_requestPassword)
      return EnterPasswordView(() {
        setState(() {
          _requestPassword = false;
        });
      });
    else {
      return WillPopScope(
        onWillPop: () async {
          Navigate.pushReplacement(
            context,
            ChatView(widget.chatId),
          );
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: CCRed,
                        ),
                        onPressed: () => Navigate.pushReplacement(
                          context,
                          ChatView(widget.chatId),
                        ),
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
                        onPressed: () async {
                          await Share.shareFiles(
                            [widget.file.path],
                            text: widget.fileName,
                          );
                        },
                        icon: Icon(
                          Icons.save_alt,
                          color: CCRed,
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
        ),
      );
    }
  }
}
