import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_bloc.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_events.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_states.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/constants.dart';

class AttendenceClockInOut extends StatefulWidget {
  const AttendenceClockInOut({Key? key}) : super(key: key);

  @override
  _AttendenceClockInOutState createState() => _AttendenceClockInOutState();
}

class _AttendenceClockInOutState extends State<AttendenceClockInOut> {
  bool gpsLocation = false;
  bool clockInOut = false;
  String timerHours = "00";
  String timerMinutes = "00";
  String timerSeconds = "00";
  late StreamController<int> streamController;
  Duration timerInterval = const Duration(seconds: 1);
  var timerSubscription;
  var timerStream;
  late Timer? timer;
  int counter = 0;
  LatLng? currenPosition;
  Location location = Location();
  XFile? image;
  ClockInOutBloc clockInOutBloc = ClockInOutBloc();
  double latitude = 0.0;
  double longitude = 0.0;
  final workingPlan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => clockInOutBloc,
      child: BlocConsumer<ClockInOutBloc, ClockInOutStates>(
        listener: (context, state) {
          if (state is ClockInSuccessState) {
            Fluttertoast.showToast(msg: state.successMessage);
            clockInOutBloc.add(ClockInOutInitialEvent());
          }
          if (state is ClockInFailureState) {
            Fluttertoast.showToast(msg: state.failureMessage);
            clockInOutBloc.add(ClockInOutInitialEvent());
          }
        },
        builder: (context, state) {
          if (state is ClockInOutInitialState) {
            clockInOutBloc.add(ClockInOutInitialEvent());
          }
          if (state is ClockInOutLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ClockInOutInitialSuccessState) {
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
                      gradient: clockInOut == false
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
                              "${state.date}${state.at}${state.currentHours}${state.seperator}${state.currentMinutes}",
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
                            "$timerHours:$timerMinutes:$timerSeconds",
                            style: const TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                  commonTextField("PJP", 17.0, 3, true),
                  const SizedBox(
                    height: 20,
                  ),
                  workingPlanTextField(),
                  const SizedBox(
                    height: 20,
                  ),
                  clockInOut == false
                      ? const Text(
                          "Clock In Selfie",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        )
                      : const Text(
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
                      _imgFromCamera();
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
                            child: Image.asset(
                              "assets/camera.png",
                              width: 10,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
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
                  clockInOut == false
                      ? Row(
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
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  roundedButtonWithIcon(context),
                ],
              ),
            );
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

  Widget roundedButtonWithIcon(context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            clockInOut = !clockInOut;
          });
          if (clockInOut) {
            clockInOutBloc.add(
              ClockInSuccessEvent(
                  inOutTime: "03:44:12",
                  workingPlan: "self work",
                  selfieImage: "report.png",
                  latitude: "22.45566",
                  longitude: "75.23455"),
            );
            timerStream = stopWatchStream();
            timerSubscription = timerStream!.listen((int newTick) {
              setState(() {
                timerHours = ((newTick / (60 * 60)) % 60)
                    .floor()
                    .toString()
                    .padLeft(2, '0');
                timerMinutes =
                    ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
                timerSeconds =
                    (newTick % 60).floor().toString().padLeft(2, '0');
              });
            });
          } else {
            timerSubscription.cancel();
            timerStream = null;
            setState(() {
              timerHours = '00';
              timerMinutes = '00';
              timerSeconds = '00';
            });
          }
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(180, 50)),
          backgroundColor: clockInOut == false
              ? MaterialStateProperty.all(colorGreen)
              : MaterialStateProperty.all(colorPrimary),
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
            clockInOut == false
                ? const Text(
                    "Clock In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                : const Text(
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

  Future getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      print("permission denied");
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    LocationData position = await location.getLocation();
    setState(() {
      currenPosition = LatLng(position.latitude!, position.longitude!);
      latitude = position.latitude!;
      longitude = position.longitude!;
      print("lat = $latitude");
      print("lon = $longitude");
    });
  }

  Widget commonTextField(headingText, myFontSize, myMaxLines, enableDisable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headingText,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: myFontSize,
          ),
        ),
        TextFormField(
          readOnly: enableDisable,
          maxLines: myMaxLines,
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

  Widget workingPlanTextField() {
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
                // constraints: const BoxConstraints(),
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
        TextFormField(
          // controller: workingPlan,
          maxLines: 3,
          readOnly: true,
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

  Stream<int> stopWatchStream() {
    void stopTimer() {
      timer?.cancel();
      counter = 0;
      streamController.close();
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  _imgFromCamera() async {
    XFile? image = await ImagePicker.platform
        .getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      image = image;
    });
  }

  void showUpdateAndConfirmBottomSheet() async {
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
                      commonTextField("Working Plan", 20.0, 5, false),
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

  Widget roundedButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
}
