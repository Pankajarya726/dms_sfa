import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_events.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_states.dart';
import 'package:sfa/ui/team_members_clockout/model/get_clock_in_data_response.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class GetClockInDataBloc
    extends Bloc<GetClockInDataEvents, GetClockInDataStates> {
  GetClockInDataBloc() : super(GetClockInDataInitialState());

  @override
  Stream<GetClockInDataStates> mapEventToState(
      GetClockInDataEvents event) async* {
    yield* getClockInData(event);
  }

  Stream<GetClockInDataStates> getClockInData(
      GetClockInDataEvents event) async* {
    if (event is GetClockInDataSuccessEvent) {
      if (await Network.isConnected()) {
        String userId = await SharedPrefrence.getStringPreference("id");
        GetClockInDataResponse response =
            await repository.getClockInData(userId, event.dateAdded);
        if (response.success) {
          yield GetClockInDataSuccessState(getClockInDataResponse: response);
        } else {
          yield GetClockInDataFailureState(failureMessage: response.message);
        }
      } else {
        yield GetClockInDataFailureState(
            failureMessage: "Please check your internet connection!");
      }
    } else {
      yield GetClockInDataFailureState(failureMessage: "Something went wrong!");
    }
  }
}
