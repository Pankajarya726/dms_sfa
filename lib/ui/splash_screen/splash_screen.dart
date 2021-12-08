import 'dart:async';

import 'package:dms/ui/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
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

  logoutDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(25, 11, 25, 11),
          title: const Text("Something Wrong!", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600)),
          content: const Text("Please check your internet and try again.",
              style: TextStyle(color: Color.fromRGBO(85, 85, 85, 1), fontSize: 16, fontWeight: FontWeight.w500)),
          actions: [
            MaterialButton(
              child: const Text("Retry", style: TextStyle(fontSize: 16, color: Color(0xfff4511e), fontWeight: FontWeight.w600)),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
