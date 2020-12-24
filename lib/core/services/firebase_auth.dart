import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> signInAnonymously() async {
    UserCredential userCredential = await auth.signInAnonymously();
    return userCredential.user.uid;
  }

  String getUserId() => auth.currentUser.uid;
  User getCurrentUser() => auth.currentUser;

  Future logOut()async=> await auth.signOut();
}
