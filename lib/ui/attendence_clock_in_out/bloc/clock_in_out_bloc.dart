import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_events.dart';
import 'package:sfa/ui/attendence_clock_in_out/bloc/clock_in_out_states.dart';
import 'package:sfa/ui/attendence_clock_in_out/model/clock_in_response.dart';
import 'package:sfa/ui/attendence_clock_in_out/model/clock_out_response.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';
import 'package:sfa/ui/pjp_screen/pjp_model/pjp_model.dart';
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
    if (event is ClockInSuccessEvent) {
      yield ClockInOutLoadingState();
      yield* clockInSuccess(event);
    }
    if (event is ClockOutSuccessEvent) {
      yield ClockInOutLoadingState();
      yield* clockOutSuccess(event);
    }
    // if (event is ClockInOutGetPjpSuccessEvent) {
    //   yield* getPjpDataEvent(event);
    // }
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
        currentHours: _ntpTime.hour,
        currentMinutes: _ntpTime.minute,
        currentSeconds: _ntpTime.second,
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
      ClockInSuccessState(successMessage: response.message);
    } else {
      yield ClockInFailureState(failureMessage: response.message);
    }
  } else {
    yield ClockInOutFailureState(
        failureMessage: "Please check your internet connection!");
  }
}

// Stream<ClockInOutStates> getPjpDataEvent(
//     ClockInOutGetPjpSuccessEvent event) async* {
//   if (await Network.isConnected()) {
//     DateTime _ntpTime = await NTP.now();
//     var month = DateFormat("MM").format(_ntpTime);
//     String userId =
//         await SharedPrefrence.getStringPreference(SharedPrefrence.id);
//     PjpResponse response =
//         await repository.getPjpData(userId, month.toString());

//     if (response.success) {
//       yield ClockInOutGetPjpSuccessState(pjpResponse: response);
//     } else {
//       yield ClockInOutGetPjpFailureState(failureMessage: response.message);
//     }
//   } else {
//     yield ClockInOutFailureState(
//         failureMessage: "Please check your internet connection!");
//   }
// }

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
      ClockOutSuccessState(successMessage: response.message);
    } else {
      yield ClockOutFailureState(failureMessage: response.message);
    }
  } else {
    yield ClockInOutFailureState(
        failureMessage: "Please check your internet connection!");
  }
}
