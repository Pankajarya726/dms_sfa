import 'package:flutter/material.dart';

class MyProfileAttendence extends StatefulWidget {
  const MyProfileAttendence({Key? key}) : super(key: key);

  @override
  _MyProfileAttendenceState createState() => _MyProfileAttendenceState();
}

class _MyProfileAttendenceState extends State<MyProfileAttendence> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("My profile attendence"),
    );
  }
}
