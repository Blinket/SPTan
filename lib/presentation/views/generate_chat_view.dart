import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sptan/core/helper/enums.dart';
import 'package:sptan/core/services/firestore_database.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/navigate_functions.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/helper/ui_helper.dart';
import 'package:sptan/presentation/views/chat_view.dart';
import 'package:sptan/presentation/views/enter_password_view.dart';
import 'package:sptan/presentation/widgets/button_widget.dart';
import 'package:sptan/presentation/widgets/chat_duration_dialog.dart';
import 'package:sptan/presentation/widgets/unaviable_code_dialog.dart';

class GenerateChatView extends StatefulWidget {
  @override
  _GenerateChatViewState createState() => _GenerateChatViewState();
}

class _GenerateChatViewState extends State<GenerateChatView>
    with WidgetsBindingObserver {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _chatCodedKey = GlobalKey<FormState>();

  Future<String> _generateChatFuture;
  String _code;

  Future<String> _generateCode() async {
    _code = await FirestoreDatabase().generateChat();
    return _code;
  }

  @override
  void initState() {
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
    Size size = MediaQuery.of(context).size;
    if (_requestPassword)
      return EnterPasswordView(() {
        setState(() {
          _requestPassword = false;
        });
      });
    else
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
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
                          'Geben Sie ihre erhaltene TAN ein, um diese abzufragen.',
                          textAlign: TextAlign.center,
                          style: TSMuseoStyle.copyWith(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (_generateChatFuture == null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 30),
                          child: Container(
                            height: 40,
                            child: Form(
                              key: _chatCodedKey,
                              child: TextFormField(
                                textAlign: TextAlign.left,
                                onChanged: (String value) {
                                  setState(() {
                                    _code = value;
                                  });
                                },
                                style: TSMuseoStyle.copyWith(height: 1.5),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                validator: (value) => value.isEmpty ? '' : null,
                                decoration: InputDecoration(
                                  //set counter style height to 9  for hide it
                                  counterText: '',
                                  counterStyle: TextStyle(height: 0),
                                  errorStyle: TextStyle(height: 0),
                                  hintText: 'TAN Eingeben',
                                  hintStyle: TSMuseoStyle.copyWith(
                                    color: Colors.grey,
                                    height: 1,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                  ),
                                  border: UIHelper.outlineInputBorder,
                                  focusedBorder: UIHelper.outlineInputBorder,
                                  enabledBorder: UIHelper.outlineInputBorder,
                                  disabledBorder: UIHelper.outlineInputBorder,
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red[400],
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_generateChatFuture != null)
                        FutureBuilder<String>(
                          future: _generateChatFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: UIHelper.HourGlassLoading,
                              );
                            if (snapshot.hasError) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 30),
                                  Icon(
                                    Icons.perm_scan_wifi_rounded,
                                    color: CCRed,
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    'Etwas ist schief gelaufen',
                                    textAlign: TextAlign.center,
                                    style: TSMuseoStyle,
                                  ),
                                  SizedBox(height: 15),
                                  FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        _generateChatFuture = _generateCode();
                                      });
                                    },
                                    child: Text(
                                      'Wiederholen.',
                                      style: TSMuseoStyle.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                ],
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 30),
                                  Text(
                                    snapshot.data,
                                    textAlign: TextAlign.center,
                                    style: TSRobotoBoldStyle.copyWith(
                                      fontSize: 35,
                                      color: CCRed,
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      FlutterClipboard.copy(snapshot.data);
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
                                                  'Die TAN wurde in die Zwischenablage kopiert!',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: TSMuseoStyle.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.done_all,
                                                color: Colors.green,
                                              ),
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
                                  SizedBox(height: 15),
                                ],
                              );
                            }
                          },
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: ButtonWidget(
                          onTap: () async {
                            if ((_generateChatFuture != null ||
                                    _chatCodedKey.currentState.validate()) &&
                                _code != null) {
                              UIHelper.showSpinLoading(context);
                              EnterChatEnum enterChatResult =
                                  await FirestoreDatabase().enterChat(_code);
                              if (enterChatResult == EnterChatEnum.goToChat)
                                Navigate.pushReplacement(
                                  context,
                                  ChatView(_code),
                                );
                              if (enterChatResult == EnterChatEnum.setDuration)
                                UIHelper.showDialogForME(
                                  context,
                                  ChatDurationDialog(_code),
                                );
                              if (enterChatResult ==
                                  EnterChatEnum.UnAvailableCode)
                                UIHelper.showDialogForME(
                                  context,
                                  UnAvailableCodeDialog(),
                                );
                            }
                          },
                          text: 'Abfragen',
                        ),
                      ),
                      if (_generateChatFuture == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                _generateChatFuture = _generateCode();
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
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                _generateChatFuture = null;
                              });
                            },
                            child: Text(
                              'TAN manuell Eingeben',
                              style: TSMuseoStyle.copyWith(
                                color: CCRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Container(),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
