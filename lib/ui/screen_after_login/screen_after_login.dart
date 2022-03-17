import 'package:dms/main.dart';
import 'package:dms/model/get_plan_response.dart';
import 'package:dms/ui/drawer_screen/drawer_screen.dart';
import 'package:dms/ui/start_my_day/start_day_screen.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class ScreenAfterLogin extends StatefulWidget {
  const ScreenAfterLogin({Key? key}) : super(key: key);

  @override
  _ScreenAfterLoginState createState() => _ScreenAfterLoginState();
}

class _ScreenAfterLoginState extends State<ScreenAfterLogin> {
  PlanDataModel? myPlan;

  @override
  void initState() {
    // getMyPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  boxLayout("assets/sun.png", StringConst.startMyDayCaps, 60.0, 25.0),
                  const SizedBox(
                    height: 50,
                  ),
                  boxLayout("assets/explore.png", StringConst.exploreCaps, 50.0, 28.0),
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
      ),
    );
  }

  Widget boxLayout(imageIconPath, imageLabel, imageWidth, sizedBoxWidth) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.70,
      height: MediaQuery.of(context).size.height * 0.25,
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
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onTap: () {
            if (imageLabel == StringConst.startMyDayCaps) {
              // if (myPlan == null) {
              //   Fluttertoast.showToast(msg: "You don't have any plan for today, Please connect to admin");
              // } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StartDayScreen(),
                ),
              );
              // }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DrawerScreen(),
                ),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imageIconPath,
                width: imageWidth,
              ),
              SizedBox(
                height: sizedBoxWidth,
              ),
              Text(
                imageLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getMyPlan() async {
    if (await Network.isConnected()) {
      String userId = await SharedPreference.getStringPreference(SharedPreference.userId);

      DateTime dateTime = await NTP.now().timeout(const Duration(seconds: 15), onTimeout: () {
        return DateTime.now();
      });

      Map input = {
        "user_id": userId,
        "add_plan_date": DateFormat("yyyy-MM-dd").format(dateTime),
      };
      GetPlanByDateResponse response = await repository.getSavedPlan(input);

      if (response.success) {
        if (response.data != null) {
          myPlan = response.data;
        }
      } else {
        // Fluttertoast.showToast(msg: response.message);
      }
    } else {
      Fluttertoast.showToast(msg: "Please check your internet connection!");
    }
  }
}
