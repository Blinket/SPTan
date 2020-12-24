import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sptan/core/helper/keys.dart';
import 'package:sptan/core/models/massage_data.dart';
import 'package:sptan/core/services/file_picker.dart';
import 'package:sptan/core/services/firebase_auth.dart';
import 'package:sptan/core/services/firestore_database.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/helper/ui_helper.dart';
import 'package:sptan/presentation/widgets/cache_images.dart';

class ChatBodyWidget extends StatefulWidget {
  final String chatID;

  ChatBodyWidget(this.chatID);

  @override
  _ChatBodyWidgetState createState() => _ChatBodyWidgetState();
}

class _ChatBodyWidgetState extends State<ChatBodyWidget> {
  final messageKey = GlobalKey<FormState>();
  TextEditingController _textEditingController;
  String currentMessage;
  File _pickedFile;
  String _messageType;
  bool _toPickFiles = false;
  bool _sendingFile = false;
  Stream<QuerySnapshot> messagesStream;

  @override
  void initState() {
    messagesStream = FirestoreDatabase().messagesStream(widget.chatID);
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
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
                        content: messages[index].data()[Keys.MessageContent],
                        type: messages[index].data()[Keys.MessageType],
                        sentIN: messages[index].data()[Keys.MessageSentIN],
                        senderID: messages[index].data()[Keys.MessageSenderId],
                      );
                      bool isFromMe = messageData.senderID == uid;
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
                              top: index == messages.length - 1 ? 20 : 0,
                              bottom: 20,
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: size.width * 0.7,
                              ),
                              child: messageData.type != Keys.TextMessage
                                  ? CacheFiles(
                                      fileUrl: messageData.content,
                                      fileType: messageData.type,
                                    )
                                  : Text(
                                      messageData.content,
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
                if (_toPickFiles)
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.grey[300],
                          offset: Offset(3, 0),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: _pickedFile == null
                          ? Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _toPickFiles = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.keyboard_arrow_left,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  child: VerticalDivider(width: 0),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          File file =
                                              await FilesPicker().pickImage();
                                          if (file != null)
                                            setState(() {
                                              _pickedFile = file;
                                              _messageType = Keys.ImageMessage;
                                            });
                                        },
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.photo,
                                                color: CCRed,
                                                size: 30,
                                              ),
                                            ),
                                            Text(
                                              'Image',
                                              textAlign: TextAlign.center,
                                              style: TSMuseoStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: VerticalDivider(width: 0),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          File file =
                                              await FilesPicker().pickPdf();
                                          if (file != null)
                                            setState(() {
                                              _pickedFile = file;
                                              _messageType = Keys.PDfMessage;
                                            });
                                        },
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.picture_as_pdf,
                                                color: CCRed,
                                                size: 30,
                                              ),
                                            ),
                                            Text(
                                              'Pdf',
                                              textAlign: TextAlign.center,
                                              style: TSMuseoStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          _messageType == Keys.PDfMessage
                                              ? Icons.picture_as_pdf
                                              : Icons.photo,
                                          color: CCRed,
                                          size: 30,
                                        ),
                                      ),
                                      Text(
                                        _pickedFile.path.split('/').last,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TSMuseoStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                if (!_sendingFile)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _toPickFiles = false;
                                        _pickedFile = null;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                if (_sendingFile)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SpinKitDoubleBounce(
                                      color: CCRed,
                                      size: 25,
                                    ),
                                  )
                                else
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        _sendingFile = true;
                                      });
                                      await FirestoreDatabase().sendMessage(
                                        length: messages.length,
                                        content: _pickedFile,
                                        type: _messageType,
                                        chatID: widget.chatID,
                                      );
                                      setState(() {
                                        _sendingFile = false;
                                        _pickedFile = null;
                                        _toPickFiles = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.send,
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 8),
                              ],
                            ),
                    ),
                  )
                else
                  Container(
                    width: size.width,
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Expanded(
                            child: Form(
                              key: messageKey,
                              child: TextFormField(
                                controller: _textEditingController,
                                textAlign: TextAlign.left,
                                onChanged: (String value) {
                                  setState(() {
                                    currentMessage = value;
                                  });
                                },
                                style: TSMuseoStyle,
                                textInputAction: TextInputAction.newline,
                                validator: (value) => value.isEmpty ? '' : null,
                                decoration: InputDecoration(
                                  //set counter style height to 0  for hide it
                                  counterText: '',
                                  counterStyle: TextStyle(height: 0),
                                  errorStyle: TextStyle(height: 0),
                                  hintText: 'Nachricht eingeben',
                                  hintStyle: TSMuseoStyle.copyWith(
                                    color: Colors.grey[800],
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red[400],
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _toPickFiles = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.attach_file,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (messageKey.currentState.validate()) {
                                _textEditingController.clear();
                                await FirestoreDatabase().sendMessage(
                                  length: messages.length,
                                  content: currentMessage,
                                  type: Keys.TextMessage,
                                  chatID: widget.chatID,
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.send,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
