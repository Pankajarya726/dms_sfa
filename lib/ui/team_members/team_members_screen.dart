import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sfa/ui/report_screen/report_screen.dart';
import 'package:sfa/ui/team%20members_status/team_members_status_screen.dart';
import 'package:sfa/ui/team_members_absent/team_members_absent_screen.dart';
import 'package:sfa/ui/team_members_clockout/team_members_clockout_screen.dart';
import 'package:sfa/utility/colors.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({Key? key}) : super(key: key);

  @override
  _TeamMembersScreenState createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
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
        text: "Status",
      ),
      Tab(
        text: "Clock-out",
      ),
      Tab(
        text: "Absent",
      ),
    ],
  );

  var format = DateFormat("dd-MMM-yyyy");
  DateTime? dateTime = DateTime.now();
  String date = "";

  @override
  Widget build(BuildContext context) {
    // date = format.format(dateTime!);
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        backgroundColor: reportBG,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: colorPrimary,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        dateTime = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now());
                        date = format.format(dateTime!);
                        setState(() {});
                        debugPrint("dateTime ->$date");
                      },
                      child: Row(
                        children: [
                          const Image(
                            fit: BoxFit.contain,
                            width: 15,
                            image: AssetImage("assets/calendar.png"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            date,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        dateTime = DateTime(
                            dateTime!.year, dateTime!.month, dateTime!.day - 1);
                        date = format.format(dateTime!);
                        setState(() {});
                      },
                      child: Image.asset(
                        "assets/icon_previous.png",
                        width: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        dateTime = DateTime(
                            dateTime!.year, dateTime!.month, dateTime!.day + 1);
                        date = format.format(dateTime!);
                        setState(() {});
                      },
                      child: Image.asset(
                        "assets/icon_next.png",
                        width: 25,
                      ),
                    ),
                  ],
                ),
                MaterialButton(
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
                        builder: (context) => const ReportScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            // preferredSize: _tabBar.preferredSize,
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
            TeamMembersStatusScreen(),
            TeamMembersClockoutScreen(),
            TeamMembersAbsentScreen()
          ],
        ),
      ),
    );
  }
}
