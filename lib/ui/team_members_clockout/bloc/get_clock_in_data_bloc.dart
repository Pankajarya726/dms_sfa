import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/main.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_events.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_states.dart';
import 'package:sfa/ui/team_members_clockout/model/clockin_approve_reject_model.dart';
import 'package:sfa/ui/team_members_clockout/model/get_clock_in_data_response.dart';
import 'package:sfa/utility/network.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class GetClockInDataBloc
    extends Bloc<GetClockInDataEvents, GetClockInDataStates> {
  GetClockInDataBloc() : super(GetClockInDataInitialState());

  @override
  Stream<GetClockInDataStates> mapEventToState(
      GetClockInDataEvents event) async* {
    yield GetClockInDataLoadingState();
    yield* getClockInData(event);

    if (event is ClockInApproveRejectEvent) {
      yield* clockInActions(event);
    }
  }

  Stream<GetClockInDataStates> getClockInData(
      GetClockInDataEvents event) async* {
    if (event is GetClockInDataSuccessEvent) {
      if (await Network.isConnected()) {
        String userId = await SharedPrefrence.getStringPreference("id");
        GetClockInDataResponse response = await repository.getClockInData(
            userId,
            event.dateAdded,
            event.filterName,
            event.locationType,
            event.location);
        if (response.success) {
          yield GetClockInDataSuccessState(getClockInDataResponse: response);
        } else {
          yield GetClockInDataFailureState(failureMessage: response.message);
        }
      } else {
        yield GetClockInDataFailureState(
            failureMessage: "Please check your internet connection!");
      }
    }
  }

  Stream<GetClockInDataStates> clockInActions(
      ClockInApproveRejectEvent event) async* {
    ClockInApproveRes response = await repository.clockInApprovReject(
        event.id, event.status, event.approvedBy);
    if (response.success) {
      yield ClockInApproveRejectSuccessState(res: response);
    } else {
      yield ClockInApproveRejectFailureState(message: response.message);
    }
  }
}
