import 'package:flutter/material.dart';
import 'package:sptan/presentation/helper/navigate_functions.dart';
import 'package:sptan/presentation/helper/text_styles.dart';
import 'package:sptan/presentation/views/chat_code_view.dart';
import 'package:sptan/presentation/widgets/button_widget.dart';

class SetPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
                      hintText: 'Passwort Eingeben',
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
                  onTap: () => Navigate.push(context, ChatCodeView(),),
                  text: 'Festelegen',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
