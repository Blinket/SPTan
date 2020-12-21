import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/text_styles.dart';

class ChatView extends StatefulWidget {
  final int chatDuration;

  ChatView(this.chatDuration);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  int generatedCode;
  Timer _timer;
  int durationInSecond;
  String currentMessage;
  List<String> messages = [];

  final messageKey = GlobalKey<FormState>();
  TextEditingController _textEditingController;
  ScrollController _scrollController;

  void startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (durationInSecond == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            durationInSecond--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    durationInSecond = widget.chatDuration * 60;
    startTimer();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: size.width,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: CCRed,
                        size: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CCRed.withOpacity(0.85),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            7,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${durationInSecond ~/ 60}:${durationInSecond % 60}',
                          style: TSRobotoBoldStyle.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, int index) {
                  return Row(
                    mainAxisAlignment: index.isEven
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      ChatBubble(
                        clipper: ChatBubbleClipper4(
                          radius: 0,
                          type: index.isEven
                              ? BubbleType.receiverBubble
                              : BubbleType.sendBubble,
                        ),
                        backGroundColor: index.isEven ? Colors.grey[400] : CCRed,
                        margin: EdgeInsets.only(
                          top: 20,
                          bottom: index == messages.length - 1 ? 20 : 0,
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: size.width * 0.7,
                          ),
                          child: Text(
                            messages[index],
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.attach_file,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (messageKey.currentState.validate()) {
                          _textEditingController.clear();
                          setState(() {
                            messages.add(currentMessage);
                          });
                          // _scrollController.animateTo(
                          //   _scrollController.position.maxScrollExtent,
                          //   curve: Curves.easeOut,
                          //   duration: const Duration(milliseconds: 200),
                          // );
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
        ),
      ),
    );
  }
}
