import 'package:equatable/equatable.dart';

class TeamMemberStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamMembersInitialState extends TeamMemberStates {}

class TeamMembersInitialSuccessState extends TeamMemberStates {
  final String currentDate;
  TeamMembersInitialSuccessState({required this.currentDate});
  @override
  List<Object?> get props => [currentDate];
}

class TeamMembersPreviousDateState extends TeamMemberStates {}

class TeamMembersNextDateState extends TeamMemberStates {}

class TeamMembersCalenderDateState extends TeamMemberStates {}
