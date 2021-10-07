import 'package:flutter/material.dart';

class TeamMemberTrackScreen extends StatefulWidget {
  const TeamMemberTrackScreen({Key? key}) : super(key: key);

  @override
  _TeamMemberTrackScreenState createState() => _TeamMemberTrackScreenState();
}

class _TeamMemberTrackScreenState extends State<TeamMemberTrackScreen> {
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
          child: Text("Track"),
        ),
      ),
    );
  }
}
