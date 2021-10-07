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
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: colorPrimary,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Image.asset("assets/splash-triangle.png"),
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 200, 0, 0),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.48,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/logo.png"),
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 240,
                    decoration: BoxDecoration(
                        color: colorTabBG,
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Sales Force Automation",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
