import 'package:equatable/equatable.dart';

class TeamMemberAttendenceEvents extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SelectDateEvent extends TeamMemberAttendenceEvents {
  final DateTime date;
  SelectDateEvent({required this.date});
  @override
  List<Object?> get props => [date];
}

class IncrementDateEvent extends TeamMemberAttendenceEvents {
  final DateTime date;
  IncrementDateEvent({required this.date});
  @override
  List<Object?> get props => [date];
}

class DecrementDateEvent extends TeamMemberAttendenceEvents {
  final DateTime date;
  DecrementDateEvent({required this.date});
  @override
  List<Object?> get props => [date];
}
