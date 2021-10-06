import 'package:flutter/material.dart';

class TeamMemberAttendenceScreen extends StatefulWidget {
  const TeamMemberAttendenceScreen({Key? key}) : super(key: key);

  @override
  _TeamMemberAttendenceScreenState createState() =>
      _TeamMemberAttendenceScreenState();
}

class _TeamMemberAttendenceScreenState
    extends State<TeamMemberAttendenceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        child: const Center(
          child: Text("Attendence"),
        ),
      ),
    );
  }
}
