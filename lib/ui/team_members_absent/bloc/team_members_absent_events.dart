import 'package:equatable/equatable.dart';

class TeamMembersAbsentEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamMembersAbsentSuccessEvent extends TeamMembersAbsentEvents {
  final String currentDate;
  final String? filterName;
  final String? locationType;
  final String? location;
  TeamMembersAbsentSuccessEvent(
      {required this.currentDate,
      this.filterName,
      this.locationType,
      this.location});
  @override
  List<Object?> get props => [currentDate, filterName, locationType, location];
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
