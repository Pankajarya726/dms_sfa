import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/provider/repository.dart';
import 'package:sfa/ui/team_members_absent/bloc/team_members_absent_events.dart';
import 'package:sfa/ui/team_members_absent/bloc/team_members_absent_states.dart';
import 'package:sfa/ui/team_members_absent/model/get_absent_data_response.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class TeamMembersAbsentBloc
    extends Bloc<TeamMembersAbsentEvents, TeamMembersAbsentStates> {
  TeamMembersAbsentBloc() : super(TeamMembersAbsentInitialState());
  ApiRepository apiRepository = ApiRepository();

  @override
  Stream<TeamMembersAbsentStates> mapEventToState(
      TeamMembersAbsentEvents event) async* {
    if (event is TeamMembersAbsentSuccessEvent) {
      String userId = await SharedPrefrence.getStringPreference("id");
      GetAbsentDataResponse response =
          await apiRepository.getAbsentData(userId, event.currentDate);
      if (await Network.isConnected()) {
        if (response.success) {
          yield TeamMembersAbsentSuccessState(getAbsentDataResponse: response);
        } else {
          yield TeamMembersAbsentFailureState(failureMessage: response.message);
        }
      } else {
        yield TeamMembersAbsentFailureState(
            failureMessage: "Please check your internet connection");
      }
    } else {
      yield TeamMembersAbsentFailureState(
          failureMessage: "Something went wrong");
    }
  }
}
