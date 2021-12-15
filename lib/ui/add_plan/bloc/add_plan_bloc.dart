import 'package:dms/main.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_states.dart';
import 'package:dms/ui/add_plan/model/AddPlanResponse.dart';
import 'package:dms/ui/add_plan/model/AddPlanUpdateData.dart';
import 'package:dms/ui/add_plan/model/GetAddPlanDataResponse.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_plan_events.dart';

class AddPlanBloc extends Bloc<AddPlanEvents, AddPlanStates> {
  AddPlanBloc() : super(AddPlanInitialState());

  @override
  Stream<AddPlanStates> mapEventToState(AddPlanEvents event) async* {
    if (event is AddPlanEvent) {
      yield AddPlanLoadingState();
      yield* addPlan(event);
    }
    if (event is GetAddPlanDataEvent) {
      yield AddPlanLoadingState();
      yield* addPlanGetData(event);
    }
    if (event is AddPlanUpdateEvent) {
      yield AddPlanLoadingState();
      yield* addPlanUpdate(event);
    }
  }

  Stream<AddPlanStates> addPlan(AddPlanEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPreference.getStringPreference("id");

      AddPlanResponse response = await repository.addPlan(
          userId,
          event.addPlanDate,
          event.primaryTag,
          event.secondaryTag,
          event.remark);

      if (response.success) {
        yield AddPlanSuccessState(successMessage: response.message);
      } else {
        yield AddPlanFailureState(failureMessage: response.message);
      }
    } else {
      yield AddPlanFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }

  Stream<AddPlanStates> addPlanGetData(GetAddPlanDataEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPreference.getStringPreference("id");
      GetAddPlanDataResponse response =
          await repository.getAddPlanData(userId, event.selectedDate);

      if (response.success) {
        yield GetAddPlanDataState(getAddPlanDataResponse: response);
      } else {
        yield GetAddPlanFailureState(success: response.success);
      }
    } else {
      yield AddPlanFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }

  Stream<AddPlanStates> addPlanUpdate(AddPlanUpdateEvent event) async* {
    if (await Network.isConnected()) {
      AddPlanUpdateDataResponse response = await repository.addPlanUpdateData(
          event.id,
          event.addPlanDate,
          event.primaryTag,
          event.secondaryTag,
          event.remark);

      if (response.success) {
        yield AddPlanSuccessState(successMessage: response.message);
      } else {
        yield AddPlanFailureState(failureMessage: response.message);
      }
    } else {
      yield AddPlanFailureState(
          failureMessage: "Please check your internet connection!");
    }
  }
}
