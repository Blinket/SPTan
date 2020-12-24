import 'package:flutter/cupertino.dart';
import 'package:sptan/core/helper/keys.dart';

class ChatData {
  final String id;
  final String startIN;
  final String createdIN;
  final int duration;
  final String firstUserID;
  final String secondUserID;

  ChatData({
    @required this.id,
    @required this.startIN,
    @required this.createdIN,
    @required this.duration,
    @required this.firstUserID,
    @required this.secondUserID,
  });


  Map<String, dynamic> toMap() {
    return {
      Keys.ChatId: id,
      Keys.ChatStartIn: startIN,
      Keys.ChatCreatedIN: createdIN,
      Keys.ChatDuration:duration,
      Keys.ChatFirstUserID:firstUserID,
      Keys.ChatSecondUserID:secondUserID,
    };
  }
}
