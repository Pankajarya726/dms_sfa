import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:sfa/ui/home_screen/home_screen.dart';
import 'package:sfa/ui/login_screen/login_screen.dart';
import 'package:sfa/ui/splash_screen/splash_bloc/splash_bloc.dart';
import 'package:sfa/ui/splash_screen/splash_bloc/splash_event.dart';
import 'package:sfa/ui/splash_screen/splash_bloc/splash_state.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

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
            getLogin(state.response.data!.appVersion);
          }
          if (state is SplashFailureState) {
            Fluttertoast.showToast(msg: "Something went wrong!");
          }
          if (state is SplashNetworkState) {
            logoutDialog(context);
          }
        },
        child: Scaffold(
          backgroundColor: colorPrimary,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: Image.asset(
                      "assets/3x/splash-triangle.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            ],
          ),
        ),
      ),
    );
  }

  getLogin(String appVersio) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    bool login =
        await SharedPrefrence.getBooleanPreference(SharedPrefrence.login);
    if (appVersio == packageInfo.version) {
      if (login == true) {
        Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen(),
            ),
          ),
        );
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
    } else {
      Fluttertoast.showToast(msg: "Please update the application");
    }
  }

  addEvent() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Device.get().isAndroid) {
      splashBloc
          .add(SplashEvent(appVersion: packageInfo.version, deviceType: "1"));
    }
    if (Device.get().isIos) {
      splashBloc
          .add(SplashEvent(appVersion: packageInfo.version, deviceType: "2"));
    }
  }

  logoutDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          title: const Text("Something Wrong!",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600)),
          content: const Text("Please check your internet and try again.",
              style: TextStyle(
                  color: Color.fromRGBO(85, 85, 85, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          actions: [
            MaterialButton(
              child: const Text("Retry",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xfff4511e),
                      fontWeight: FontWeight.w600)),
              onPressed: () {
                addEvent();
              },
            ),
          ],
        );
      },
    );
  }
}
