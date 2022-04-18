import 'package:dms/ui/drawer_screen/drawer_screen.dart';
import 'package:dms/ui/login_screen/login_bloc/login_bloc.dart';
import 'package:dms/ui/login_screen/login_bloc/login_event.dart';
import 'package:dms/ui/login_screen/login_bloc/login_state.dart';
import 'package:dms/ui/screen_after_login/screen_after_login.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final mobileNumber = TextEditingController();
  final password = TextEditingController();
  String startMyDay = "";

  LoginBloc loginBloc = LoginBloc();
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        bloc: loginBloc,
        listener: (context, state) async {
          if (state is LoginSuccessState) {
            SharedPreference.setStringPreference(SharedPreference.mobileNumber, mobileNumber.toString());

            SharedPreference.setStringPreference(SharedPreference.userId, state.data.id.toString());

            SharedPreference.setBooleanPreference(SharedPreference.isLogin, true);

            SharedPreference.setBooleanPreference(SharedPreference.isLeader, state.data.isLeader);

            SharedPreference.setStringPreference(SharedPreference.accessToken, state.data.accessToken);

            SharedPreference.setStringPreference(
                SharedPreference.fromDate, DateFormat("yyyy-MM-dd").format(state.data.pjpButton.fromDate));
            SharedPreference.setStringPreference(
                SharedPreference.toDate, DateFormat("yyyy-MM-dd").format(state.data.pjpButton.toDate));

            if (state.data.pjpButton.addPjpButton == 1) {
              SharedPreference.setBooleanPreference(SharedPreference.showAddPlanButton, true);
            } else {
              SharedPreference.setBooleanPreference(SharedPreference.showAddPlanButton, false);
            }
            Constants.token = "Bearer " + state.data.accessToken;
            dio.options.headers.addAll({
              "Authorization": Constants.token,
            });

            Constants.leader = state.data.isLeader;
            startMyDay = state.data.startMyDay;
            SharedPreference.setStringPreference(SharedPreference.startMyDay, state.data.startMyDay);

            loginBloc.add(GetUserEvent());
          }

          if (state is GetUserDetailsState) {
            SharedPreference.setStringPreference(SharedPreference.name, state.userDetails.data!.name);
            SharedPreference.setStringPreference(SharedPreference.mobileNumber, state.userDetails.data!.mobileNumber);
            SharedPreference.setStringPreference(SharedPreference.email, state.userDetails.data!.email);
            SharedPreference.setStringPreference(SharedPreference.userDesignation, state.userDetails.data!.designation);
            SharedPreference.setStringPreference(SharedPreference.userImage, state.userDetails.data!.image);

            Constants.name = state.userDetails.data!.name;
            Constants.mobile = state.userDetails.data!.mobileNumber;
            Constants.designation = state.userDetails.data!.designation;
            Constants.email = state.userDetails.data!.email;
            Constants.image = state.userDetails.data!.image;

            if (startMyDay == "hide") {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DrawerScreen()));
            } else {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const ScreenAfterLogin()));
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const ScreenAfterLogin()));
            }
          }
          if (state is LoginFailureState) {
            Utility.showToast(state.message);
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
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
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
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      "Please sign in to continue",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
                    child: TextFormField(
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        RenderObject? object = globalKey.currentContext!.findRenderObject();
                        object!.showOnScreen();
                      },
                      maxLength: 10,
                      controller: mobileNumber,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                      autocorrect: true,
                      cursorColor: Colors.red,
                      enableSuggestions: true,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                    child: TextFormField(
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        RenderObject? object = globalKey.currentContext!.findRenderObject();
                        object!.showOnScreen();
                      },
                      controller: password,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                      obscureText: true,
                      enableSuggestions: false,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      autocorrect: false,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        contentPadding: EdgeInsets.all(15),
                        hintStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return Center(
                      child: Padding(
                        key: globalKey,
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
                        child: ElevatedButton(
                          onPressed: () {
                            Utility.hideKeyboard();
                            sendLoginData(context, mobileNumber.text.toString(), password.text.toString());
                            // Navigator.of(context).pushReplacement(
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) =>
                            //         const ScreenAfterLogin(),
                            //   ),
                            // );
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(220, 60)),
                            backgroundColor: MaterialStateProperty.all(MColor.colorPrimary),
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
                              fontWeight: FontWeight.bold,
                            ),
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
      Utility.showToast("Field can't be Empty");
    } else if (mobileNumber.isEmpty) {
      Utility.showToast("Please enter Mobile Number");
    } else if (!regxMobile.hasMatch(mobileNumber)) {
      Utility.showToast("Mobile number must be 10 digits");
    } else if (password.isEmpty) {
      Utility.showToast("Please enter Password");
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
