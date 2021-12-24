import 'dart:async';

import 'package:dms/ui/drawer_screen/drawer_screen.dart';
import 'package:dms/ui/login_screen/login_screen.dart';
import 'package:dms/ui/screen_after_login/screen_after_login.dart';
import 'package:dms/ui/splash_screen/splash_bloc/splash_bloc.dart';
import 'package:dms/ui/splash_screen/splash_bloc/splash_event.dart';
import 'package:dms/ui/splash_screen/splash_bloc/splash_state.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashBloc splashBloc = SplashBloc();

  @override
  void initState() {
    super.initState();
    addEvent();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => splashBloc,
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashSuccessState) {
            if (state.response.data!.pjpButton == "hide") {
              SharedPreference.setBooleanPreference(SharedPreference.pjpButton, false);
            } else {
              SharedPreference.setBooleanPreference(SharedPreference.pjpButton, true);
            }
            nextPage(state.response.data!.startMyDay, context);
          }
          if (state is SplashFailureState) {
            if (state.response.data!.pjpButton == "hide") {
              SharedPreference.setBooleanPreference(SharedPreference.pjpButton, false);
            } else {
              SharedPreference.setBooleanPreference(SharedPreference.pjpButton, true);
            }
            showUpdateAlert(
              context,
              state.response.data!.isMandatory,
              state.response.data!.startMyDay,
            );
          }
          if (state is SplashNetworkState) {
            logoutDialog(context);
          }
        },
        child: Scaffold(
          backgroundColor: MColor.colorRed,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: Image.asset(
                      "assets/splash-triangle.webp",
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
                    decoration: BoxDecoration(color: MColor.colorTabBG, borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Sales Force Automation",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addEvent() async {
    splashBloc.add(ValidateAppEvent());
  }

  logoutDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          title: const Text("Something Wrong!", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600)),
          content: const Text("Please check your internet and try again.",
              style: TextStyle(color: Color.fromRGBO(85, 85, 85, 1), fontSize: 16, fontWeight: FontWeight.w500)),
          actions: [
            MaterialButton(
              child: const Text("Retry", style: TextStyle(fontSize: 16, color: Color(0xfff4511e), fontWeight: FontWeight.w600)),
              onPressed: () {
                addEvent();
              },
            ),
          ],
        );
      },
    );
  }

  void showUpdateAlert(
    BuildContext mcontext,
    int isMandatory,
    String startMyDay,
  ) async {
    return showDialog(
      context: mcontext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
          title: const Text("SFA", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
          content: const Text("You are using older version of this app. Please update the app for batter experience.",
              style: TextStyle(color: Color.fromRGBO(85, 85, 85, 1), fontSize: 15, fontWeight: FontWeight.w500)),
          actions: [
            isMandatory != 1
                ? MaterialButton(
                    child: const Text("Later", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                    onPressed: () {
                      Navigator.pop(context);
                      nextPage(startMyDay, mcontext);
                    },
                  )
                : Container(),
            MaterialButton(
              child: const Text("Update", style: TextStyle(color: Color(0xfff4511e), fontWeight: FontWeight.w600)),
              onPressed: () async {
                Navigator.pop(context);
                StoreRedirect.redirect(androidAppId: "com.vvapps.dms").then((value) {
                  nextPage(startMyDay, mcontext);
                });
              },
            ),
          ],
        );
      },
    );
  }

  nextPage(String startMyDay, BuildContext context) async {
    bool login = await SharedPreference.getBooleanPreference(SharedPreference.isLogin);
    if (login) {
      Constants.name = await SharedPreference.getStringPreference(SharedPreference.name);
      Constants.mobile = await SharedPreference.getStringPreference(
        SharedPreference.mobileNumber,
      );
      Constants.designation = await SharedPreference.getStringPreference(
        SharedPreference.userDesignation,
      );
      Constants.email = await SharedPreference.getStringPreference(
        SharedPreference.email,
      );
      Constants.image = await SharedPreference.getStringPreference(
        SharedPreference.userImage,
      );
      Constants.leader = await SharedPreference.getBooleanPreference(SharedPreference.isLeader);
      Constants.token = "Bearer " + await SharedPreference.getStringPreference(SharedPreference.accessToken);
      dio.options.headers.addAll({"Authorization": Constants.token});

      if (startMyDay == "show") {
        Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => const ScreenAfterLogin(),
            ),
          ),
        );
      } else {
        Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => const DrawerScreen(),
            ),
          ),
        );
      }
    } else {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen(),
          ),
        ),
      );
    }
  }
}
