import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_bloc.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_events.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_states.dart';
import 'package:sfa/utility/colors.dart';

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
  late Timer timer;
  int counter = 0;
  LatLng? currenPosition;
  Location location = Location();
  XFile? _image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Future getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

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
    });
    debugPrint("Current Position" + currenPosition.toString());
    _locationData = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
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
                BlocProvider(
                  create: (context) => ClockInOutBloc(),
                  child: BlocBuilder<ClockInOutBloc, ClockInOutStates>(
                    builder: (context, state) {
                      return BlocBuilder<ClockInOutBloc, ClockInOutStates>(
                        builder: (context, state) {
                          if (state is ClockInOutInitialState) {
                            BlocProvider.of<ClockInOutBloc>(context)
                                .add(ClockInOutInitialEvent());
                          }
                          if (state is ClockInOutCurrentNTPState) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                            );
                          }
                          return const Text(
                            "",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    "$timerHours:$timerMinutes:$timerSeconds",
                    style: const TextStyle(
                      fontSize: 50.0,
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
          clockInOutTextField(),
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
          Container(
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
            child: Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(55),
              child: const Image(
                image: AssetImage("assets/camera.png"),
                fit: BoxFit.cover,
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

  Widget roundedButtonWithIcon(context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            clockInOut = !clockInOut;
          });
          if (clockInOut) {
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

  Widget clockInOutTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Working plan",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        TextFormField(
          maxLines: 4,
          keyboardType: TextInputType.text,
          style: const TextStyle(
            color: Color(0xff303030),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorPrimary),
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
      timer.cancel();
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
    // XFile? image = await ImagePicker.pickImage(
    //   source: ImageSource.camera,
    //   imageQuality: 50,
    // );
  }
}
