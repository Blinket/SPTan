import 'package:flutter/material.dart';
import 'package:sptan/presentation/helper/router_helper.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/views/pdf_view.dart';

class PdfMessage extends StatelessWidget {
  final String fileUrl;
  final String fileName;
  final String chatId;

  PdfMessage({
    @required this.fileUrl,
    @required this.fileName,
    @required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Center(
        child: Column(
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
                  onTap: () => RouterHelper.pushReplacement(
                    context,
                    PdfViewierView(
                      fileUrl: fileUrl,
                      chatId: chatId,
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
                        'Öffnen',
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
                fileName ?? '',
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
  }
}
