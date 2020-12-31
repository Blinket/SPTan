import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sptan/core/models/chat_data.dart';
import 'package:sptan/core/services/firestore_database.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/router_helper.dart';
import 'package:sptan/presentation/helper/shared.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/views/generate_chat_view.dart';
import 'package:sptan/presentation/widgets/chat_body_widget.dart';

import 'enter_password_view.dart';

class ChatView extends StatefulWidget {
  final String chatId;

  ChatView(this.chatId);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  Timer _timer;
  String endMessage;
  int durationInSecond = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future startTimer(BuildContext context) async {
    if (_timer == null || !_timer.isActive) {
      ChatData chatData = await FirestoreDatabase().getChatData(widget.chatId);
      if (chatData != null) {
        durationInSecond = chatData.duration;
        int past = 0;
        _timer = Timer.periodic(
          Duration(seconds: 1),
          (Timer timer) {
            if (durationInSecond == 0) {
              timer.cancel();
              RouterHelper.pushReplacement(context, GenerateChatView());
              FirestoreDatabase().removeChat(widget.chatId);
            } else {
              setState(() {
                if (durationInSecond == 30 ||
                    durationInSecond == 20 ||
                    durationInSecond == 10)
                  endMessage =
                      'Dieser Chat endet in $durationInSecond Sekunden';
                durationInSecond--;
              });
              past++;
              if (past == 10) {
                past = 0;
                FirestoreDatabase().editChatDuration(
                  duration: durationInSecond,
                  id: widget.chatId,
                );
              }
            }
          },
        );
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    startTimer(context);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    bool _isPickFile = Provider.of<Shared>(
      context,
      listen: false,
    ).isPickFile;
    if (state == AppLifecycleState.paused && !_isPickFile) {
            RouterHelper.push(context, EnterPasswordView(justPop: true),);
            print('=================> navigate <==================');
      // showModalBottomSheet(
      //   isScrollControlled: true,
      //   context: context,
      //   builder: (_) {
      //     return Padding(
      //       padding: const EdgeInsets.only(top: 25),
      //       child: EnterPasswordView(justPop: true),
      //     );
      //   },
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: scaffoldKey,
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
                        onTap: () {
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.white,
                              elevation: 6,
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Möchten Sie diesen Chat wirklich beenden?',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TSMuseoStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      RouterHelper.pushReplacement(
                                        context,
                                        EnterPasswordView(),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 5,
                                      ),
                                      child: Text(
                                        'Ja',
                                        style: TSMuseoStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: CCRed,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.close,
                          color: CCRed,
                          size: 30,
                        ),
                      ),
                    ),
                    if (endMessage != null)
                      Expanded(
                        child: Text(
                          endMessage,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: TSMuseoStyle.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
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
              ChatBodyWidget(chatID: widget.chatId),
            ],
          ),
        ),
      ),
    );
  }
}
