import 'package:equatable/equatable.dart';

class ClockInOutStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClockInOutInitialState extends ClockInOutStates {}

class ClockInOutLoadingState extends ClockInOutStates {}

class ClockInOutInitialSuccessState extends ClockInOutStates {
  final String date;
  final int currentHours;
  final int currentMinutes;
  final int currentSeconds;
  final String at;
  final String seperator;

  ClockInOutInitialSuccessState({
    required this.date,
    required this.currentHours,
    required this.currentMinutes,
    required this.currentSeconds,
    required this.at,
    required this.seperator,
  });
  @override
  List<Object?> get props => [
        date,
        currentHours,
        currentMinutes,
        currentSeconds,
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

class ClockInOutTimerState extends ClockInOutStates {
  final String timerHours;
  final String timerMinutes;
  final String timerSeconds;
  ClockInOutTimerState(
      {required this.timerHours,
      required this.timerMinutes,
      required this.timerSeconds});
  @override
  List<Object?> get props => [timerHours, timerMinutes, timerSeconds];
}
