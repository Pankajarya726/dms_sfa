import 'package:dms/ui/drawer_screen/drawer_screen.dart';
import 'package:dms/ui/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final mobileNumber = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/3x/login-banner.png",
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                ),
                const Positioned(
                  bottom: -5,
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  height: 2,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.black,
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
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
                child: TextFormField(
                  maxLength: 12,
                  controller: mobileNumber,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                  autocorrect: true,
                  cursorColor: Colors.red,
                  enableSuggestions: true,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    counterText: "",
                    prefixText: "   ",
                    filled: true,
                    fillColor: Colors.grey,
                    border: InputBorder.none,
                    hintText: "Mobile Number",
                    hintStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
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
                  controller: password,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                    prefixText: "   ",
                    filled: true,
                    fillColor: Colors.grey,
                    border: InputBorder.none,
                    hintText: "Password",
                    hintStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
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
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
                child: ElevatedButton(
                  onPressed: () {
                    sendLoginData(context, mobileNumber.text.toString(),
                        password.text.toString());
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const DrawerScreen(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(220, 60)),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
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
            ),
          ],
        ),
      ),
    );
  }

  sendLoginData(
    BuildContext context,
    String mobileNumber,
    String password,
  ) {
    RegExp regxMobile = RegExp(r'(^[0-9]{10}$)');
    // RegExp regxPassword =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (mobileNumber.isEmpty && password.isEmpty) {
      // Fluttertoast.showToast(msg: "Field can't be Empty");
    } else if (mobileNumber.isEmpty) {
      // Fluttertoast.showToast(msg: "Please enter Mobile Number");
    } else if (!regxMobile.hasMatch(mobileNumber)) {
      // Fluttertoast.showToast(msg: "Mobile number must be 10 digits");
    } else if (password.isEmpty) {
      // Fluttertoast.showToast(msg: "Please enter Password");
    }
    // else if (!regxPassword.hasMatch(password)) {
    //   Fluttertoast.showToast(msg: "Please enter Valid Password");
    // }
    else {
      // BlocProvider.of<LoginBloc>(context).add(
      //   LoginEvent(mobileNumber: mobileNumber, password: password),
      // );
    }
  }
}
