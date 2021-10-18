import 'package:equatable/equatable.dart';

class ClockInOutStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClockInOutInitialState extends ClockInOutStates {}

class ClockInOutSuccessState extends ClockInOutStates {
  String date;
  int currentHours;
  int currentMinutes;
  int currentSeconds;
  String at;
  String seperator;

  ClockInOutSuccessState({
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

class ClockInOutTimerState extends ClockInOutStates {
  String timerHours;
  String timerMinutes;
  String timerSeconds;
  ClockInOutTimerState(
      {required this.timerHours,
      required this.timerMinutes,
      required this.timerSeconds});
  @override
  List<Object?> get props => [timerHours, timerMinutes, timerSeconds];
}
