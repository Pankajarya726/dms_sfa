import 'package:equatable/equatable.dart';

class TeamMembersDetailsState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TeamMembersDetailsInitialState extends TeamMembersDetailsState {}

class SelectDateState extends TeamMembersDetailsState {
  final DateTime date;
  SelectDateState({required this.date});
  @override
  List<Object?> get props => [date];
}

class IncrementDateState extends TeamMembersDetailsState {
  final DateTime date;
  IncrementDateState({required this.date});
  @override
  List<Object?> get props => [date];
}

class DecrementDateState extends TeamMembersDetailsState {
  final DateTime date;
  DecrementDateState({required this.date});
  @override
  List<Object?> get props => [date];
}
