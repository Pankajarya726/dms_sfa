import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:location/location.dart';
import 'package:ntp/ntp.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_bloc.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_events.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_states.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_bloc.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_event.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_state.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class AttendenceClockInOut extends StatefulWidget {
  const AttendenceClockInOut({Key? key}) : super(key: key);

  @override
  _AttendenceClockInOutState createState() => _AttendenceClockInOutState();
}

class _AttendenceClockInOutState extends State<AttendenceClockInOut> {
  bool gpsLocation = false;
  String timerHours = "00";
  String timerMinutes = "00";
  String timerSeconds = "00";
  Duration timerInterval = const Duration(seconds: 1);
  var timerSubscription;
  Timer? timer;
  LatLng? currenPosition;
  XFile? image;
  ClockInOutBloc clockInOutBloc = ClockInOutBloc();
  PjpByDateBloc pjpByDateBloc = PjpByDateBloc();
  double latitude = 0.0;
  double longitude = 0.0;
  int time = 0;
  Duration duration = const Duration(seconds: 0, hours: 0, minutes: 0);
  TextEditingController workingPlanController = TextEditingController();
  TextEditingController pjpController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  String workingPlan = "";
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  String webtime = "";
  int clockInStatus = 0;
  late DateTime _ntpTime;
  DateTime? clockInTime;
  DateTime? clockOutTime;
  String timeDifference = "00:00:00";
  int checkSuccessHours = 0;
  String userId = "";
  StreamController<String> timerController = StreamController();
  final stopWatch = PublishSubject<int>();
  String locality = "";
  String administrativeArea = "";
  String country = "";
  // Location location = Location();
  String pjpText = "";
  int workingPlanTextcount = 0;
  String timeZone = "";

  @override
  void initState() {
    super.initState();
    getTime();
    getUserId();
    getUserLocation();
  }

  @override
  void dispose() {
    timerController.close();
    stopWatch.sink.close();
    stopWatch.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClockInOutBloc>(
          create: (BuildContext context) => clockInOutBloc,
        ),
        BlocProvider<PjpByDateBloc>(
          create: (BuildContext context) => pjpByDateBloc,
        ),
      ],
      child: BlocConsumer<ClockInOutBloc, ClockInOutStates>(
        listener: (context, state) {
          if (state is ClockInSuccessState) {
            clockInOutBloc.add(ClockInOutInitialEvent());
            Fluttertoast.showToast(msg: state.successMessage);
          }
          if (state is ClockInFailureState) {
            clockInOutBloc.add(ClockInOutInitialEvent());
            Fluttertoast.showToast(msg: state.failureMessage);
          }
          if (state is ClockOutSuccessState) {
            clockInOutBloc.add(ClockInOutInitialEvent());
            Fluttertoast.showToast(msg: state.successMessage);
          }
          if (state is ClockOutFailureState) {
            clockInOutBloc.add(ClockInOutInitialEvent());
            Fluttertoast.showToast(msg: state.failureMessage);
          }
          if (state is ClockInOutInitialSuccessState) {
            if (state.userData.data!.clockInOutData.isNotEmpty) {
              clockInStatus =
                  state.userData.data!.clockInOutData.first.inOutStatus;
            }

            if (clockInStatus == 1) {
              clockInTime = DateFormat("HH:mm:ss")
                  .parse(state.userData.data!.clockInOutData.first.clockInTime);

              startAttendenceTimer(clockInTime!);
            } else if (clockInStatus == 2) {
              clockInTime = DateFormat("HH:mm:ss")
                  .parse(state.userData.data!.clockInOutData.first.clockInTime);
              clockOutTime = DateFormat("HH:mm:ss").parse(
                  state.userData.data!.clockInOutData.first.clockOutTime);
            }
          }
        },
        builder: (context, state) {
          if (state is ClockInOutInitialState) {
            clockInOutBloc.add(ClockInOutInitialEvent());
          }
          if (state is ClockInOutLoadingState) {
            waitForSeconds();
            getUserPosition();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ClockInOutInitialSuccessState) {
            getUserPosition();
            waitForSeconds();
            timeZone = "Time Zone in " +
                locality +
                ", " +
                administrativeArea +
                " (GMT+5:30)";
            print("timezone $timeZone");

            if (clockInStatus == 1) {
              return clockInLayout();
            } else {
              if (state.userData.data!.clockInOutData.isNotEmpty) {
                for (int i = 0;
                    i < state.userData.data!.clockInOutData.length;
                    i++) {
                  if (state.userData.data!.clockInOutData[i].clockInTime
                          .isNotEmpty &&
                      state.userData.data!.clockInOutData[i].clockOutTime
                          .isNotEmpty) {
                    clockInTime = DateFormat("HH:mm:ss").parse(
                        state.userData.data!.clockInOutData.first.clockInTime);
                    clockOutTime = DateFormat("HH:mm:ss").parse(
                        state.userData.data!.clockInOutData.first.clockOutTime);
                    timeDifference =
                        (clockOutTime!.difference(clockInTime!)).toString();
                    var arr = timeDifference.split(".");
                    timeDifference = arr[0];
                    var arr2 = timeDifference.split(":");
                    int hrs = int.parse(arr2[0]);
                    timeDifference = arr2[0].padLeft(2, '0');
                    timeDifference =
                        timeDifference + ":" + arr2[1].padLeft(2, '0');
                    timeDifference =
                        timeDifference + ":" + arr2[2].padLeft(2, '0');
                    return clockOutLayout(timeDifference, hrs);
                  } else {
                    return clockOutLayout(timeDifference, checkSuccessHours);
                  }
                }
              } else {
                return clockOutLayout(timeDifference, checkSuccessHours);
              }
            }
          }

          if (state is ClockInOutFailureState) {
            return Center(
              child: Text(state.failureMessage),
            );
          }

          return Container();
        },
      ),
    );
  }

  waitForSeconds() async {
    await Future.delayed(const Duration(seconds: 5));
  }

// initially we have to view clockOutLayout
  Widget clockOutLayout(timeDifference, workingHrs) {
    return BlocBuilder<PjpByDateBloc, PjpByDateState>(
      builder: (context, state) {
        if (state is PjpByDateInitialState) {
          pjpByDateBloc.add(PjpByDateEvent(
              date: DateFormat("yyyy-MM-dd").format(_ntpTime), userId: userId));
        }
        if (state is PjpByDateSuccessState) {
          if (state.response.data!.isNotEmpty || state.response.data != null) {
            for (int i = 0; i < state.response.data!.length; i++) {
              pjpText = state.response.data![i].pjpDescription;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        gradient: workingHrs < 8
                            ? const LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [colorPrimary, colorLightPrimary],
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${DateFormat("dd MMM yyyy").format(_ntpTime)} at ${DateFormat().add_jm().format(_ntpTime)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
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
                                    child: Image.asset("assets/zone-clock.png"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  flex: 20,
                                  child: locality.isNotEmpty
                                      ? Text(
                                          timeZone,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        )
                                      : const Text(
                                          "",
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
                    pjpTextField(state.response.data![i].pjpDescription),
                    const SizedBox(
                      height: 20,
                    ),
                    workingPlanTextField(
                        state.response.data![i].pjpDescription),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Clock In Selfie",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        log("controller ${workingPlanController.text}");
                        log("controller ${workingPlan}");
                        _imgFromCamera(context);
                      },
                      child: image == null
                          ? Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
                              child: Align(
                                child: Image.asset(
                                  "assets/camera.png",
                                  width: 50,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                child: Image.file(
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: const CircleBorder(),
                            value: gpsLocation,
                            activeColor: colorPrimary,
                            checkColor: Colors.white,
                            onChanged: (value) {
                              getUserLocation();
                              setState(() {
                                gpsLocation = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            getUserLocation();
                            setState(() {
                              gpsLocation = !gpsLocation;
                            });
                          },
                          child: const Text(
                            "GPS location",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    clockInButtonWithIcon(context),
                  ],
                ),
              );
            }
          }
        }
        if (state is PjpByDateFailureState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    gradient: workingHrs < 8
                        ? const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [colorPrimary, colorLightPrimary],
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${DateFormat("dd MMM yyyy").format(_ntpTime)} at ${DateFormat().add_jm().format(_ntpTime)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
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
                                child: Image.asset("assets/zone-clock.png"),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              flex: 20,
                              child: locality.isNotEmpty
                                  ? Text(
                                      timeZone,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    )
                                  : const Text(
                                      "",
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
                pjpTextField("PJP not found"),
                const SizedBox(
                  height: 20,
                ),
                workingPlanTextField(""),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Clock In Selfie",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    _imgFromCamera(context);
                  },
                  child: image == null
                      ? Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                          ),
                          child: Align(
                            child: Image.asset(
                              "assets/camera.png",
                              width: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      : Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: const CircleBorder(),
                        value: gpsLocation,
                        activeColor: colorPrimary,
                        checkColor: Colors.white,
                        onChanged: (value) {
                          getUserLocation();
                          setState(() {
                            gpsLocation = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        getUserLocation();
                        setState(() {
                          gpsLocation = !gpsLocation;
                        });
                      },
                      child: const Text(
                        "GPS location",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                clockInButtonWithIcon(context),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget clockInLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              gradient: checkSuccessHours < 8
                  ? const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [colorPrimary, colorLightPrimary],
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${DateFormat("dd MMM yyyy").format(_ntpTime)} at ${DateFormat().add_jm().format(_ntpTime)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: StreamBuilder<String>(
                    stream: timerController.stream,
                    builder: (context, snap) {
                      if (snap.hasData && snap.data!.isNotEmpty) {
                        String timerHrss = snap.data!;
                        var arr = timerHrss.split(":");
                        String hrs = arr[0];
                        String min = arr[1];
                        String sec = arr[2];
                        return Text(
                          "${hrs.padLeft(2, '0')}:${min.padLeft(2, '0')}:${sec.padLeft(2, '0')}",
                          style: const TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 5,
                          ),
                        );
                      }

                      return Text(
                        "$timerHours:$timerMinutes:$timerSeconds",
                        style: const TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 5,
                        ),
                      );
                    },
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
                          child: Image.asset("assets/zone-clock.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Flexible(
                        flex: 20,
                        child: Text(
                          "Time zone in Indore, Madhya Pradesh (GMT+5:30)",
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
          commentTextField(),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Clock Out Selfie",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              _imgFromCamera(context);
            },
            child: image == null
                ? Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: Align(
                      child: Image.asset(
                        "assets/camera.png",
                        width: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: Image.file(
                        File(image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
          const SizedBox(
            height: 70,
          ),
          clockOutButtonWithIcon(context),
        ],
      ),
    );
  }

  Widget clockOutButtonWithIcon(context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          getCurrentTime();
          webtime = "${_ntpTime.hour}:${_ntpTime.minute}:${_ntpTime.second}";
          await Future.delayed(const Duration(seconds: 1));

          setState(() {
            if (commentController.text.isNotEmpty) {
              if (image != null) {
                clockInOutBloc.add(
                  ClockOutSuccessEvent(
                    inOutTime: webtime,
                    workingPlan: commentController.text,
                    selfieImage: image!.path,
                  ),
                );
                image = null;
                stopAttendenceTimer();
              } else {
                Fluttertoast.showToast(msg: "Please select image");
              }
            } else {
              Fluttertoast.showToast(msg: "Please add comment");
            }
          });
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(180, 50)),
          backgroundColor: MaterialStateProperty.all(colorPrimary),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/clock.png",
              width: 25,
              fit: BoxFit.fill,
            ),
            const SizedBox(width: 10),
            const Text(
              "Clock Out",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clockInButtonWithIcon(context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          getCurrentTime();
          if (workingPlanController.text.isNotEmpty) {
            if (image != null) {
              if (latitude != 0.0 && longitude != 0.0) {
                await Future.delayed(const Duration(seconds: 1));
                clockInOutBloc.add(
                  ClockInSuccessEvent(
                    inOutTime: webtime,
                    workingPlan: workingPlanController.text,
                    selfieImage: image!.path,
                    latitude: latitude.toString(),
                    longitude: longitude.toString(),
                  ),
                );

                image = null;
                // startAttendenceTimer();
              } else {
                Fluttertoast.showToast(msg: "Please turn on GPS location");
                getUserLocation();
              }
            } else {
              Fluttertoast.showToast(msg: "Please select image");
            }
          } else {
            Fluttertoast.showToast(msg: "Please enter working plan");
          }
          setState(() {});
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(180, 50)),
          backgroundColor: MaterialStateProperty.all(colorGreen),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/clock.png",
              width: 25,
              fit: BoxFit.fill,
            ),
            const SizedBox(width: 10),
            const Text(
              "Clock In",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget editWorkingPlanTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Working Plan",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Form(
          key: formKey,
          child: TextFormField(
            maxLines: 5,
            controller: workingPlanController,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              workingPlan = value;
            },
            style: const TextStyle(
              color: Color(0xff303030),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Cannot be empty";
              } else {
                return null;
              }
            },
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
        ),
      ],
    );
  }

  Widget pjpTextField(pjpText) {
    pjpController = TextEditingController(text: pjpText);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PJP",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        TextFormField(
          controller: pjpController,
          readOnly: true,
          maxLines: 3,
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

  Widget commentTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Comment",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Form(
          key: formKey2,
          child: TextFormField(
            controller: commentController,
            maxLines: 3,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Color(0xff303030),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Cannot be empty";
              } else {
                return null;
              }
            },
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
        ),
      ],
    );
  }

  Widget workingPlanTextField(workingPlanText) {
    if (workingPlanText != "") {
      if (workingPlanTextcount == 0) {
        workingPlanController = TextEditingController(text: workingPlanText);
      }
    }
    workingPlanTextcount++;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                "Working Plan",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(
              height: 30,
              child: IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                onPressed: () {},
                icon: Image.asset(
                  "assets/confirm.png",
                  width: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: 30,
              child: IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                onPressed: () {
                  showUpdateAndConfirmBottomSheet();
                },
                icon: Image.asset(
                  "assets/update.png",
                  width: 30,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
        Form(
          key: formKey3,
          child: TextFormField(
            maxLines: 3,
            readOnly: true,
            controller: workingPlanController,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Color(0xff303030),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Cannot be empty";
              } else {
                return null;
              }
            },
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
        ),
      ],
    );
  }

  Widget roundedButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            Navigator.pop(context);
          }
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          backgroundColor: MaterialStateProperty.all(colorPrimary),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: const Text(
          "Update & Confirm",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  // Future getUserLocation() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();

  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();

  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   LocationData position = await location.getLocation();
  //   setState(() {
  //     currenPosition = LatLng(position.latitude!, position.longitude!);
  //     latitude = position.latitude!;
  //     longitude = position.longitude!;
  //     print("lat = $latitude");
  //     print("lon = $longitude");
  //   });
  // }

  _imgFromCamera(context) async {
    XFile? image = await ImagePicker.platform
        .getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      this.image = image;
    });
  }

  showUpdateAndConfirmBottomSheet() async {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      editWorkingPlanTextField(),
                      const SizedBox(
                        height: 20,
                      ),
                      roundedButton(),
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

  getCurrentTime() async {
    _ntpTime = await NTP.now();
    webtime = DateFormat().add_Hms().format(_ntpTime);
    clockOutTime = DateFormat().add_Hms().parse(webtime);
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

      //check the timer box color green/red
      checkSuccessHours = int.parse("${Duration(seconds: time).inHours}");
      int checkSec = int.parse("${Duration(seconds: time).inSeconds % 60}");
      if (checkSuccessHours >= 8 && checkSec == 0) {
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

  getTime() async {
    _ntpTime = await NTP.now();
  }

  getUserId() async {
    userId = await SharedPrefrence.getStringPreference("id");
  }

  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.getCurrentPosition()
          .then((value) => clockInOutBloc.add(ClockInOutInitialEvent()));
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getUserPosition() async {
    Position position = await getUserLocation();
    latitude = position.latitude;
    longitude = position.longitude;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    locality = place.locality!;
    administrativeArea = place.administrativeArea!;
    country = place.country!;
  }
}
