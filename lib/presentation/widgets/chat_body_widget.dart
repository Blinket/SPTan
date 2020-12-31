import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sptan/core/helper/keys.dart';
import 'package:sptan/core/models/massage_data.dart';
import 'package:sptan/core/services/firebase_auth.dart';
import 'package:sptan/core/services/firestore_database.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/router_helper.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/helper/ui_helper.dart';
import 'package:sptan/presentation/views/full_image_view.dart';
import 'package:sptan/presentation/widgets/pdf_message_widget.dart';
import 'package:sptan/presentation/widgets/send_message_field_widget.dart';

class ChatBodyWidget extends StatefulWidget {
  final String chatID;

  ChatBodyWidget({@required this.chatID});

  @override
  _ChatBodyWidgetState createState() => _ChatBodyWidgetState();
}

class _ChatBodyWidgetState extends State<ChatBodyWidget> {
  Stream<QuerySnapshot> messagesStream;

  @override
  void initState() {
    messagesStream = FirestoreDatabase().messagesStream(widget.chatID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: messagesStream,
          builder: (context, messagesSnap) {
            if (messagesSnap.connectionState == ConnectionState.waiting)
              return UIHelper.SpinLoading;
            else {
              List<DocumentSnapshot> messages = [];
              if (messagesSnap.hasData)
                messages = messagesSnap.data.docs.reversed.toList();
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      reverse: true,
                      itemBuilder: (context, int index) {
                        String uid = FirebaseAuthentication().getUserId();
                        MessageData messageData = MessageData(
                          fileName:
                              messages[index].data()[Keys.MessageFileName],
                          content: messages[index].data()[Keys.MessageContent],
                          type: messages[index].data()[Keys.MessageType],
                          sentIN: messages[index].data()[Keys.MessageSentIN],
                          senderID:
                              messages[index].data()[Keys.MessageSenderId],
                        );
                        bool isFromMe = messageData.senderID == uid;
                        // print('========> index $index message is ${messageData.fileName}');
                        return Row(
                          mainAxisAlignment: isFromMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            ChatBubble(
                              clipper: ChatBubbleClipper4(
                                radius: 0,
                                type: isFromMe
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                              ),
                              backGroundColor:
                                  isFromMe ? CCRed : Colors.grey[400],
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: index == messages.length - 1 ? 20 : 0,
                                bottom: 20,
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: size.width * 0.6,
                                ),
                                child: messageData.type == Keys.ImageMessage
                                    ? Center(
                                        child: InkWell(
                                          onTap: () => RouterHelper.push(
                                            context,
                                            FullImageView(
                                              url: messageData.content,
                                              chatId: widget.chatID,
                                            ),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: messageData.content,
                                            placeholder: (context, url) =>
                                                Container(
                                              height: 250,
                                              child: Center(
                                                child: SpinKitDoubleBounce(
                                                  color: Colors.white,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : messageData.type == Keys.PDfMessage
                                        ? PdfMessage(
                                            fileName: messageData.fileName,
                                            fileUrl: messageData.content,
                                            chatId: widget.chatID,
                                          )
                                        : Text(
                                            messageData.content ?? '',
                                            style: TSMuseoStyle.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SendMessageFieldWidget(
                    chatID: widget.chatID,
                    length: messages.length,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
