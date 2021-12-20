import 'package:dms/ui/drawer_screen/drawer_screen.dart';
import 'package:dms/ui/login_screen/login_bloc/login_bloc.dart';
import 'package:dms/ui/login_screen/login_bloc/login_event.dart';
import 'package:dms/ui/login_screen/login_bloc/login_state.dart';
import 'package:dms/ui/screen_after_login/screen_after_login.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
            SharedPreference.setStringPreference(
                "mobile_number", mobileNumber.toString());

            SharedPreference.setStringPreference(
                "id", state.loginResponse.id.toString());

            SharedPreference.setBooleanPreference(
                "login", state.loginResponse.success);

            SharedPreference.setBooleanPreference(
                "is_Leader", state.loginResponse.isLeader);

            if (state.loginResponse.startMyDay == "hide") {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DrawerScreen()));
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const ScreenAfterLogin()));
            }

            Fluttertoast.showToast(msg: state.loginResponse.message.toString());
          }
          if (state is LoginFailureState) {
            Fluttertoast.showToast(msg: state.message);
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
                      "assets/login-banner1.png",
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
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      autocorrect: false,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        contentPadding: EdgeInsets.all(15),
                        hintStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
                        child: ElevatedButton(
                          onPressed: () {
                            sendLoginData(context, mobileNumber.text.toString(),
                                password.text.toString());
                            // Navigator.of(context).pushReplacement(
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) =>
                            //         const ScreenAfterLogin(),
                            //   ),
                            // );
                          },
                          style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(220, 60)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
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
    // RegExp regxPassword =
    //     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
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
      BlocProvider.of<LoginBloc>(context).add(
        LoginEvent(mobileNumber: mobileNumber, password: password),
      );
    }
  }
}
