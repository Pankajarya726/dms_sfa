import 'package:equatable/equatable.dart';

class ClockOutStates extends Equatable {
  @override
  List<Object> get props => [];
}

class ClockOutInitialState extends ClockOutStates {}

class ClockOutSuccessState extends ClockOutStates {
  String date;
  int currentHours;
  int currentMinutes;
  int currentSeconds;
  String at;
  String seperator;
  ClockOutSuccessState({
    required this.date,
    required this.currentHours,
    required this.currentMinutes,
    required this.currentSeconds,
    required this.at,
    required this.seperator,
  });
  @override
  List<Object> get props => [
        date,
        currentHours,
        currentMinutes,
        currentSeconds,
        at,
        seperator,
      ];
}
