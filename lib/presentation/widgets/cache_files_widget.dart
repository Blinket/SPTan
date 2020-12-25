import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sptan/core/helper/keys.dart';
import 'package:sptan/presentation/helper/navigate_functions.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/views/full_image_view.dart';
import 'package:sptan/presentation/views/pdf_view.dart';

class CacheFiles extends StatefulWidget {
  final String fileUrl;
  final String fileName;
  final String fileType;
  final String chatId;

  CacheFiles({
    @required this.fileUrl,
    @required this.fileName,
    @required this.fileType,
    @required this.chatId,
  });

  @override
  _CacheFilesState createState() => _CacheFilesState();
}

class _CacheFilesState extends State<CacheFiles> {
  Future<File> getFileFuture;

  @override
  void initState() {
    getFileFuture = DefaultCacheManager().getSingleFile(widget.fileUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      key: Key(widget.fileUrl),
      future: getFileFuture,
      builder: (context, snapshot) {
        bool loading = snapshot.connectionState == ConnectionState.waiting;
        if (widget.fileType == Keys.ImageMessage)
          return Container(
            height: 250,
            child: Center(
              child: loading
                  ? SpinKitDoubleBounce(
                      color: Colors.white,
                      size: 25,
                    )
                  : InkWell(
                      onTap: () => Navigate.push(
                        context,
                        FullImageView(
                          image: snapshot.data,
                          chatId: widget.chatId,
                          imageName: widget.fileName,
                        ),
                      ),
                      child: Image.file(
                        snapshot.data,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          );
        else if (widget.fileType == Keys.PDfMessage) {
          return Container(
            height: 90,
            child: Center(
              child: loading
                  ? SpinKitDoubleBounce(
                      color: Colors.white,
                      size: 25,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigate.push(
                                context,
                                PdfViewierView(
                                  file: snapshot.data,
                                  fileName: widget.fileName,
                                  chatId: widget.chatId,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.grey,
                                    )
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    'öffnen',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TSMuseoStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            widget.fileName ??
                                snapshot.data.path.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TSMuseoStyle.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        } else
          return Container();
      },
    );
  }
}
