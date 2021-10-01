import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sfa/utility/colors.dart';
import 'ui/attendence_home/attendence_home_screen.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: colorPrimary,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SFA',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const SplashScreen(),





    );
  }
}
