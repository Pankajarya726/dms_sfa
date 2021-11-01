import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:sfa/ui/my_profile_attendence/my_profile_attendence_bloc/my_profile_attendence_bloc.dart';
import 'package:sfa/ui/my_profile_attendence/my_profile_attendence_bloc/my_profile_attendence_event.dart';
import 'package:sfa/ui/my_profile_attendence/my_profile_attendence_bloc/my_profile_attendence_state.dart';
import 'package:sfa/ui/team_member_attendence/model/attendance_model.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/constants.dart';

class MyProfileAttendence extends StatefulWidget {
  const MyProfileAttendence({Key? key}) : super(key: key);

  @override
  _MyProfileAttendenceState createState() => _MyProfileAttendenceState();
}

class _MyProfileAttendenceState extends State<MyProfileAttendence> {
  MyProfileAttendenceBloc myProfileAttendenceBloc = MyProfileAttendenceBloc();
  DateTime? dateTime = DateTime.now();

  List<String> names = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  List<String> status = [
    "Absent",
    "Present",
    "08:54:00",
    "Present",
    "Absent",
    "05:20:01",
  ];
  List<AttendenceModel> attendence = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myProfileAttendenceBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(top: 8),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                "assets/calendar.png",
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              BlocBuilder<MyProfileAttendenceBloc,
                                  MyProfileAttendenceState>(
                                builder: (context, state) {
                                  return Text(
                                    DateFormat("MMM-yyyy").format(dateTime!),
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
                                dateTime = DateTime(dateTime!.year,
                                    dateTime!.month - 1, dateTime!.day);

                                myProfileAttendenceBloc.add(
                                    MyProfileAttendenceDecrementDateEvent(
                                        dateTime: dateTime!));
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
                                dateTime = DateTime(dateTime!.year,
                                    dateTime!.month + 1, dateTime!.day);

                                myProfileAttendenceBloc.add(
                                    MyProfileAttendenceIncrementDateEvent(
                                        dateTime: dateTime!));
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
                    child: BlocConsumer<MyProfileAttendenceBloc,
                        MyProfileAttendenceState>(
                      listener: (context, state) {
                        if (state is MyProfileAttendenceSelectDateState) {
                          dateTime = state.dateTime;
                          var format = DateFormat("yyyy-MM-dd");
                          myProfileAttendenceBloc.add(
                              MyProfileAttendenceInitialEvent(
                                  currentDate: format.format(dateTime!)));
                        }
                        if (state is MyProfileAttendenceIncrementDateState) {
                          dateTime = state.dateTime;
                          var format = DateFormat("yyyy-MM-dd");
                          myProfileAttendenceBloc.add(
                              MyProfileAttendenceInitialEvent(
                                  currentDate: format.format(dateTime!)));
                        }
                        if (state is MyProfileAttendenceDecrementDateState) {
                          dateTime = state.dateTime;
                          var format = DateFormat("yyyy-MM-dd");
                          myProfileAttendenceBloc.add(
                              MyProfileAttendenceInitialEvent(
                                  currentDate: format.format(dateTime!)));
                        }
                      },
                      builder: (context, state) {
                        if (state is MyProfileAttendenceInitialState) {
                          var format = DateFormat("yyyy-MM-dd");
                          myProfileAttendenceBloc.add(
                              MyProfileAttendenceInitialEvent(
                                  currentDate: format.format(dateTime!)));
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is MyProfileAttendenceLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is MyProfileAttendenceInitialSuccessState) {
                          attendence = state.attendanceResponse;
                          // return ListView.builder(
                          //   itemCount: status.length,
                          //   padding: const EdgeInsets.only(bottom: 15),
                          //   itemBuilder: (context, index) {
                          //     return Stack(
                          //       children: [
                          //         Container(
                          //           height: 85,
                          //           margin: const EdgeInsets.fromLTRB(
                          //               10, 15, 10, 0),
                          //           padding:
                          //               const EdgeInsets.fromLTRB(5, 12, 0, 12),
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.circular(10),
                          //             boxShadow: [
                          //               BoxShadow(
                          //                 color: Colors.grey.withOpacity(0.5),
                          //                 spreadRadius: -8,
                          //                 blurRadius: 7,
                          //                 offset: const Offset(0, 3),
                          //               ),
                          //             ],
                          //           ),
                          //           child: ListTile(
                          //             contentPadding: const EdgeInsets.fromLTRB(
                          //                 20, 0, 10, 0),
                          //             dense: true,
                          //             horizontalTitleGap: 0,
                          //             title: Padding(
                          //               padding:
                          //                   const EdgeInsets.only(left: 48),
                          //               child: Column(
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: [
                          //                   Text(
                          //                     DateFormat("EEEE").format(
                          //                                 DateTime.parse(
                          //                                     [index]
                          //                                         .date!))
                          //                     style: const TextStyle(
                          //                       fontSize: 20,
                          //                       fontWeight: FontWeight.bold,
                          //                     ),
                          //                   ),
                          //                   const SizedBox(
                          //                     height: 5,
                          //                   ),
                          //                   Text(
                          //                     status[index],
                          //                     style: const TextStyle(
                          //                       overflow: TextOverflow.ellipsis,
                          //                       color: Color(0xff303030),
                          //                       fontSize: 16,
                          //                       fontWeight: FontWeight.w500,
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //             trailing: IntrinsicWidth(
                          //               child: Row(
                          //                 children: [
                          //                   status[index] == "Present"
                          //                       ? statusAccepted()
                          //                       : status[index] == "Absent"
                          //                           ? statusRejected()
                          //                           : buttonPending(),
                          //                   SizedBox(
                          //                     width: 20,
                          //                     child: IconButton(
                          //                       padding:
                          //                           const EdgeInsets.all(0),
                          //                       onPressed: () {
                          //                         showClockOutBottomSheet();
                          //                       },
                          //                       icon: const Icon(
                          //                         Icons.more_vert,
                          //                         color: Colors.black,
                          //                         size: 27,
                          //                       ),
                          //                     ),
                          //                   )
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //         Positioned(
                          //           left: 10,
                          //           top: 15,
                          //           child: Container(
                          //             height: 85,
                          //             width: 60,
                          //             decoration: const BoxDecoration(
                          //               color: colorCalenderDateBG,
                          //               borderRadius: BorderRadius.only(
                          //                 topLeft: Radius.circular(10),
                          //                 bottomLeft: Radius.circular(10),
                          //               ),
                          //             ),
                          //             child: Column(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.center,
                          //               children: const [
                          //                 Text(
                          //                   "Sep",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontSize: 18,
                          //                       fontWeight: FontWeight.bold),
                          //                 ),
                          //                 Text(
                          //                   "20",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontSize: 24,
                          //                       fontWeight: FontWeight.w900),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        }
                        if (state is MyProfileAttendenceFailureState) {
                          return Center(
                            child: Text(state.failureMessage),
                          );
                        }
                        if (attendence.isNotEmpty) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Column(
                                children: List.generate(
                                  attendence.length,
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
                                                        DateTime.parse(
                                                            attendence[index]
                                                                .date!)),
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
                                                    attendence[index].status,
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
                                                  attendence[index]
                                                              .approvedStatus ==
                                                          2
                                                      ? statusAccepted()
                                                      : attendence[index]
                                                                  .approvedStatus ==
                                                              3
                                                          ? statusRejected()
                                                          : attendence[index]
                                                                          .approvedStatus ==
                                                                      1 &&
                                                                  attendence[index]
                                                                          .status ==
                                                                      "Present Panding"
                                                              ? presentStatusPending()
                                                              : absentStatusPending(),
                                                  SizedBox(
                                                    width: 20,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        showClockOutBottomSheet();
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
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  DateFormat("MMM").format(
                                                      DateTime.parse(
                                                          attendence[index]
                                                              .date!)),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  DateFormat("dd").format(
                                                      DateTime.parse(
                                                          attendence[index]
                                                              .date!)),
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
    );
  }

  void showClockOutBottomSheet() async {
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
                        height: 20,
                      ),
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

  Widget presentStatusPending() {
    return buttonPending();
  }

  Widget absentStatusPending() {
    return buttonPending();
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
      firstDate: DateTime(DateTime.now().year - 0),
      lastDate: DateTime(DateTime.now().year + 0, 12),
      initialDate: dateTime!,
      locale: const Locale("en"),
    ).then((date) {
      myProfileAttendenceBloc
          .add(MyProfileAttendenceSelectDateEvent(dateTime: date!));
    });
  }
}
