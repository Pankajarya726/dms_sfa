import 'package:flutter/material.dart';

class ScreenAfterLogin extends StatefulWidget {
  const ScreenAfterLogin({Key? key}) : super(key: key);

  @override
  _ScreenAfterLoginState createState() => _ScreenAfterLoginState();
}

class _ScreenAfterLoginState extends State<ScreenAfterLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // boxLayout("assets/sun.png", "START MY DAY", 60, 25),
                Container(
                  padding: const EdgeInsets.fromLTRB(70, 40, 70, 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/sun.png",
                        width: 60,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        "START MY DAY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(70, 40, 70, 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/explore.png",
                        width: 50,
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      const Text(
                        "START MY DAY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/vypar_vistar_logo.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget boxLayout(imageIconPath, imageLabel, imageWidth, sizedBoxWidth) {
    return Container(
      padding: const EdgeInsets.fromLTRB(70, 40, 70, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            "assets/explore.png",
            width: 50,
          ),
          const SizedBox(
            height: 28,
          ),
          const Text(
            "START MY DAY",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
