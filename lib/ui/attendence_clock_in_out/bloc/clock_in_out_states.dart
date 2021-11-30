import 'package:equatable/equatable.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';

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

class ClockInOutGetUserLocationState extends ClockInOutStates {
  final String timeZone;
  final double latitude;
  final double longitude;
  final String city;
  final String state;
  final String country;
  ClockInOutGetUserLocationState({
    required this.timeZone,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.state,
    required this.country,
  });
  @override
  List<Object?> get props => [
        timeZone,
        latitude,
        longitude,
        city,
        state,
        country,
      ];
}
