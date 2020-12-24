import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseCloudStorage {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage({
    @required File image,
    @required String chatId,
  }) async {
    TaskSnapshot taskSnapshot = await storage
        .ref()
        .child('Images/$chatId/${image.path.split('/').last}-${DateTime.now()}')
        .putFile(image);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<String> uploadDocument({
    @required File document,
    @required String chatId,
  }) async {
    TaskSnapshot taskSnapshot = await storage
        .ref()
        .child(
            'Document/$chatId/${document.path.split('/').last}-${DateTime.now()}')
        .putFile(document);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}
