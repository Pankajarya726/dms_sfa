import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/model/attendance_model.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/team_member_attendence_event.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/team_member_attendence_state.dart';
import 'package:sfa/ui/team_members_absent/model/absent_approve_reject_response.dart';
import 'package:sfa/ui/team_members_clockout/model/clockin_approve_reject_model.dart';

class TeamMemberAttendenceBloc
    extends Bloc<TeamMemberAttendenceEvents, TeamMemberAttendenceState> {
  TeamMemberAttendenceBloc() : super(TeamMemberAttendenceInitialState());
  @override
  Stream<TeamMemberAttendenceState> mapEventToState(
      TeamMemberAttendenceEvents event) async* {
    if (event is SelectDateEvent) {
      yield SelectDateState(date: event.date);
    }
    if (event is IncrementDateEvent) {
      yield IncrementDateState(date: event.date);
    }
    if (event is DecrementDateEvent) {
      yield DecrementDateState(date: event.date);
    }
    if (event is GetTeamMemberAttendenceEvent) {
      yield TeamMemberAttendenceLoadingState();
      yield* getAttendence(event);
    }
    if (event is TeamMemberAttendenceApproveEvent) {
      yield* presentApprove(event);
    }
    if (event is TeamMemberAttendenceAbsentApproveEvent) {
      yield* absentApprove(event);
    }
  }

  Stream<TeamMemberAttendenceState> getAttendence(
      GetTeamMemberAttendenceEvent event) async* {
    AttendanceResponse response =
        await repository.getTeamMembersAttendence(event.id, event.date);
    if (response.success) {
      List<AttendenceModel> attendenceList = [];

      attendenceList.addAll(response.clockInData!);
      attendenceList.addAll(response.absentData!);

      attendenceList.sort((a, b) => a.date!.compareTo(b.date!));

      yield TeamMemberAttendenceSucessState(attendenceList: attendenceList);
    } else {
      yield TeamMemberAttendenceFailureState(message: response.message);
    }
  }

  Stream<TeamMemberAttendenceState> presentApprove(
      TeamMemberAttendenceApproveEvent event) async* {
    ClockInApproveRes response = await repository.clockInApprovReject(
        event.id, event.userId, event.status, event.approvedBy);
    log(response.message);
    if (response.success) {
      yield TeamMemberAttendenceApproveSuccessState(response: response);
    } else {
      yield TeamMemberAttendenceApproveFailureState(message: response.message);
    }
  }

  Stream<TeamMemberAttendenceState> absentApprove(
      TeamMemberAttendenceAbsentApproveEvent event) async* {
    AbsentApproveRejectResponse response = await repository.absentApproveReject(
        event.approvedBy, event.userId, event.status, event.id);
    log(response.message);
    if (response.success) {
      yield TeamMemberAttendenceAbsentApproveSuccessState(response: response);
    } else {
      yield TeamMemberAttendenceAbsentApproveFailureState(
          message: response.message);
    }
  }
}
