import 'package:equatable/equatable.dart';

class ClockInStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClockInInitialState extends ClockInStates {}

class ClockInSuccessState extends ClockInStates {
  String date;
  int currentHours;
  int currentMinutes;
  int currentSeconds;
  String at;
  String seperator;

  ClockInSuccessState({
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

class ClockInTimerState extends ClockInStates {
  String timerHours;
  String timerMinutes;
  String timerSeconds;
  ClockInTimerState(
      {required this.timerHours,
      required this.timerMinutes,
      required this.timerSeconds});
  @override
  List<Object?> get props => [timerHours, timerMinutes, timerSeconds];
}
