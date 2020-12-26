import 'package:flutter/material.dart';
import 'package:sptan/core/services/firestore_database.dart';
import 'package:sptan/presentation/helper/colors.dart';
import 'package:sptan/presentation/helper/navigate_functions.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/helper/ui_helper.dart';
import 'package:sptan/presentation/views/enter_password_view.dart';
import 'package:sptan/presentation/widgets/button_widget.dart';
import 'package:sptan/presentation/widgets/error_dialog.dart';

class SetPasswordView extends StatefulWidget {
  @override
  _SetPasswordViewState createState() => _SetPasswordViewState();
}

class _SetPasswordViewState extends State<SetPasswordView> {
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();

  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();

  String _password = '';
  String _confirmPassword = '';

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: size.width,
          child: Column(
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
                  'Legen Sie ein Passwort fest um TANS Empfangen zu können.',
                  textAlign: TextAlign.center,
                  style: TSMuseoStyle.copyWith(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
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
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.next,
                      focusNode: _passwordNode,
                      onFieldSubmitted: (val) {
                        _passwordNode.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_confirmPasswordNode);
                      },
                      validator: (value) => value.isEmpty ? '' : null,
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
                            color: _hidePassword ? CCRed : Colors.grey[700],
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
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: 40,
                  child: Form(
                    key: _confirmPasswordKey,
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      onChanged: (String value) {
                        setState(() {
                          _confirmPassword = value;
                          _showError = false;
                        });
                      },
                      style: TSMuseoStyle.copyWith(height: 1.5),
                      focusNode: _confirmPasswordNode,
                      textInputAction: TextInputAction.done,
                      validator: (value) => value.isEmpty ? '' : null,
                      obscureText: _hideConfirmPassword,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _hideConfirmPassword = !_hideConfirmPassword;
                            });
                          },
                          child: Icon(
                            _hideConfirmPassword
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined,
                            color:
                                _hideConfirmPassword ? CCRed : Colors.grey[700],
                          ),
                        ),
                        //set counter style height to 9  for hide it
                        counterText: '',
                        counterStyle: TextStyle(height: 0),
                        errorStyle: TextStyle(height: 0),
                        hintText: 'Kennwort bestätigen',
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
                    top: 30,
                  ),
                  child: Text(
                    'Passwort und Passwort bestätigen stimmen nicht überein.',
                    textAlign: TextAlign.center,
                    style: TSMuseoStyle.copyWith(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: ButtonWidget(
                  onTap: () async {
                    if (_passwordKey.currentState.validate() &&
                        _confirmPasswordKey.currentState.validate()) {
                      if (_password == _confirmPassword) {
                        UIHelper.showSpinLoading(context);
                        await FirestoreDatabase()
                            .setUserData(_password)
                            .then((value) {
                          if (value)
                            Navigate.pushReplacement(
                              context,
                              EnterPasswordView(null),
                            );
                          else
                            UIHelper.showDialogForME(
                              context,
                              ErrorDialog(),
                            );
                        });
                      } else {
                        setState(() {
                          _showError = true;
                        });
                      }
                    }
                  },
                  text: 'Festlegen',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
