import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sptan/core/helper/keys.dart';
import 'package:sptan/core/services/file_picker.dart';
import 'package:sptan/core/services/firestore_database.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/shared.dart';
import 'package:sptan/presentation/helper/text_styles.dart';

class SendMessageFieldWidget extends StatefulWidget {
  final String chatID;
  final int length;

  SendMessageFieldWidget({
    @required this.chatID,
    @required this.length,
  });

  @override
  _SendMessageFieldWidgetState createState() => _SendMessageFieldWidgetState();
}

class _SendMessageFieldWidgetState extends State<SendMessageFieldWidget> {
  final messageKey = GlobalKey<FormState>();
  TextEditingController _textEditingController;
  String currentMessage;
  File _pickedFile;
  String _messageType;
  bool _toPickFiles = false;
  bool _sendingFile = false;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Shared shared = Provider.of<Shared>(context);
    if (_toPickFiles) {
      return Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.grey[400],
              offset: Offset(0, -3),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              shared.isPickFile = true;
                              File file = await FilesPicker().pickImage();
                              if (file != null)
                                setState(() {
                                  _pickedFile = file;
                                  _messageType = Keys.ImageMessage;
                                });
                              shared.isPickFile = false;
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.photo,
                                    color: CCRed,
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  'Bild',
                                  textAlign: TextAlign.center,
                                  style: TSMuseoStyle.copyWith(
                                      fontWeight: FontWeight.bold),
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
                              shared.isPickFile = true;
                              File file = await FilesPicker().pickPdf();
                              if (file != null)
                                setState(() {
                                  _pickedFile = file;
                                  _messageType = Keys.PDfMessage;
                                });
                              shared.isPickFile = false;
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.picture_as_pdf,
                                    color: CCRed,
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  'PDF',
                                  textAlign: TextAlign.center,
                                  style: TSMuseoStyle.copyWith(
                                      fontWeight: FontWeight.bold),
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
                          Expanded(
                            child: Text(
                              _pickedFile.path.split('/').last,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TSMuseoStyle,
                            ),
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
                            length: widget.length,
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
      );
    } else
      return Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.grey[400],
              offset: Offset(0, -3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
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
                    maxLines: 2,
                    textInputAction: TextInputAction.newline,
                    validator: (value) => value.isEmpty ? '' : null,
                    decoration: InputDecoration(
                      //set counter style height to 0  for hide it
                      counterText: '',
                      counterStyle: TextStyle(height: 0),
                      errorStyle: TextStyle(height: 0),
                      hintText: 'Nachricht eingeben',
                      hintStyle: TSMuseoStyle.copyWith(
                        color: Colors.grey[900],
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
                      length: widget.length,
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
      );
  }
}
