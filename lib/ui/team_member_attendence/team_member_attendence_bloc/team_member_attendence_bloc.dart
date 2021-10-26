import 'package:flutter_bloc/flutter_bloc.dart';
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
  }
}
