import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:share/share.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/helper/ui_helper.dart';
import 'package:sptan/presentation/views/scure_gate_view.dart';

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

class _PdfViewierViewState extends State<PdfViewierView> {
  Future<File> getFileFuture;

  @override
  void initState() {
    getFileFuture = DefaultCacheManager().getSingleFile(widget.fileUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SecureGateView(
      Scaffold(
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
                        : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PdfView(
                              scrollDirection: Axis.vertical,
                              controller: pdfController,
                            ),
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
