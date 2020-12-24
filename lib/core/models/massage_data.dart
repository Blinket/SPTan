import 'package:flutter/cupertino.dart';
import 'package:sptan/core/helper/keys.dart';

class MessageData {
  final String senderID;
  final String content;
  final String type;
  final String sentIN;

  MessageData({
    @required this.senderID,
    @required this.content,
    @required this.type,
    @required this.sentIN,
  });

  Map<String, dynamic> toMap() {
    return {
      Keys.MessageContent: content,
      Keys.MessageSenderId: senderID,
      Keys.MessageSentIN: sentIN,
      Keys.MessageType: type,
    };
  }
}
