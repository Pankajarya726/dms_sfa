import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/model/attendance_model.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/team_member_attendence_event.dart';
import 'package:sfa/ui/team_member_attendence/team_member_attendence_bloc/team_member_attendence_state.dart';

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
}
