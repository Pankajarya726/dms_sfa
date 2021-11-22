import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sfa/ui/member_report_screen/member_report_screen.dart';
import 'package:sfa/ui/my_profile_attendence/my_profile_attendence.dart';
import 'package:sfa/ui/my_profile_details/my_profile_details.dart';
import 'package:sfa/utility/colors.dart';

class MyProfileHome extends StatefulWidget {
  const MyProfileHome({Key? key}) : super(key: key);

  @override
  _MyProfileHomeState createState() => _MyProfileHomeState();
}

class _MyProfileHomeState extends State<MyProfileHome> {
  var format = DateFormat("dd-MMM-yyyy");
  DateTime? dateTime = DateTime.now();
  String date = "";
  int index = 0;
  final TabBar tabBar = TabBar(
    labelColor: Colors.white,
    indicatorColor: colorPrimary,
    unselectedLabelColor: colorPrimary,
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: colorPrimary,
    ),
    labelStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    tabs: const [
      Tab(
        text: "Details",
      ),
      Tab(
        text: "Attendence",
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    date = format.format(dateTime!);
    return DefaultTabController(
      initialIndex: index,
      length: 2,
      child: Scaffold(
        backgroundColor: reportBG,
        appBar: AppBar(
          title: const Text(
            "My Profile",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: colorPrimary,
          actions: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: MaterialButton(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                color: Colors.white70,
                elevation: 0,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/report.png",
                      width: 15,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Report",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MemberReportScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: Container(
              color: reportBG,
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Material(
                color: colorTabBG,
                borderRadius: BorderRadius.circular(50),
                child: TabBar(
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorColor: colorPrimary,
                  unselectedLabelColor: colorPrimary,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: colorPrimary,
                  ),
                  tabs: const [
                    Tab(
                      text: "Details",
                    ),
                    Tab(
                      text: "Attendance",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: colorPrimary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: reportBG,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const TabBarView(
              children: [
                MyProfileDetails(),
                MyProfileAttendence(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
