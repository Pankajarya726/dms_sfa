import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sfa/ui/report_screen/report_screen.dart';
import 'package:sfa/utility/colors.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({Key? key}) : super(key: key);

  @override
  _TeamMembersScreenState createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  var format = DateFormat("dd-MMM-yyyy");
  DateTime? dateTime = DateTime.now();
  String date = "";

  @override
  Widget build(BuildContext context) {
    date = format.format(dateTime!);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: colorPrimary,
        flexibleSpace: Center(
          child: Row(
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
                    const SizedBox(
                      width: 10,
                    ),
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
        ),
        actions: [
          Center(
            child: SizedBox(
              height: 30,
              child: MaterialButton(
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
                          builder: (context) => const ReportScreen()));
                },
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Container(),
    );
  }
}
