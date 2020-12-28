import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:share/share.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/navigate_functions.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/helper/ui_helper.dart';

import 'chat_view.dart';
import 'enter_password_view.dart';

class PdfViewierView extends StatefulWidget {
  final String fileUrl;
  final String chatId;

  PdfViewierView({
    @required this.fileUrl,
    @required this.chatId,
  });

  @override
  _PdfViewierViewState createState() => _PdfViewierViewState();
}

class _PdfViewierViewState extends State<PdfViewierView>
    with WidgetsBindingObserver {
  Future<File> getFileFuture;

  @override
  void initState() {
    getFileFuture = DefaultCacheManager().getSingleFile(widget.fileUrl);
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
          backgroundColor: Colors.white,
          body: SafeArea(
            child: FutureBuilder<File>(
              key: Key(widget.fileUrl),
              future: getFileFuture,
              builder: (context, snapshot) {
                PdfController pdfController;
                bool _loading =
                    snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData;
                if (!_loading && snapshot.data != null)
                  pdfController = PdfController(
                    document: PdfDocument.openFile(snapshot.data.path),
                  );
                return Column(
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
                              if (!_loading)
                                await Share.shareFiles(
                                  [snapshot.data.path],
                                );
                            },
                            icon: Icon(
                              Icons.save_alt,
                              color: _loading ? Colors.transparent : CCRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _loading
                          ? Center(child: UIHelper.SpinLoading)
                          : PdfView(
                              scrollDirection: Axis.vertical,
                              controller: pdfController,
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }
  }
}
