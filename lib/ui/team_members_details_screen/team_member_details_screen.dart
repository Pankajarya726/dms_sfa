import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sfa/ui/team_members_details_screen/team_members_details_bloc/team_members_details_bloc.dart';
import 'package:sfa/ui/team_members_details_screen/team_members_details_bloc/team_members_details_event.dart';
import 'package:sfa/ui/team_members_details_screen/team_members_details_bloc/team_members_details_state.dart';
import 'package:sfa/utility/colors.dart';

class TeamMemberDetailsScreen extends StatefulWidget {
  String userId;
  String name;
  String date;
  TeamMemberDetailsScreen(
      {required this.userId, required this.name, required this.date, Key? key})
      : super(key: key);

  @override
  _TeamMemberDetailsScreenState createState() =>
      _TeamMemberDetailsScreenState();
}

class _TeamMemberDetailsScreenState extends State<TeamMemberDetailsScreen> {
  TeamMembersDetailsBloc teamMembersDetailsBloc = TeamMembersDetailsBloc();
  DateTime dateTime = DateTime.now();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    dateTime = DateTime.parse(widget.date);
    addEvent();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeamMembersDetailsBloc>(
      create: (context) => teamMembersDetailsBloc,
      child: BlocListener<TeamMembersDetailsBloc, TeamMembersDetailsState>(
        listener: (context, state) {
          if (state is SelectDateState) {
            dateTime = state.date;
            addEvent();
          }
          if (state is IncrementDateState) {
            dateTime = state.date;
            addEvent();
          }
          if (state is DecrementDateState) {
            dateTime = state.date;
            addEvent();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SmartRefresher(
            primary: false,
            controller: refreshController,
            onRefresh: onRefresh,
            enablePullDown: true,
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
                                children: [
                                  Image.asset(
                                    "assets/2x/calendar.png",
                                    width: 20,
                                    height: 20,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  BlocBuilder<TeamMembersDetailsBloc,
                                      TeamMembersDetailsState>(
                                    builder: (context, state) {
                                      return Text(
                                        DateFormat("dd MMM yyyy")
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
                                    "assets/2x/icon_previous.png",
                                    width: 25,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (DateTime.now().day == dateTime.day &&
                                        DateTime.now().month ==
                                            dateTime.month &&
                                        DateTime.now().year == dateTime.year) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "You can't select date before today");
                                    } else {
                                      dateTime = DateTime(dateTime.year,
                                          dateTime.month, dateTime.day + 1);
                                      teamMembersDetailsBloc.add(
                                          DateIncrementEvent(date: dateTime));
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/2x/icon_next.png",
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
                        child: BlocBuilder<TeamMembersDetailsBloc,
                            TeamMembersDetailsState>(
                          builder: (context, state) {
                            if (state is TeamMembersDetailsLoadingState) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (state is TeamMembersDetailsFailureState) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                  child: Text(state.message),
                                ),
                              );
                            }
                            if (state is TeamMembersDetailsSuccessState) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 18, 12, 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Clock in : ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                if (state.response.data!
                                                    .clockInTime.isNotEmpty)
                                                  TextSpan(
                                                    text: state.response.data!
                                                        .clockInTime,
                                                    style: const TextStyle(
                                                      color: colorGreen,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                else
                                                  const TextSpan(
                                                    text: "--",
                                                    style: TextStyle(
                                                      color: colorGreen,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                    text: 'Clock out : ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                state.response.data!
                                                        .clockOutTime.isNotEmpty
                                                    ? TextSpan(
                                                        text: state.response
                                                            .data!.clockOutTime,
                                                        style: const TextStyle(
                                                          color: colorPrimary,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    : const TextSpan(
                                                        text: "--",
                                                        style: TextStyle(
                                                          color: colorPrimary,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 6, 0, 0),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 4, 0, 8),
                                      child: Text(
                                        state.response.data!.pjpDescription,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 8, 0, 0),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 4, 0, 4),
                                      child: Text(
                                        state.response.data!.inWorkingPlan,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 14, 0, 4),
                                      child: const Text(
                                        "Clock-in Selfie",
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
                                        margin: const EdgeInsets.fromLTRB(
                                            16, 4, 0, 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  state.response.data!.inImage),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ]),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 6, 0, 4),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 0, 4),
                                      child: Text(
                                        state.response.data!.comments,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 14, 0, 4),
                                      child: const Text(
                                        "Clock-out Selfie",
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
                                        margin: const EdgeInsets.fromLTRB(
                                            16, 4, 0, 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(state
                                                  .response.data!.outImage),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          },
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
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      dateTime = d;
    }

    teamMembersDetailsBloc.add(SelectDateEvent(date: dateTime));
  }

  void addEvent() async {
    teamMembersDetailsBloc.add(GetTeamMembersDetailsEvents(
        id: widget.userId, date: DateFormat("yyyy-MM-dd").format(dateTime)));
  }

  void onRefresh() {
    addEvent();
    refreshController.refreshCompleted();
  }
}
