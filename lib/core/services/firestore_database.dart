import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sptan/core/helper/enums.dart';
import 'package:sptan/core/helper/keys.dart';
import 'package:sptan/core/models/chat_data.dart';
import 'package:sptan/core/models/massage_data.dart';
import 'package:sptan/core/models/user_data.dart';
import 'package:sptan/core/services/firebase_storage.dart';

import 'device_info.dart';
import 'firebase_auth.dart';

class FirestoreDatabase extends ChangeNotifier {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Keys.Users);
  CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection(Keys.Chats);

  Stream<DocumentSnapshot> chatDataStream(String id) =>
      chatsCollection.doc(id).snapshots();

  //======= User Data
  //
  // Stream<DocumentSnapshot> userDataStream() {
  //   String uid = FirebaseAuthentication().getUserId();
  //   return firestore.doc(FirestorePaths.user(uid)).snapshots();
  // }

  Future<UserData> getCurrentUserData() async {
    String uid = FirebaseAuthentication().getUserId();
    DocumentSnapshot documentSnapshot = await usersCollection.doc(uid).get();
    Map<String, dynamic> userDataMap = documentSnapshot.data();
    UserData userData = UserData(
      uid: documentSnapshot.id,
      deviceId: userDataMap[Keys.UserDeviseId],
      password: userDataMap[Keys.UserPassword],
      openedChatID: userDataMap[Keys.UserOpenChatId],
    );
    return userData;
  }

  Future<bool> setUserData(String password) async {
    try {
      String uid = await FirebaseAuthentication().signInAnonymously();
      String deviceId = await DeviceInfo().getDeviceId();
      Map data = UserData(
        uid: uid,
        deviceId: deviceId,
        password: password,
        openedChatID: null,
      ).toMap();
      await usersCollection.doc(uid).set(data);
      return true;
    } catch (e) {
      print('============> setUserData error: $e');
      await FirebaseAuthentication().logOut();
      return false;
    }
  }

  //============ chat data

  Future<EnterChatEnum> enterChat(String id) async {
    String uid = FirebaseAuthentication().getUserId();
    ChatData chatData = await FirestoreDatabase().getChatData(id);
    if (chatData != null) {
      bool validChat = DateTime.parse(chatData.createdIN).difference(
            DateTime.now(),
          ) >
          Duration(days: -1);
      print('=========> valid chat $validChat');
      if (((chatData.firstUserID == uid || chatData.secondUserID == uid) ||
              chatData.secondUserID == null) &&
          validChat) {
        if (chatData.secondUserID == null && chatData.firstUserID != uid)
          await chatsCollection.doc(id).update(
            {
              Keys.ChatSecondUserID: uid,
            },
          );
        if (chatData.duration == null)
          return EnterChatEnum.setDuration;
        else
          return EnterChatEnum.goToChat;
      } else
        return EnterChatEnum.UnAvailableCode;
    } else
      return EnterChatEnum.UnAvailableCode;
  }

  Future setChatDuration({
    @required int duration,
    @required String id,
  }) async {
    await chatsCollection.doc(id).update({
      Keys.ChatDuration: duration,
      Keys.ChatStartIn: DateTime.now().toString(),
    });
  }

  Future editChatDuration({
    @required int duration,
    @required String id,
  }) async {
    await chatsCollection.doc(id).update({
      Keys.ChatDuration: duration,
    });
  }

  Future<ChatData> getChatData(String chatId) async {
    DocumentSnapshot documentSnapshot = await chatsCollection.doc(chatId).get();
    if (documentSnapshot != null && documentSnapshot.exists) {
      Map<String, dynamic> chatDataMap = documentSnapshot.data();
      ChatData chatData = ChatData(
        id: documentSnapshot.id,
        startIN: chatDataMap[Keys.ChatStartIn],
        createdIN: chatDataMap[Keys.ChatCreatedIN],
        duration: chatDataMap[Keys.ChatDuration],
        firstUserID: chatDataMap[Keys.ChatFirstUserID],
        secondUserID: chatDataMap[Keys.ChatSecondUserID],
      );
      return chatData;
    } else
      return null;
  }

  Future<String> generateChat() async {
    String uid = await FirebaseAuthentication().signInAnonymously();
    Random random = Random();
    int generated;
    bool freeCode = false;
    while (!freeCode) {
      generated = random.nextInt(900000) + 100000;
      DocumentSnapshot documentSnapshot = await chatsCollection
          .doc(
            generated.toString(),
          )
          .get();
      if (documentSnapshot.exists) {
        String createdIN = documentSnapshot.data()[Keys.ChatCreatedIN];

        bool isExpired = DateTime.parse(createdIN).difference(DateTime.now()) <
                Duration(days: -1) ||
            documentSnapshot.data()[Keys.ChatDuration] == null ||
            documentSnapshot.data()[Keys.ChatDuration] == 0;
        freeCode = isExpired;
      } else
        freeCode = true;
    }
    await chatsCollection.doc(generated.toString()).set(
          ChatData(
            id: generated.toString(),
            createdIN: DateTime.now().toString(),
            startIN: null,
            duration: null,
            firstUserID: uid,
            secondUserID: null,
          ).toMap(),
        );
    return generated.toString();
  }

  Future setChatData(ChatData chatData) async {
    await chatsCollection.doc(chatData.id).set(chatData.toMap());
  }

  Future removeChat(String id) async {
    await chatsCollection.doc(id).delete();
  }

//============ message data

  Stream<QuerySnapshot> messagesStream(chatID) =>
      chatsCollection.doc(chatID).collection(Keys.Messages).snapshots();

  Future sendMessage({
    @required int length,
    @required String type,
    @required String chatID,
    @required dynamic content,
  }) async {
    String _finalContent;
    String uid = FirebaseAuthentication().getUserId();
    if (type == Keys.TextMessage) _finalContent = content;
    if (type == Keys.ImageMessage) {
      _finalContent = await FirebaseCloudStorage().uploadImage(
        image: content,
        chatId: chatID,
      );
    }
    if (type == Keys.PDfMessage) {
      _finalContent = await FirebaseCloudStorage().uploadDocument(
        document: content,
        chatId: chatID,
      );
    }
    await chatsCollection
        .doc(chatID)
        .collection(Keys.Messages)
        .doc(length.toString())
        .set(
          MessageData(
            fileName:
                type != Keys.TextMessage ? content.path.split('/').last : '',
            senderID: uid,
            content: _finalContent,
            type: type,
            sentIN: DateTime.now().toString(),
          ).toMap(),
        );
  }
}
