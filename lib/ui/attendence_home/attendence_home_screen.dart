import 'package:flutter/material.dart';
import 'package:sfa/ui/absent/absent_screen.dart';
import 'package:sfa/ui/attendence_clock_in_out/attendence_clock_in_out.dart';
import 'package:sfa/ui/team_members/team_members_screen.dart';
import 'package:sfa/utility/colors.dart';

class AttendenceHomeScreen extends StatefulWidget {
  const AttendenceHomeScreen({Key? key}) : super(key: key);

  @override
  _AttendenceHomeScreenState createState() => _AttendenceHomeScreenState();
}

class _AttendenceHomeScreenState extends State<AttendenceHomeScreen> {
  int currentBottomTabIndex = 0;
  List<Widget> navigationScreens = [
    const AttendenceClockInOut(),
    const AbsentScreen(),
    const TeamMembersScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: colorPrimary,
        title: currentBottomTabIndex == 0
            ? const Text("Attendence")
            : currentBottomTabIndex == 1
                ? const Text("Absent")
                : const Text("Team Members"),
        centerTitle: true,
        actions: [
          currentBottomTabIndex == 2
              ? IconButton(
                  onPressed: () {},
                  icon: const Image(
                    fit: BoxFit.contain,
                    width: 23,
                    image: AssetImage("assets/filter.png"),
                  ),
                )
              : Container(),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Image(
              fit: BoxFit.contain,
              width: 23,
              image: AssetImage("assets/home.png"),
            ),
          )
        ],
      ),
      body: navigationScreens[currentBottomTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBottomTabIndex,
        onTap: ontemTaped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: "Absent",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Team",
          )
        ],
      ),
    );
  }

  void ontemTaped(int index) {
    setState(() {
      currentBottomTabIndex = index;
    });
  }
}
