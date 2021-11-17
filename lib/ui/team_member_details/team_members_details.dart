import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sfa/ui/member_report_screen/member_report_screen.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_screen.dart';
import 'package:sfa/ui/team_member_track_screen/team_member_track_screen.dart';
import 'package:sfa/ui/team_members_details_screen/team_member_details_screen.dart';
import 'package:sfa/utility/colors.dart';

class TeamMembersDetails extends StatefulWidget {
  String userId;
  String name;
  TeamMembersDetails({required this.userId, required this.name, Key? key})
      : super(key: key);

  @override
  _TeamMembersDetailsState createState() => _TeamMembersDetailsState();
}

class _TeamMembersDetailsState extends State<TeamMembersDetails> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: index,
      length: 3,
      child: Scaffold(
        backgroundColor: reportBG,
        appBar: AppBar(
          title: Text(
            widget.name,
            style: const TextStyle(color: Colors.white),
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
            child: TabBarView(
              children: [
                TeamMemberDetailsScreen(
                  userId: widget.userId,
                  name: widget.name,
                ),
                TeamMemberAttendenceScreen(
                  userId: widget.userId,
                  name: widget.name,
                ),
                TeamMemberTrackScreen(
                  userId: widget.userId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
