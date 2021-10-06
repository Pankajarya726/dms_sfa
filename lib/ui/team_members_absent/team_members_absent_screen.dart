import 'package:flutter/material.dart';

class TeamMembersAbsentScreen extends StatefulWidget {
  const TeamMembersAbsentScreen({Key? key}) : super(key: key);

  @override
  _TeamMembersAbsentScreenState createState() =>
      _TeamMembersAbsentScreenState();
}

class _TeamMembersAbsentScreenState extends State<TeamMembersAbsentScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Absent screen"),
    );
  }
}
