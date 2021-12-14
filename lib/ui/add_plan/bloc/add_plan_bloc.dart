import 'package:dms/main.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_states.dart';
import 'package:dms/ui/add_plan/model/AddPlanResponse.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter/material.dart';
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
  }

  Stream<AddPlanStates> addPlan(AddPlanEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPreference.getStringPreference("id");

      AddPlanResponse response = await repository.addPlan(
          "3",
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

  Stream<AddPlanStates> addPlanGetData(AddPlanEvent event) async* {
    // if (await Network.isConnected()) {
    //   String userId = await SharedPreference.getStringPreference("id");
    //   MyPlanResponse response = repository.myPlanData(userId, event.date);

    //   if (response.success) {
    //     yield MyPlanGetDataState(myPlanResponse: response);
    //   } else {
    //     yield MyPlanFailureState(failureMessage: response.message);
    //   }
    // } else {
    //   yield MyPlanFailureState(
    //       failureMessage: "Please check your internet connection!");
    // }
  }
}
