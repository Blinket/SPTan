import 'package:flutter/cupertino.dart';
import 'package:sptan/core/helper/keys.dart';

class UserData {
  final String uid;
  final String deviceId;
  final String password;
  final String openedChatID;

  UserData({
    @required this.uid,
    @required this.deviceId,
    @required this.password,
    @required this.openedChatID,
  });

  Map<String, dynamic> toMap() {
    return {
      Keys.UserOpenChatId: openedChatID,
      Keys.UserDeviseId: deviceId,
      Keys.UserPassword: password,
      Keys.UserID: uid,
    };
  }
}
