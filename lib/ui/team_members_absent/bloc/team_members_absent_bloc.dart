import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/provider/repository.dart';
import 'package:sfa/ui/team_members_absent/bloc/team_members_absent_events.dart';
import 'package:sfa/ui/team_members_absent/bloc/team_members_absent_states.dart';
import 'package:sfa/ui/team_members_absent/model/absent_approve_reject_response.dart';
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
      yield* getAbsentData(event);
    }
    if (event is AbsentApproveRejectEvent) {
      yield TeamMembersAbsentLoadingState();
      yield* absentApproveReject(event);
    }
  }

  Stream<TeamMembersAbsentStates> getAbsentData(
      TeamMembersAbsentSuccessEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPrefrence.getStringPreference("id");
      GetAbsentDataResponse response =
          await apiRepository.getAbsentData(userId, event.currentDate);
      if (response.success) {
        yield TeamMembersAbsentSuccessState(getAbsentDataResponse: response);
      } else {
        yield TeamMembersAbsentFailureState(failureMessage: response.message);
      }
    }
  }

  Stream<TeamMembersAbsentStates> absentApproveReject(
      AbsentApproveRejectEvent event) async* {
    if (await Network.isConnected()) {
      String absentApprovedBy = await SharedPrefrence.getStringPreference("id");
      AbsentApproveRejectResponse response =
          await repository.absentApproveReject(absentApprovedBy, event.userId,
              event.absentStatus, event.userAttendenceId);
      if (response.success) {
        yield AbsentApproveSuccessState(successMessage: response.message);
      } else {
        yield AbsentApproveSuccessState(successMessage: response.message);
      }
    } else {
      yield AbsentApproveSuccessState(
          successMessage: "Please check your internet connection!");
    }
  }
}
