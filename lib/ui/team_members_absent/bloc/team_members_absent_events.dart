import 'package:equatable/equatable.dart';

class TeamMembersAbsentEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamMembersAbsentSuccessEvent extends TeamMembersAbsentEvents {
  final String currentDate;
  TeamMembersAbsentSuccessEvent({required this.currentDate});
  @override
  List<Object?> get props => [currentDate];
}

class AbsentApproveRejectEvent extends TeamMembersAbsentEvents {
  final String userId;
  final String absentStatus;
  final String userAttendenceId;

  AbsentApproveRejectEvent({
    required this.userId,
    required this.absentStatus,
    required this.userAttendenceId,
  });
  @override
  List<Object?> get props => [
        userId,
        absentStatus,
        userAttendenceId,
      ];
}
