import 'package:equatable/equatable.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';
import 'package:sfa/ui/pjp_by_date/model/pjp_by_date_model.dart';
import 'package:sfa/ui/pjp_screen/pjp_model/pjp_model.dart';

class ClockInOutStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClockInOutInitialState extends ClockInOutStates {}

class ClockInOutLoadingState extends ClockInOutStates {}

class ClockInOutInitialSuccessState extends ClockInOutStates {
  final UserDetails userData;
  final String date;
  final DateTime ntpTime;

  final String at;
  final String seperator;

  ClockInOutInitialSuccessState({
    required this.userData,
    required this.date,
    required this.ntpTime,
    required this.at,
    required this.seperator,
  });
  @override
  List<Object?> get props => [
        date,
        ntpTime,
        at,
        seperator,
      ];
}

class ClockInOutFailureState extends ClockInOutStates {
  final String failureMessage;
  ClockInOutFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}

class ClockInSuccessState extends ClockInOutStates {
  final String successMessage;
  ClockInSuccessState({required this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class ClockInFailureState extends ClockInOutStates {
  final String failureMessage;
  ClockInFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}

class ClockOutSuccessState extends ClockInOutStates {
  final String successMessage;
  ClockOutSuccessState({required this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class ClockOutFailureState extends ClockInOutStates {
  final String failureMessage;
  ClockOutFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}

class ClockInOutGetPjpSuccessState extends ClockInOutStates {
  final PjpResponse pjpResponse;
  ClockInOutGetPjpSuccessState({required this.pjpResponse});
  @override
  List<Object?> get props => [pjpResponse];
}

class ClockInOutGetPjpFailureState extends ClockInOutStates {
  final String failureMessage;
  ClockInOutGetPjpFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}

class ClockInOutGetUserLocationState extends ClockInOutStates {
  final String timeZone;
  final double latitude;
  final double longitude;
  ClockInOutGetUserLocationState({
    required this.timeZone,
    required this.latitude,
    required this.longitude,
  });
  @override
  List<Object?> get props => [
        timeZone,
        latitude,
        longitude,
      ];
}

class PjpByDateFailureState extends ClockInOutStates {
  final String message;
  PjpByDateFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

class PjpByDateSuccessState extends ClockInOutStates {
  final List<PjpByDate> pjp;
  PjpByDateSuccessState({required this.pjp});
  @override
  List<Object?> get props => [pjp];
}
