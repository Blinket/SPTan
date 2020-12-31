

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';
import 'presentation/views/splash_view.dart';



main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      builder: (context, child) => SecureApplication(
        nativeRemoveDelay: 800,
        child: child,
      ),
      home: SplashView(),
    );
  }
}
