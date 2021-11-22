import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_bloc.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_event.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_state.dart';
import 'package:sfa/ui/team_member_attendence/model/attendance_model.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/team_member_attendence_bloc.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/team_member_attendence_event.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/team_member_attendence_state.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_bloc.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_events.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/constants.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class TeamMemberAttendenceScreen extends StatefulWidget {
  String userId;
  String name;
  TeamMemberAttendenceScreen(
      {required this.userId, required this.name, Key? key})
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
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

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
                                        DateFormat("MMM yyyy").format(dateTime),
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
                                    teamMemberAttendenceBloc.add(
                                        DecrementDateEvent(date: dateTime));
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
                                    if (DateTime.now().month ==
                                            dateTime.month &&
                                        DateTime.now().year == dateTime.year) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "You can't select month before today");
                                    } else {
                                      dateTime = DateTime(dateTime.year,
                                          dateTime.month + 1, dateTime.day);
                                      teamMemberAttendenceBloc.add(
                                          IncrementDateEvent(date: dateTime));
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
                              log(state.response.clockInData!.length
                                  .toString());
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
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 48),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                            overflow:
                                                                TextOverflow
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
                                                            color: Color(
                                                                0xff303030),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                trailing: IntrinsicWidth(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                                          : state.response.clockInData![index].approvedStatus ==
                                                                      3 &&
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
                                                                  : state.response.clockInData![index].approvedStatus == 2 &&
                                                                          state.response.clockInData![index].status == "Absent Rejected"
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
                                                            showTeamMemberStatusSheet(
                                                                widget.name,
                                                                state
                                                                    .response
                                                                    .clockInData![
                                                                        index]
                                                                    .id,
                                                                state
                                                                    .response
                                                                    .clockInData![
                                                                        index]
                                                                    .userId,
                                                                state
                                                                    .response
                                                                    .clockInData![
                                                                        index]
                                                                    .date!,
                                                                state
                                                                    .response
                                                                    .clockInData![
                                                                        index]
                                                                    .approvedStatus,
                                                                state
                                                                    .response
                                                                    .clockInData![
                                                                        index]
                                                                    .status);
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
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
                                                              .clockInData![
                                                                  index]
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
                                                              .clockInData![
                                                                  index]
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
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: dateTime,
      locale: const Locale("en"),
    ).then((date) {
      dateTime = date!;
      teamMemberAttendenceBloc.add(SelectDateEvent(date: date));
    });
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

  showTeamMemberStatusSheet(String name, int id, int userId, DateTime date,
      int approveStatus, String status) async {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      builder: (context) {
        return StatusBottomSheet(
          name: name,
          id: id,
          userId: userId,
          date: date,
          approveStatus: approveStatus,
          status: status,
        );
      },
    ).then((value) => addEvent());
  }

  void onRefresh() {
    addEvent();
    refreshController.refreshCompleted();
  }
}

class StatusBottomSheet extends StatefulWidget {
  final String name;
  final int id;
  final int userId;
  final DateTime date;
  final int approveStatus;
  final String status;
  const StatusBottomSheet(
      {required this.name,
      required this.id,
      required this.userId,
      required this.date,
      required this.approveStatus,
      required this.status,
      Key? key})
      : super(key: key);

  @override
  _StatusBottomSheetState createState() => _StatusBottomSheetState();
}

class _StatusBottomSheetState extends State<StatusBottomSheet> {
  PjpByDateBloc pjpByDateBloc = PjpByDateBloc();
  GetClockInDataBloc getClockInDataBloc = GetClockInDataBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PjpByDateBloc>(
      create: (context) => pjpByDateBloc,
      child: BlocBuilder<PjpByDateBloc, PjpByDateState>(
        builder: (context, state) {
          if (state is PjpByDateInitialState) {
            pjpByDateBloc.add(PjpByDateEvent(
                date: DateFormat("yyyy-MM-dd").format(widget.date),
                userId: widget.userId.toString()));
          }
          if (state is PjpByDateFailureState) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is PjpByDateLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is PjpByDateSuccessState) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: SingleChildScrollView(
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
                              child: Text(
                                widget.name,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
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
                              decoration: BoxDecoration(
                                boxShadow: const [
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
                                gradient: state.response.data![0].clockOutTime
                                        .isNotEmpty
                                    ? const LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          colorPrimary,
                                          colorLightPrimary
                                        ],
                                      )
                                    : const LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [colorGreen, colorLightGreen],
                                      ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Log in: " +
                                            state.response.data![0].clockInTime
                                                .toString() +
                                            (state.response.data![0]
                                                    .clockOutTime.isNotEmpty
                                                ? " - Log out: " +
                                                    state.response.data![0]
                                                        .clockOutTime
                                                        .toString()
                                                : ""),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
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
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
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
                                            child: Image.asset(
                                                "assets/zone-clock.png"),
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
                            commonTextField(
                                "PJP", state.response.data![0].pjpDescription),
                            const SizedBox(
                              height: 20,
                            ),
                            commonTextField("Working plan",
                                state.response.data![0].workingPlan),
                            const SizedBox(
                              height: 20,
                            ),
                            widget.approveStatus == 1 &&
                                    (widget.status == "Present Panding" ||
                                        widget.status == "Absent Panding")
                                ? Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: roundedButton(colorGreen,
                                            "Approve", widget.id, "2"),
                                      ),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: roundedButton(colorPrimary,
                                            "Reject", widget.id, "3"),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget commonTextField(headingText, description) {
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
          initialValue: description,
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

  Widget roundedButton(buttonColor, buttonText, id, status) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          var approvedBy =
              await SharedPrefrence.getStringPreference(SharedPrefrence.id);

          getClockInDataBloc.add(ClockInApproveRejectEvent(
              id: id.toString(), status: status, approvedBy: approvedBy));
          Navigator.pop(context, true);
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width, 50)),
          backgroundColor: MaterialStateProperty.all(buttonColor),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
