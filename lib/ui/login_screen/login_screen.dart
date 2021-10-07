import 'package:flutter/material.dart';
import 'package:sfa/ui/home_screen/home_screen.dart';
import 'package:sfa/utility/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    "assets/login-banner.png",
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 280),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            color: colorGrayDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 2,
                  width: 40,
                  decoration: BoxDecoration(
                      color: colorGrayDark,
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  "Please sign in to continue",
                  style: TextStyle(
                      color: colorGrayDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
                child: TextFormField(
                  style: const TextStyle(
                      color: colorGrayDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                  autocorrect: true,
                  enableSuggestions: true,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixText: "   ",
                    filled: true,
                    fillColor: colorGrayLite,
                    border: InputBorder.none,
                    hintText: "Mobile Number",
                    hintStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: colorGray),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Colors.transparent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Colors.transparent, width: 2.0),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                child: TextFormField(
                  style: const TextStyle(
                      color: colorGrayDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                    prefixText: "   ",
                    filled: true,
                    fillColor: colorGrayLite,
                    border: InputBorder.none,
                    hintText: "Password",
                    hintStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: colorGray),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Colors.transparent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Colors.transparent, width: 2.0),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 25, 0),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: const Text(
                    "Forgot Password ?",
                    style: TextStyle(
                        color: colorGrayDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => const HomeScreen()));
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(220, 60)),
                    backgroundColor: MaterialStateProperty.all(colorPrimary),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
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
