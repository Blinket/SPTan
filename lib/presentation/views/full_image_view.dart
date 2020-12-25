import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/navigate_functions.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/views/chat_view.dart';
import 'enter_password_view.dart';

class FullImageView extends StatefulWidget {
  final File image;
  final String imageName;
  final String chatId;

  FullImageView({
    @required this.image,
    @required this.imageName,
    @required this.chatId,
  });

  @override
  _FullImageViewState createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    print('inistate');
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

  // bool _shareFile = false;

  @override
  Widget build(BuildContext context) {
    if (_requestPassword)
      return EnterPasswordView(() {
        setState(() {
          _requestPassword = false;
        });
      });
    else
      return WillPopScope(
        onWillPop: ()async{
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
                            [widget.image.path],
                            text: widget.imageName,
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
                  child: Center(
                    child: Image.file(
                      widget.image,
                      width: MediaQuery.of(context).size.width - 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
