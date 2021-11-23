import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/team_members_details_screen/model/team_members_details_model.dart';
import 'package:sfa/ui/team_members_details_screen/team_members_details_bloc/team_members_details_event.dart';
import 'package:sfa/ui/team_members_details_screen/team_members_details_bloc/team_members_details_state.dart';
import 'package:sfa/utility/network.dart';

class TeamMembersDetailsBloc
    extends Bloc<TeamMembersDetailsEvents, TeamMembersDetailsState> {
  TeamMembersDetailsBloc() : super(TeamMembersDetailsInitialState());
  @override
  Stream<TeamMembersDetailsState> mapEventToState(
      TeamMembersDetailsEvents event) async* {
    if (event is SelectDateEvent) {
      yield SelectDateState(date: event.date);
    }
    if (event is DateIncrementEvent) {
      yield IncrementDateState(date: event.date);
    }
    if (event is DateDecrementEvent) {
      yield DecrementDateState(date: event.date);
    }
    if (event is GetTeamMembersDetailsEvents) {
      yield TeamMembersDetailsLoadingState();
      yield* getData(event);
    }
  }

  Stream<TeamMembersDetailsState> getData(
      GetTeamMembersDetailsEvents event) async* {
    if (await Network.isConnected()) {
      DateTime d = DateTime.parse(event.date);
      if (d.weekday != 7) {
        DetailsStatusResponse response =
            await repository.getTeamMembersDetails(event.id, event.date);
        if (response.success) {
          yield TeamMembersDetailsSuccessState(response: response);
        } else {
          yield TeamMembersDetailsFailureState(message: response.message);
        }
      } else {
        yield TeamMembersDetailsFailureState(message: "Weekend Off");
      }
    } else {
      yield TeamMembersDetailsFailureState(
          message: "Please check your internet connection!");
    }
  }
}
