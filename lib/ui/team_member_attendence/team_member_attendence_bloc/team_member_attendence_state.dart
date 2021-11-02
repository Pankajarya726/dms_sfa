import 'package:equatable/equatable.dart';
import 'package:sfa/ui/team_member_attendence/model/attendance_model.dart';
import 'package:sfa/ui/team_members_absent/model/absent_approve_reject_response.dart';
import 'package:sfa/ui/team_members_clockout/model/clockin_approve_reject_model.dart';

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

class TeamMemberAttendenceLoadingState extends TeamMemberAttendenceState {}

class TeamMemberAttendenceSucessState extends TeamMemberAttendenceState {
  final AttendanceResponse response;
  TeamMemberAttendenceSucessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class TeamMemberAttendenceFailureState extends TeamMemberAttendenceState {
  final String message;
  TeamMemberAttendenceFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

class TeamMemberAttendenceApproveSuccessState
    extends TeamMemberAttendenceState {
  final ClockInApproveRes response;
  TeamMemberAttendenceApproveSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class TeamMemberAttendenceApproveFailureState
    extends TeamMemberAttendenceState {
  final String message;
  TeamMemberAttendenceApproveFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

class TeamMemberAttendenceAbsentApproveSuccessState
    extends TeamMemberAttendenceState {
  final AbsentApproveRejectResponse response;
  TeamMemberAttendenceAbsentApproveSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class TeamMemberAttendenceAbsentApproveFailureState
    extends TeamMemberAttendenceState {
  final String message;
  TeamMemberAttendenceAbsentApproveFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
