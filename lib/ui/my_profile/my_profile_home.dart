import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final TabBar _tabBar = TabBar(
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
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: reportBG,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: colorPrimary,
          title: const Text(
            "My Profile",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(62),
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xfff7f7f7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Material(
                color: colorTabBG,
                child: _tabBar,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            MyProfileDetails(),
            MyProfileAttendence(),
          ],
        ),
      ),
    );
  }
}
