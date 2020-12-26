import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share/share.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/navigate_functions.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/views/chat_view.dart';
import 'enter_password_view.dart';

class FullImageView extends StatefulWidget {
  final String url;
  final String chatId;

  FullImageView({
    @required this.url,
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
        onWillPop: () async {
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
                          File file = await DefaultCacheManager()
                              .getSingleFile(widget.url);
                          await Share.shareFiles(
                            [file.path],
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
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
                      placeholder: (context, url) => Center(
                        child: SpinKitDoubleBounce(
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
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
