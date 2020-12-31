import 'package:flutter/material.dart';
import 'package:sptan/core/models/user_data.dart';
import 'package:sptan/core/services/firestore_database.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/router_helper.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/helper/ui_helper.dart';
import 'package:sptan/presentation/views/generate_chat_view.dart';
import 'package:sptan/presentation/widgets/button_widget.dart';

class EnterPasswordView extends StatefulWidget {
  final bool justPop;
  final Function doAfterCorrectPass;

  EnterPasswordView({
    this.justPop = false,
    this.doAfterCorrectPass,
  });

  @override
  _EnterPasswordViewState createState() => _EnterPasswordViewState();
}

class _EnterPasswordViewState extends State<EnterPasswordView> {
  final _passwordKey = GlobalKey<FormState>();

  String _password = '';

  bool _hidePassword = true;
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                    Image.asset(
                      'assets/images/logo.png',
                      height: 50,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'SPTan',
                      textAlign: TextAlign.center,
                      style: TSRobotoBoldStyle.copyWith(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: Text(
                        'Geben Sie Ihr Passwort ein.',
                        textAlign: TextAlign.center,
                        style: TSMuseoStyle.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      child: Container(
                        height: 40,
                        child: Form(
                          key: _passwordKey,
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            onChanged: (String value) {
                              setState(() {
                                _password = value;
                                _showError = false;
                              });
                            },
                            style: TSMuseoStyle.copyWith(height: 1.5),
                            textInputAction: TextInputAction.done,
                            validator: (value) => value.isEmpty ? '' : null,
                            obscureText: _hidePassword,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                },
                                child: Icon(
                                  _hidePassword
                                      ? Icons.remove_red_eye
                                      : Icons.remove_red_eye_outlined,
                                  color:
                                      _hidePassword ? CCRed : Colors.grey[700],
                                ),
                              ),
                              //set counter style height to 9  for hide it
                              counterText: '',
                              counterStyle: TextStyle(height: 0),
                              errorStyle: TextStyle(height: 0),
                              hintText: 'Passwort Eingeben',
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
                    if (_showError)
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 40,
                          left: 40,
                          bottom: 30,
                        ),
                        child: Text(
                          'Falsches Passwort, bitte versuchen Sie es erneut mit dem Passwort, das Sie zu Beginn festgelegt haben.',
                          textAlign: TextAlign.center,
                          style: TSMuseoStyle.copyWith(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: ButtonWidget(
                        onTap: () async {
                          if (_passwordKey.currentState.validate()) {
                            UIHelper.showSpinLoading(context);
                            UserData userData =
                                await FirestoreDatabase().getCurrentUserData();
                            if (userData.password == _password) {
                              if (widget.doAfterCorrectPass != null)
                                widget.doAfterCorrectPass();
                              else if (widget.justPop) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } else
                                RouterHelper.pushReplacement(
                                  context,
                                  GenerateChatView(),
                                );
                            } else {
                              setState(() {
                                _showError = true;
                              });
                              Navigator.pop(context);
                            }
                          }
                        },
                        text: 'Bestätigen',
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
