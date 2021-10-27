import 'package:equatable/equatable.dart';

class TeamMemberAttendenceState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TeamMemberAttendenceInitialState extends TeamMemberAttendenceState {}

class SelectDateState extends TeamMemberAttendenceState {
  final DateTime date;
  SelectDateState({required this.date});
  @override
  List<Object?> get props => [date];
}

class IncrementDateState extends TeamMemberAttendenceState {
  final DateTime date;
  IncrementDateState({required this.date});
  @override
  List<Object?> get props => [date];
}

class DecrementDateState extends TeamMemberAttendenceState {
  final DateTime date;
  DecrementDateState({required this.date});
  @override
  List<Object?> get props => [date];
}
