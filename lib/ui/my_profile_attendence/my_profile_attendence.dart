import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sfa/ui/my_profile_attendence/my_profile_attendence_bloc/my_profile_attendence_bloc.dart';
import 'package:sfa/ui/my_profile_attendence/my_profile_attendence_bloc/my_profile_attendence_event.dart';
import 'package:sfa/ui/my_profile_attendence/my_profile_attendence_bloc/my_profile_attendence_state.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_bloc.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_event.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_state.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_bloc.dart';

import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/constants.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class MyProfileAttendence extends StatefulWidget {
  const MyProfileAttendence({Key? key}) : super(key: key);

  @override
  _MyProfileAttendenceState createState() => _MyProfileAttendenceState();
}

class _MyProfileAttendenceState extends State<MyProfileAttendence> {
  MyProfileAttendenceBloc myProfileAttendenceBloc = MyProfileAttendenceBloc();
  DateTime dateTime = DateTime.now();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myProfileAttendenceBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SmartRefresher(
          primary: false,
          controller: refreshController,
          onRefresh: onRefresh,
          enablePullDown: true,
          child: Container(
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
                          onTap: () async {
                            showPicker();
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
                                BlocBuilder<MyProfileAttendenceBloc,
                                    MyProfileAttendenceState>(
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

                                  myProfileAttendenceBloc.add(
                                      MyProfileAttendenceDecrementDateEvent(
                                          dateTime: dateTime));
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
                                  if (DateTime.now().month == dateTime.month &&
                                      DateTime.now().year == dateTime.year) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "You can't select month before today");
                                  } else {
                                    dateTime = DateTime(dateTime.year,
                                        dateTime.month + 1, dateTime.day);

                                    myProfileAttendenceBloc.add(
                                        MyProfileAttendenceIncrementDateEvent(
                                            dateTime: dateTime));
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
                      child: BlocConsumer<MyProfileAttendenceBloc,
                          MyProfileAttendenceState>(
                        listener: (context, state) {
                          if (state is MyProfileAttendenceSelectDateState) {
                            dateTime = state.dateTime;
                            addEvent();
                          }
                          if (state is MyProfileAttendenceIncrementDateState) {
                            dateTime = state.dateTime;
                            addEvent();
                          }
                          if (state is MyProfileAttendenceDecrementDateState) {
                            dateTime = state.dateTime;
                            addEvent();
                          }
                        },
                        builder: (context, state) {
                          if (state is MyProfileAttendenceInitialState) {
                            addEvent();
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is MyProfileAttendenceLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is MyProfileAttendenceFailureState) {
                            return Center(
                              child: Text(state.failureMessage),
                            );
                          }
                          if (state is MyProfileAttendenceInitialSuccessState) {
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
                                                                            3 &&
                                                                        state.response.clockInData![index].status ==
                                                                            "Absent Rejected"
                                                                    ? statusRejected()
                                                                    : state.response.clockInData![index].approvedStatus == 1 && state.response.clockInData![index].status == "Present Pending"
                                                                        ? buttonPending()
                                                                        : state.response.clockInData![index].approvedStatus == 1 && state.response.clockInData![index].status == "Absent Pending"
                                                                            ? buttonPending()
                                                                            : statusNull(),
                                                    SizedBox(
                                                      width: 20,
                                                      child: IconButton(
                                                        onPressed: () {
                                                          showAttendenceBottomSheet(
                                                              state
                                                                  .response
                                                                  .clockInData![
                                                                      index]
                                                                  .userId,
                                                              state
                                                                  .response
                                                                  .clockInData![
                                                                      index]
                                                                  .date!);
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

  addEvent() {
    var format = DateFormat("yyyy-MM-dd");
    myProfileAttendenceBloc.add(
        MyProfileAttendenceInitialEvent(currentDate: format.format(dateTime)));
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

  Widget buttonPending() {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        backgroundColor: MaterialStateProperty.all(colorYellow),
        elevation: MaterialStateProperty.all(0),
        minimumSize: MaterialStateProperty.all(
          const Size.fromRadius(0),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        ),
      ),
      onPressed: () {},
      child: const Text(
        "Pending",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void showPicker() async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: dateTime,
      locale: const Locale("en"),
    ).then((date) {
      dateTime = date!;
      myProfileAttendenceBloc
          .add(MyProfileAttendenceSelectDateEvent(dateTime: dateTime));
    });
  }

  Widget statusNull() {
    return Container();
  }

  showAttendenceBottomSheet(
    int userId,
    DateTime date,
  ) async {
    String name =
        await SharedPrefrence.getStringPreference(SharedPrefrence.name);
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      builder: (context) {
        return StatusBottomSheet(
          userId: userId,
          date: date,
          name: name,
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
  final int userId;
  final DateTime date;
  final String name;
  const StatusBottomSheet(
      {required this.userId, required this.date, required this.name, Key? key})
      : super(key: key);

  @override
  _StatusBottomSheetState createState() => _StatusBottomSheetState();
}

class _StatusBottomSheetState extends State<StatusBottomSheet> {
  PjpByDateBloc pjpByDateBloc = PjpByDateBloc();
  GetClockInDataBloc getClockInDataBloc = GetClockInDataBloc();
  Duration duration = const Duration(seconds: 0, hours: 0, minutes: 0);
  int time = 0;
  Timer? timer;
  final stopWatch = PublishSubject<int>();
  var timerSubscription;
  StreamController<String> timerController = StreamController();
  int checkSuccessHours = 0;
  DateTime? clockInTime;
  DateTime? clockOutTime;
  String timeDifference = "00:00:00";

  @override
  void dispose() {
    if (timer != null) {
      stopAttendenceTimer();
    }
    super.dispose();
  }

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
            if (state.response.data!.isNotEmpty) {
              if (state.response.data!.first.clockInTime.isNotEmpty &&
                  state.response.data!.first.clockOutTime.isEmpty) {
                clockInTime = DateFormat("HH:mm:ss")
                    .parse(state.response.data!.first.clockInTime);
                startAttendenceTimer(clockInTime!);
              }
              if (state.response.data!.first.clockOutTime.isNotEmpty &&
                  state.response.data!.first.clockInTime.isNotEmpty) {
                clockInTime = DateFormat("HH:mm:ss")
                    .parse(state.response.data!.first.clockInTime);
                clockOutTime = DateFormat("HH:mm:ss")
                    .parse(state.response.data!.first.clockOutTime);
                timeDifference =
                    (clockOutTime!.difference(clockInTime!)).toString();
                var arr = timeDifference.split(".");
                timeDifference = arr[0];
                var arr2 = timeDifference.split(":");
                int hrs = int.parse(arr2[0]);
                checkSuccessHours = int.parse(arr2[0]);
                timeDifference = arr2[0].padLeft(2, '0');
                timeDifference = timeDifference + ":" + arr2[1].padLeft(2, '0');
                timeDifference = timeDifference + ":" + arr2[2].padLeft(2, '0');
              }
            }
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
                        child: state.response.data!.first.clockInTime.isNotEmpty
                            ? Column(
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 10.0, // soften the shadow
                                          spreadRadius:
                                              -1.5, //extend the shadow
                                          offset: Offset(
                                            0, // Move to right 10  horizontally
                                            0, // Move to bottom 10 Vertically
                                          ),
                                        )
                                      ],
                                      gradient: state.response.data!.first
                                              .clockOutTime.isEmpty
                                          ? (checkSuccessHours < 8
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
                                                  colors: [
                                                    colorGreen,
                                                    colorLightGreen
                                                  ],
                                                ))
                                          : (checkSuccessHours < 8
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
                                                  colors: [
                                                    colorGreen,
                                                    colorLightGreen
                                                  ],
                                                )),
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
                                            child: Row(
                                              mainAxisAlignment: state
                                                      .response
                                                      .data!
                                                      .first
                                                      .clockOutTime
                                                      .isNotEmpty
                                                  ? MainAxisAlignment
                                                      .spaceBetween
                                                  : MainAxisAlignment.start,
                                              children: [
                                                state.response.data!.first
                                                        .clockInTime.isNotEmpty
                                                    ? Text(
                                                        "Log in : " +
                                                            DateFormat.jms()
                                                                .format(
                                                                    clockInTime!),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      )
                                                    : const Text(
                                                        "Log in : ",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                state.response.data!.first
                                                        .clockOutTime.isNotEmpty
                                                    ? Text(
                                                        "Log out : " +
                                                            DateFormat.jms()
                                                                .format(
                                                                    clockOutTime!),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: state.response.data!.first
                                                  .clockOutTime.isEmpty
                                              ? StreamBuilder<String>(
                                                  stream:
                                                      timerController.stream,
                                                  builder: (context, snap) {
                                                    if (snap.hasData &&
                                                        snap.data!.isNotEmpty) {
                                                      String timerHrss =
                                                          snap.data!;
                                                      var arr =
                                                          timerHrss.split(":");
                                                      String hrs = arr[0];
                                                      String min = arr[1];
                                                      String sec = arr[2];
                                                      return Text(
                                                        "${hrs.padLeft(2, '0')}:${min.padLeft(2, '0')}:${sec.padLeft(2, '0')}",
                                                        style: const TextStyle(
                                                          fontSize: 45.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          letterSpacing: 5,
                                                        ),
                                                      );
                                                    }
                                                    return const Text(
                                                      "00:00:00",
                                                      style: TextStyle(
                                                        fontSize: 45.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        letterSpacing: 5,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Text(
                                                  timeDifference,
                                                  style: const TextStyle(
                                                    fontSize: 45.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: 5,
                                                  ),
                                                ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                  commonTextField("PJP",
                                      state.response.data![0].pjpDescription),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  commonTextField("Working plan",
                                      state.response.data![0].workingPlan),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    height: 15,
                                  ),
                                  const Text(
                                    "Reason",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  const Text(
                                    "Absent Reason",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Color(0xff303030),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
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

  startAttendenceTimer(DateTime dateTime) {
    String time1 = DateTime.now().hour.toString() +
        ":" +
        DateTime.now().minute.toString() +
        ":" +
        DateTime.now().second.toString() +
        ".000";

    duration = DateFormat().add_Hms().parse(time1).difference(dateTime);
    time = duration.inSeconds;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!stopWatch.isClosed) {
        stopWatch.sink.add(timer.tick);
      } else {
        timer.cancel();
      }
    });

    timerSubscription = stopWatch.listen((int newTick) {
      time = time + 1;

      checkSuccessHours = int.parse("${Duration(seconds: time).inHours}");
      if (checkSuccessHours == 2) {
        setState(() {});
      }
      timerController.add(
          "${Duration(seconds: time).inHours}:${Duration(seconds: time).inMinutes % 60}:${Duration(seconds: time).inSeconds % 60}");
    });
  }

  stopAttendenceTimer() {
    timerController.close();
    stopWatch.sink.close();
    stopWatch.close();
  }
}
