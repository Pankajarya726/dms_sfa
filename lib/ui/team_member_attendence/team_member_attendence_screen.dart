import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:sfa/ui/team_member_attendence/model/attendance_model.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/team_member_attendence_bloc.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/team_member_attendence_event.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/team_member_attendence_state.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/constants.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class TeamMemberAttendenceScreen extends StatefulWidget {
  String userId;
  TeamMemberAttendenceScreen({required this.userId, Key? key})
      : super(key: key);

  @override
  _TeamMemberAttendenceScreenState createState() =>
      _TeamMemberAttendenceScreenState();
}

class _TeamMemberAttendenceScreenState
    extends State<TeamMemberAttendenceScreen> {
  TeamMemberAttendenceBloc teamMemberAttendenceBloc =
      TeamMemberAttendenceBloc();
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    addEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeamMemberAttendenceBloc>(
      create: (context) => teamMemberAttendenceBloc,
      child: BlocListener<TeamMemberAttendenceBloc, TeamMemberAttendenceState>(
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
          if (state is TeamMemberAttendenceApproveSuccessState) {
            log(state.response.message);
            addEvent();
          }
          if (state is TeamMemberAttendenceApproveFailureState) {
            log(state.message);
            addEvent();
          }

          if (state is TeamMemberAttendenceAbsentApproveSuccessState) {
            log(state.response.message);
            addEvent();
          }
          if (state is TeamMemberAttendenceAbsentApproveFailureState) {
            log(state.message);
            addEvent();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  "assets/calendar.png",
                                  width: 20,
                                  height: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                BlocBuilder<TeamMemberAttendenceBloc,
                                    TeamMemberAttendenceState>(
                                  builder: (context, state) {
                                    return Text(
                                      DateFormat("MMM-yyyy").format(dateTime),
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
                                      dateTime.month - 1, dateTime.day);
                                  teamMemberAttendenceBloc
                                      .add(DecrementDateEvent(date: dateTime));
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
                                  dateTime = DateTime(dateTime.year,
                                      dateTime.month + 1, dateTime.day);
                                  teamMemberAttendenceBloc
                                      .add(IncrementDateEvent(date: dateTime));
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
                      child: BlocBuilder<TeamMemberAttendenceBloc,
                          TeamMemberAttendenceState>(
                        builder: (context, state) {
                          if (state is TeamMemberAttendenceLoadingState) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (state is TeamMemberAttendenceFailureState) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Center(
                                child: Text(state.message),
                              ),
                            );
                          }

                          if (state is TeamMemberAttendenceSucessState) {
                            log(state.response.clockInData!.length.toString());
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Column(
                                  children: List.generate(
                                    state.response.clockInData!.length,
                                    (index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            height: 85,
                                            margin: const EdgeInsets.fromLTRB(
                                                10, 15, 10, 0),
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 12, 0, 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: -8,
                                                  blurRadius: 7,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: ListTile(
                                              dense: true,
                                              onTap: () {},
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 48),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      DateFormat("EEEE").format(
                                                          DateTime.parse(state
                                                              .response
                                                              .clockInData![
                                                                  index]
                                                              .date
                                                              .toString())),
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      state
                                                          .response
                                                          .clockInData![index]
                                                          .status,
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xff303030),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              trailing: IntrinsicWidth(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    state
                                                                    .response
                                                                    .clockInData![
                                                                        index]
                                                                    .approvedStatus ==
                                                                2 &&
                                                            state
                                                                    .response
                                                                    .clockInData![
                                                                        index]
                                                                    .status ==
                                                                "Present Approved"
                                                        ? statusAccepted()
                                                        : state.response.clockInData![index].approvedStatus == 3 &&
                                                                state
                                                                        .response
                                                                        .clockInData![
                                                                            index]
                                                                        .status ==
                                                                    "Present Rejected"
                                                            ? statusRejected()
                                                            : state.response.clockInData![index].approvedStatus ==
                                                                        2 &&
                                                                    state.response.clockInData![index].status ==
                                                                        "Absent Approved"
                                                                ? statusAccepted()
                                                                : state.response.clockInData![index].approvedStatus ==
                                                                            2 &&
                                                                        state.response.clockInData![index].status ==
                                                                            "Absent Rejected"
                                                                    ? statusAccepted()
                                                                    : state.response.clockInData![index].approvedStatus == 1 && state.response.clockInData![index].status == "Present Panding"
                                                                        ? presentStatusPending(state.response.clockInData![index].id.toString())
                                                                        : state.response.clockInData![index].approvedStatus == 1 && state.response.clockInData![index].status == "Absent Panding"
                                                                            ? absentStatusPending(state.response.clockInData![index].id, state.response.clockInData![index].userId)
                                                                            : statusNull(),
                                                    SizedBox(
                                                      width: 20,
                                                      child: IconButton(
                                                        onPressed: () {
                                                          showTeamMemberStatusSheet();
                                                        },
                                                        icon: const Icon(
                                                          Icons.more_vert,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10,
                                            top: 15,
                                            child: Container(
                                              height: 85,
                                              width: 65,
                                              decoration: const BoxDecoration(
                                                color: colorCalenderDateBG,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    DateFormat("MMM").format(
                                                        DateTime.parse(state
                                                            .response
                                                            .clockInData![index]
                                                            .date
                                                            .toString())),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    DateFormat("dd").format(
                                                        DateTime.parse(state
                                                            .response
                                                            .clockInData![index]
                                                            .date
                                                            .toString())),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
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
    );
  }

  Widget statusAccepted() {
    return SizedBox(
      width: 20,
      child: Image.asset(
        "assets/accept.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget statusRejected() {
    return SizedBox(
      width: 20,
      child: Image.asset(
        "assets/reject.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget absentStatusPending(int id, int userId) {
    return Row(
      children: [
        buttonsAbsentApprove(id, userId, colorGreen, "Approve"),
        const SizedBox(
          width: 10,
        ),
        buttonsAbsentReject(id, userId, colorRed, "Reject")
      ],
    );
  }

  Widget buttonsAbsentApprove(int id, int userId, color, text) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size.fromWidth(65),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
          BorderSide(color: color),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size.fromRadius(0),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        ),
      ),
      onPressed: () async {
        var approvedBy =
            await SharedPrefrence.getStringPreference(SharedPrefrence.id);
        teamMemberAttendenceBloc.add(
          TeamMemberAttendenceAbsentApproveEvent(
              id: id.toString(),
              approvedBy: approvedBy,
              userId: userId.toString(),
              status: "2"),
        );
      },
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }

  Widget buttonsAbsentReject(int id, int userId, color, text) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size.fromWidth(65),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
          BorderSide(color: color),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size.fromRadius(0),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        ),
      ),
      onPressed: () async {
        var approvedBy =
            await SharedPrefrence.getStringPreference(SharedPrefrence.id);
        teamMemberAttendenceBloc.add(
          TeamMemberAttendenceAbsentApproveEvent(
              id: id.toString(),
              approvedBy: approvedBy,
              userId: userId.toString(),
              status: "3"),
        );
      },
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }

  Widget presentStatusPending(String id) {
    return Row(
      children: [
        buttonsApprove(id, colorGreen, "Approve"),
        const SizedBox(
          width: 10,
        ),
        buttonsReject(id, colorRed, "Reject")
      ],
    );
  }

  Widget buttonsApprove(String id, color, text) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size.fromWidth(65),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
          BorderSide(color: color),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size.fromRadius(0),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        ),
      ),
      onPressed: () async {
        var approvedBy =
            await SharedPrefrence.getStringPreference(SharedPrefrence.id);
        teamMemberAttendenceBloc.add(TeamMemberAttendenceApproveEvent(
            approvedBy: approvedBy, id: id, status: "2"));
      },
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }

  Widget buttonsReject(String id, color, text) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size.fromWidth(65),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
          BorderSide(color: color),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size.fromRadius(0),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        ),
      ),
      onPressed: () async {
        var approvedBy =
            await SharedPrefrence.getStringPreference(SharedPrefrence.id);
        teamMemberAttendenceBloc.add(TeamMemberAttendenceApproveEvent(
            approvedBy: approvedBy, id: id.toString(), status: "3"));
      },
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }

  void datePicker() async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 0),
      lastDate: DateTime(DateTime.now().year + 0, 12),
      initialDate: dateTime,
      locale: const Locale("en"),
    ).then((date) {
      teamMemberAttendenceBloc.add(SelectDateEvent(date: date!));
    });
  }

  void showTeamMemberStatusSheet() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: reportBG,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Oliver",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: colorPrimary,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10.0, // soften the shadow
                              spreadRadius: -1.5, //extend the shadow
                              offset: Offset(
                                0, // Move to right 10  horizontally
                                0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [colorGreen, colorLightGreen],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Log in: 10:00 AM - Log out: 6:00 PM",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "08:08:35",
                                style: TextStyle(
                                  fontSize: 45.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 5,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: SizedBox(
                                      width: 15,
                                      child:
                                          Image.asset("assets/zone-clock.png"),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Flexible(
                                    flex: 20,
                                    child: Text(
                                      "Time zone in Indore, Madhya Pradesh, India (GMT+5:30)",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      commonTextField("PJP"),
                      const SizedBox(
                        height: 20,
                      ),
                      commonTextField("Working plan"),
                      const SizedBox(
                        height: 12,
                      ),
                      1 == 1
                          ? SizedBox(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 160,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: colorGreen,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: const Center(
                                            child: Text(
                                              "Approve",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 160,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: colorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: const Center(
                                            child: Text(
                                              "Reject",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget commonTextField(headingText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headingText,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        TextFormField(
          readOnly: true,
          maxLines: 3,
          initialValue: LOREUMIPSUM,
          keyboardType: TextInputType.text,
          style: const TextStyle(
            color: Color(0xff303030),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff555555)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Color(0xff555555),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void addEvent() {
    teamMemberAttendenceBloc.add(GetTeamMemberAttendenceEvent(
        id: widget.userId, date: DateFormat("yyyy-MM").format(dateTime)));
  }

  Widget statusNull() {
    return Container();
  }
}
