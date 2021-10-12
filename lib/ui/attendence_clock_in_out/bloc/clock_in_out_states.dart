import 'package:equatable/equatable.dart';

class ClockInOutStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClockInOutInitialState extends ClockInOutStates {}

class ClockInOutCurrentNTPState extends ClockInOutStates {
  String date = "";
  int currentHours = 0;
  int currentMinutes = 0;
  int currentSeconds = 0;
  String at = "";
  String seperator = "";

  @override
  ClockInOutCurrentNTPState({
    required this.date,
    required this.currentHours,
    required this.currentMinutes,
    required this.currentSeconds,
    required this.at,
    required this.seperator,
  });

  List<Object?> get props => [
        this.date,
        this.currentHours,
        this.currentMinutes,
        this.currentSeconds,
        this.at,
        this.seperator
      ];
}
