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

class GetTeamMemberAttendenceEvent extends TeamMemberAttendenceEvents {
  final String id;
  final String date;
  GetTeamMemberAttendenceEvent({required this.id, required this.date});
  @override
  List<Object?> get props => [id, date];
}

class TeamMemberAttendenceApproveEvent extends TeamMemberAttendenceEvents {
  final String id;
  final String status;
  final String approvedBy;
  TeamMemberAttendenceApproveEvent(
      {required this.id, required this.status, required this.approvedBy});
  @override
  List<Object?> get props => [id, status, approvedBy];
}
