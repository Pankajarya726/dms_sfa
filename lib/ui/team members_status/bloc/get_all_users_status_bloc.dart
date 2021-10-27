import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/team%20members_status/bloc/get_all_users_status_events.dart';
import 'package:sfa/ui/team%20members_status/bloc/get_all_users_status_states.dart';
import 'package:sfa/ui/team%20members_status/model/get_all_users_status.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class GetAllUserStatusBloc
    extends Bloc<GetAllUserStatusEvents, GetAllUserStatusStates> {
  GetAllUserStatusBloc() : super(GetAllUserStatusInitialState());

  @override
  Stream<GetAllUserStatusStates> mapEventToState(
      GetAllUserStatusEvents event) async* {
    if (event is GetAllUserStatusInitialEvent) {
      yield* getAllUsersStatus(event);
    }
  }

  Stream<GetAllUserStatusStates> getAllUsersStatus(
      GetAllUserStatusInitialEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPrefrence.getStringPreference("id");
      GetAllUsersStatusResponse response =
          await repository.getAllUsersStatus(userId, event.statusDate);
      if (response.success) {
        yield GetAllUserStatusInitialSuccessState(
            getAllUsersStatusResponse: response);
      } else {
        yield GetAllUserStatusFailureState(failureMessage: response.message);
      }
    } else {
      yield GetAllUserStatusFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }
}
