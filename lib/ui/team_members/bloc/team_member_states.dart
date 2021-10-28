import 'package:equatable/equatable.dart';

class TeamMemberStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamMembersInitialState extends TeamMemberStates {}

class TeamMembersInitialSuccessState extends TeamMemberStates {
  final String currentDate;
  late final DateTime dateTime;
  TeamMembersInitialSuccessState(
      {required this.currentDate, required this.dateTime});
  @override
  List<Object?> get props => [currentDate, dateTime];
}

class TeamMembersPreviousDateState extends TeamMemberStates {
  final String previousDate;
  TeamMembersPreviousDateState({required this.previousDate});
  @override
  List<Object?> get props => [previousDate];
}

class TeamMembersNextDateState extends TeamMemberStates {
  final String nextDate;
  TeamMembersNextDateState({required this.nextDate});
  @override
  List<Object?> get props => [nextDate];
}

class TeamMembersCalenderDateState extends TeamMemberStates {}
