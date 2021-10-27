import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sfa/ui/team_members_details_screen/team_members_details_bloc/team_members_details_bloc.dart';
import 'package:sfa/ui/team_members_details_screen/team_members_details_bloc/team_members_details_event.dart';
import 'package:sfa/ui/team_members_details_screen/team_members_details_bloc/team_members_details_state.dart';
import 'package:sfa/utility/colors.dart';

class TeamMemberDetailsScreen extends StatefulWidget {
  const TeamMemberDetailsScreen({Key? key}) : super(key: key);

  @override
  _TeamMemberDetailsScreenState createState() =>
      _TeamMemberDetailsScreenState();
}

class _TeamMemberDetailsScreenState extends State<TeamMemberDetailsScreen> {
  TeamMembersDetailsBloc teamMembersDetailsBloc = TeamMembersDetailsBloc();
  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeamMembersDetailsBloc>(
      create: (context) => teamMembersDetailsBloc,
      child: BlocListener<TeamMembersDetailsBloc, TeamMembersDetailsState>(
        listener: (context, state) {
          if (state is SelectDateState) {
            dateTime = state.date;
          }
          if (state is IncrementDateState) {
            dateTime = state.date;
          }
          if (state is DecrementDateState) {
            dateTime = state.date;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: IntrinsicHeight(
            child: Container(
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
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              datePicker();
                            },
                            child: SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    "assets/calendar.png",
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  BlocBuilder<TeamMembersDetailsBloc,
                                      TeamMembersDetailsState>(
                                    builder: (context, state) {
                                      return Text(
                                        DateFormat("dd-MMM-yyyy")
                                            .format(dateTime),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.18,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    dateTime = DateTime(dateTime.year,
                                        dateTime.month, dateTime.day - 1);
                                    teamMembersDetailsBloc.add(
                                        DateIncrementEvent(date: dateTime));
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
                                    dateTime = DateTime(dateTime.year,
                                        dateTime.month, dateTime.day + 1);
                                    teamMembersDetailsBloc.add(
                                        DateIncrementEvent(date: dateTime));
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
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: reportBG,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 4, 12, 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          Text(
                                            "Clock In : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            "00:00:00 AM",
                                            style: TextStyle(
                                                color: colorGreen,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: const [
                                          Text(
                                            "Clock Out : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            "00:00:00 AM",
                                            style: TextStyle(
                                                color: colorRed, fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(16, 6, 0, 0),
                                child: const Text(
                                  "PJP",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(16, 4, 0, 8),
                                child: const Text(
                                  "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                                child: const Text(
                                  "Working Plan",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
                                child: const Text(
                                  "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 14, 0, 4),
                                child: const Text(
                                  "Clock-in Salfie",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 150,
                                  width: 150,
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 4, 0, 10),
                                  decoration: BoxDecoration(
                                    color: colorGray,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ]),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(16, 6, 0, 4),
                                child: const Text(
                                  "Comment",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(16, 0, 0, 4),
                                child: const Text(
                                  "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 14, 0, 4),
                                child: const Text(
                                  "Clock-out Salfie",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 150,
                                  width: 150,
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 4, 0, 10),
                                  decoration: BoxDecoration(
                                    color: colorGray,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void datePicker() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    teamMembersDetailsBloc.add(SelectDateEvent(date: date!));
  }
}
