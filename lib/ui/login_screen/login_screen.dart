import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sfa/ui/home_screen/home_screen.dart';
import 'package:sfa/ui/login_screen/login_bloc/login_bloc.dart';
import 'package:sfa/ui/login_screen/login_bloc/login_event.dart';
import 'package:sfa/ui/login_screen/login_bloc/login_state.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/shared_prefrence.dart';

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
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccessState) {
            SharedPrefrence.setStringPreference(
                "mobile_number", mobileNumber.toString());

            SharedPrefrence.setStringPreference(
                "password", password.toString());

            SharedPrefrence.setStringPreference(
                "id", state.loginResponse.id.toString());

            SharedPrefrence.setBooleanPreference(
                "login", state.loginResponse.success);

            SharedPrefrence.setStringPreference(
                "token", state.loginResponse.accessToken.toString());

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()));

            Fluttertoast.showToast(msg: state.loginResponse.message.toString());
          }
          if (state is LoginFailureState) {
            Fluttertoast.showToast(msg: state.message.toString());
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/login-banner.png",
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width,
                    ),
                    const Positioned(
                      bottom: -6,
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
                      controller: mobileNumber,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                      autocorrect: true,
                      enableSuggestions: true,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: "   ",
                        filled: true,
                        fillColor: colorGrayLite,
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
                        fillColor: colorGrayLite,
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
                InkWell(
                  onTap: () {},
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 25, 0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: const Text(
                          "Forgot Password ?",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                        child: ElevatedButton(
                          onPressed: () {
                            sendLoginData(context, mobileNumber.text.toString(),
                                password.text.toString());
                          },
                          style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(220, 60)),
                            backgroundColor:
                                MaterialStateProperty.all(colorPrimary),
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
                    );
                  },
                ),
              ],
            ),
          ),
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
    RegExp regxPassword =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (mobileNumber.isEmpty && password.isEmpty) {
      Fluttertoast.showToast(msg: "Field can't be Empty");
    } else if (mobileNumber.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Mobile Number");
    } else if (!regxMobile.hasMatch(mobileNumber)) {
      Fluttertoast.showToast(msg: "Mobile number must be 10 digits");
    } else if (password.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Password");
    }
    // else if (!regxPassword.hasMatch(password)) {
    //   Fluttertoast.showToast(msg: "Please enter Valid Password");
    // }
    else {
      log("Login Event Call");
      BlocProvider.of<LoginBloc>(context).add(
        LoginEvent(mobileNumber: mobileNumber, password: password),
      );
    }
  }
}
