import 'package:flutter/material.dart';

class TeamMembersClockoutScreen extends StatefulWidget {
  const TeamMembersClockoutScreen({Key? key}) : super(key: key);

  @override
  _TeamMembersClockoutScreenState createState() =>
      _TeamMembersClockoutScreenState();
}

class _TeamMembersClockoutScreenState extends State<TeamMembersClockoutScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Clock out screen"),
    );
  }
}
