import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_events.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_states.dart';
import 'package:sfa/ui/attendence_clock_in_out/model/clock_in_response.dart';
import 'package:sfa/ui/attendence_clock_in_out/model/clock_out_response.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';
import 'package:sfa/ui/pjp_by_date/model/pjp_by_date_model.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class ClockInOutBloc extends Bloc<ClockInOutEvents, ClockInOutStates> {
  ClockInOutBloc() : super(ClockInOutInitialState());

  @override
  Stream<ClockInOutStates> mapEventToState(event) async* {
    if (event is ClockInOutInitialEvent) {
      yield ClockInOutLoadingState();
      yield* getInitialData(event);
    }
    if (event is PjpByDateEvent) {
      yield ClockInOutLoadingState();
      yield* getPjpData(event);
    }
    if (event is ClockInSuccessEvent) {
      yield ClockInOutLoadingState();
      yield* clockInSuccess(event);
    }
    if (event is ClockOutSuccessEvent) {
      yield ClockInOutLoadingState();
      yield* clockOutSuccess(event);
    }

    if (event is ClockInOutGetUserLocationEvent) {
      yield ClockInOutLoadingState();
      yield* getUserLocation(event);
    }
  }
}

Stream<ClockInOutStates> getInitialData(ClockInOutInitialEvent event) async* {
  if (await Network.isConnected()) {
    DateTime _ntpTime;
    _ntpTime = await NTP.now();
    var format = DateFormat("dd-MMM-yyyy");

    String userId = await SharedPrefrence.getStringPreference("id");
    UserDetails response = await repository.getUserDetailsByUserId(userId);

    if (response.success) {
      yield ClockInOutInitialSuccessState(
        userData: response,
        date: format.format(_ntpTime),
        at: " at ",
        seperator: ":",
        ntpTime: _ntpTime,
      );
    } else {
      yield ClockInOutFailureState(failureMessage: response.message);
    }
  } else {
    yield ClockInOutFailureState(
        failureMessage: "Please check your internet connection!");
  }
}

Stream<ClockInOutStates> clockInSuccess(ClockInSuccessEvent event) async* {
  if (await Network.isConnected()) {
    DateTime _ntpTime;
    _ntpTime = await NTP.now();
    var format = DateFormat("yyyy-MM-dd");
    String userId = await SharedPrefrence.getStringPreference("id");

    ClockInResponse response = await repository.clockIn(
        userId,
        event.inOutTime,
        format.format(_ntpTime).toString(),
        event.workingPlan,
        File(event.selfieImage),
        event.latitude,
        event.longitude);
    if (response.success) {
      yield ClockInSuccessState(successMessage: response.message);
    } else {
      yield ClockInFailureState(failureMessage: response.message);
    }
  } else {
    yield ClockInOutFailureState(
        failureMessage: "Please check your internet connection!");
  }
}

Stream<ClockInOutStates> clockOutSuccess(ClockOutSuccessEvent event) async* {
  if (await Network.isConnected()) {
    DateTime _ntpTime;
    _ntpTime = await NTP.now();
    var format = DateFormat("yyyy-MM-dd");
    String userId = await SharedPrefrence.getStringPreference("id");

    ClockOutResponse response = await repository.clockOut(
      userId,
      event.inOutTime,
      format.format(_ntpTime).toString(),
      event.workingPlan,
      File(event.selfieImage),
    );
    if (response.success) {
      yield ClockOutSuccessState(successMessage: response.message);
    } else {
      yield ClockOutFailureState(failureMessage: response.message);
    }
  } else {
    yield ClockInOutFailureState(
        failureMessage: "Please check your internet connection!");
  }
}

Stream<ClockInOutStates> getPjpData(PjpByDateEvent event) async* {
  PjpByDateResponse response =
      await repository.pjpByDate(event.userId, event.date);

  if (response.success) {
    yield PjpByDateSuccessState(pjp: response.data!);
  } else {
    yield PjpByDateFailureState(message: response.message);
  }
}

Stream<ClockInOutStates> getUserLocation(
    ClockInOutGetUserLocationEvent event) async* {
  try {
    Position position = await location();
    double latitude = position.latitude;
    double longitude = position.longitude;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    String city = place.locality!;
    String state = place.administrativeArea!;
    String country = place.country!;
    String timeZone =
        "Time Zone in " + city + ", " + state + ", " + country + " (GMT+5:30)";

    yield ClockInOutGetUserLocationState(
        timeZone: timeZone, latitude: latitude, longitude: longitude);
  } catch (exception) {
    yield ClockInOutGetUserLocationState(
        timeZone: "Please turn on location to see time zone",
        latitude: 00.00,
        longitude: 00.00);
  }
}

Future<Position> location() async {
  bool serviceEnabled;
  LocationPermission permission;
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: "Please turn on the location for continue!");
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
