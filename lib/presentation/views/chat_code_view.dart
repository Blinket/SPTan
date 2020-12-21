import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/helper/ui_helper.dart';
import 'package:sptan/presentation/widgets/button_widget.dart';
import 'package:sptan/presentation/widgets/chat_duration_dialog.dart';

class ChatCodeView extends StatefulWidget {
  @override
  _ChatCodeViewState createState() => _ChatCodeViewState();
}

class _ChatCodeViewState extends State<ChatCodeView> {
  int generatedCode;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                child: Center(
                  child: Hero(
                    tag: 'logo',
                    child: Text(
                      'SPTan',
                      style: TSRobotoBoldStyle.copyWith(
                        color: CCRed,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'TAN Eingeben',
                    textAlign: TextAlign.center,
                    style: TSRobotoBoldStyle.copyWith(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: Text(
                      'Geben Sie die erhaltene TAN ein um diesen Abzufragen.',
                      textAlign: TextAlign.center,
                      style: TSMuseoStyle.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[600],
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.left,
                        onChanged: (String value) {},
                        style: TSMuseoStyle,
                        textInputAction: TextInputAction.done,
                        validator: (value) => value.isEmpty ? '' : null,
                        decoration: InputDecoration(
                          //set counter style height to 9  for hide it
                          counterText: '',
                          counterStyle: TextStyle(height: 0),
                          errorStyle: TextStyle(height: 0),
                          hintText: 'TAN Eingeben',
                          hintStyle: TSMuseoStyle.copyWith(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14.5,
                            horizontal: 30,
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: ButtonWidget(
                      onTap: () => UIHelper.showDialogForME(
                          context, ChatDurationDialog()),
                      text: 'Abfragen',
                    ),
                  ),
                  if (generatedCode == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: FlatButton(
                        onPressed: () {
                          Random random = Random();
                          setState(() {
                            generatedCode = random.nextInt(900000) + 100000;
                          });
                        },
                        child: Text(
                          'TAN Generieren',
                          style: TSMuseoStyle.copyWith(
                            color: CCRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          generatedCode.toString(),
                          textAlign: TextAlign.center,
                          style: TSRobotoBoldStyle.copyWith(
                            fontSize: 35,
                            color: CCRed,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            FlutterClipboard.copy(generatedCode.toString());
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.white,
                                elevation: 6,
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Der TAN wurde in die Zwischenablage kopiert!',
                                      style: TSMuseoStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Kopieren',
                            style: TSMuseoStyle.copyWith(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
