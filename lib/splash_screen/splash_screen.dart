import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sfa/login_screen/login_screen.dart';
import 'package:sfa/utility/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen())));
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Image.asset("assets/splash-triangle.png"),
                Container(
                  margin: const EdgeInsets.fromLTRB(40, 200, 0, 0),
                  height: 100,
                  width: 180,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/logo.png"),
                  )),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 120, 0, 0),
            alignment: Alignment.center,
            height: 45,
            width: 240,
            decoration: BoxDecoration(
                color: colorTabBG, borderRadius: BorderRadius.circular(50)),
            child: const Text(
              "Sales Force Automation",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          )
        ],
      ),
    );
  }
}
