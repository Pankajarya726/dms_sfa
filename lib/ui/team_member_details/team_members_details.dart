import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sfa/ui/member_report_screen/member_report_screen.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_screen.dart';
import 'package:sfa/ui/team_member_track_screen/team_member_track_screen.dart';
import 'package:sfa/ui/team_members_absent/team_members_absent_screen.dart';
import 'package:sfa/ui/team_members_clockout/team_members_clockout_screen.dart';
import 'package:sfa/ui/team_members_details_screen/team_member_details_screen.dart';
import 'package:sfa/utility/colors.dart';

class TeamMembersDetails extends StatefulWidget {
  const TeamMembersDetails({Key? key}) : super(key: key);

  @override
  _TeamMembersDetailsState createState() => _TeamMembersDetailsState();
}

class _TeamMembersDetailsState extends State<TeamMembersDetails> {
  var format = DateFormat("dd-MMM-yyyy");
  DateTime? dateTime = DateTime.now();
  String date = "";

  @override
  Widget build(BuildContext context) {
    date = format.format(dateTime!);
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        backgroundColor: reportBG,
        appBar: AppBar(
          title: const Text(
            "Oliver",
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
                  labelColor: Colors.white,
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
                      text: "Attendence",
                    ),
                    Tab(
                      text: "Track",
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
          child: Column(
            children: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
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
                        child: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.35,
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/calendar.png",
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.20,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                dateTime = DateTime(dateTime!.year,
                                    dateTime!.month, dateTime!.day - 1);
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
                                dateTime = DateTime(dateTime!.year,
                                    dateTime!.month, dateTime!.day + 1);
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
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7358,
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
                    TeamMemberDetailsScreen(),
                    TeamMemberAttendenceScreen(),
                    TeamMemberTrackScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
