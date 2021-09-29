import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sfa/splash_screen.dart';

void main() {
  runApp(const MyApp());
  // SystemChrome.setSystemUIOverlayStyle();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const SplashScreen(),
    );
  }
}
