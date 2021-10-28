import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/ui/team_members/bloc/team_member_events.dart';
import 'package:sfa/ui/team_members/bloc/team_member_states.dart';

class TeamMembersBloc extends Bloc<TeamMemberEvents, TeamMemberStates> {
  TeamMembersBloc() : super(TeamMembersInitialState());

  @override
  Stream<TeamMemberStates> mapEventToState(TeamMemberEvents event) async* {
    if (event is TeamMemberInitialSuccessEvent) {
      yield* setInitialDate(event);
    }
    // if (event is TeamMembersPreviousDateEvent) {
    //   yield* setPreviousDate(event);
    // }
    // if (event is TeamMembersNextDateEvent) {
    //   yield* setNextDate(event);
    // }
    // if (event is TeamMembersSelectCalenderDateEvent) {
    //   yield* setDateByCalender(event);
    // }
  }

  Stream<TeamMemberStates> setInitialDate(
      TeamMemberInitialSuccessEvent event) async* {
    DateTime ntpTime;
    ntpTime = await NTP.now();
    var format = DateFormat("dd-MMM-yyyy");
    yield TeamMembersInitialSuccessState(
        currentDate: format.format(ntpTime).toString(), dateTime: ntpTime);
  }

  // Stream<TeamMemberStates> setPreviousDate(
  //   TeamMembersPreviousDateEvent event,
  // ) async* {
  //   yield TeamMembersPreviousDateState();
  // }

  // Stream<TeamMemberStates> setNextDate(TeamMembersNextDateEvent event) async* {
  //   yield TeamMembersNextDateState();
  // }

  // Stream<TeamMemberStates> setDateByCalender(
  //     TeamMembersSelectCalenderDateEvent event) async* {
  //   yield TeamMembersCalenderDateState();
  // }
}
