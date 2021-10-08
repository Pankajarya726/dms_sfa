import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sfa/ui/login_screen/login_screen.dart';
import 'package:sfa/utility/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // Timer(
    //   const Duration(seconds: 3),
    //   () => Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => const LoginScreen(),
    //     ),
    //   ),
    // );
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Image.asset(
                  "assets/splash-triangle.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: colorTabBG, borderRadius: BorderRadius.circular(50)),
                child: const Text(
                  "Sales Force Automation",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
