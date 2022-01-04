import 'package:dms/main.dart';
import 'package:dms/model/get_plan_response.dart';
import 'package:dms/model/primary_tag_response.dart';
import 'package:dms/model/secondary_tag_response.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_states.dart';
import 'package:dms/ui/add_plan/model/AddPlanUpdateData.dart';
import 'package:dms/ui/add_plan/model/add_plan_response.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'add_plan_events.dart';

class AddPlanBloc extends Bloc<AddPlanEvents, AddPlanStates> {
  AddPlanBloc() : super(AddPlanInitialState());

  @override
  Stream<AddPlanStates> mapEventToState(AddPlanEvents event) async* {
    debugPrint("event--->$event");
    if (event is AddPlanEvent) {
      yield AddPlanLoadingState();
      yield* addPlan(event);
    }
    if (event is GetSavedPlanEvent) {
      yield AddPlanLoadingState();
      yield* getSavedPlan(event);
    }
    if (event is SelectPrimaryEvent) {
      yield AddPlanLoadingState();
      yield SelectPrimaryTagState(primaryTag: event.primaryTag);
    }
    if (event is SelectSecondaryEvent) {
      yield AddPlanLoadingState();
      yield SelectSecondaryState(secondaryTag: event.secondaryTag);
    }

    if (event is UpdatePlanEvent) {
      yield AddPlanLoadingState();
      yield* updatePlan(event);
    }
    if (event is GetSecondaryTagEvent) {
      yield AddPlanLoadingState();
      yield* getSecondaryTag(event);
    }

    if (event is GetPrimaryTagEvent) {
      yield AddPlanLoadingState();
      yield* getPrimaryTag();
    }
  }

  Stream<AddPlanStates> getSecondaryTag(GetSecondaryTagEvent event) async* {
    if (await Network.isConnected()) {
      SecondaryTagResponse response = await repository.getSecondaryTag(event.primaryTagId.toString());

      if (response.success) {
        if (event.primaryTagId == "1") {
          yield GetSecondaryTagState(secondaryTagList: response.data!.location!);
        } else {
          yield GetSecondaryTagState(secondaryTagList: response.data!.jointWorker!);
        }
      } else {
        Utility.showToast(response.message);
        yield GetSecondaryTagFailureState(message: response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  Stream<AddPlanStates> getPrimaryTag() async* {
    if (await Network.isConnected()) {
      PrimaryTagResponse response = await repository.getPrimaryTag();

      if (response.success) {
        yield GetPrimaryTagState(primaryTagList: response.data);
      } else {
        Utility.showToast(response.message);
        yield GetSecondaryTagFailureState(message: response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  Stream<AddPlanStates> addPlan(AddPlanEvent event) async* {
    if (await Network.isConnected()) {
      EasyLoading.show();
      AddPlanResponse response = await repository.addPlan(
        event.input,
      );
      EasyLoading.dismiss();
      if (response.success) {
        Utility.showToast(response.message);
        yield AddPlanSuccessState(planDataModel: response.data!);
      } else {
        yield AddPlanFailureState(failureMessage: response.message);
      }
    } else {
      yield AddPlanFailureState(failureMessage: "Please check your internet connection!");
    }
  }

  Stream<AddPlanStates> getSavedPlan(GetSavedPlanEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPreference.getStringPreference(SharedPreference.userId);
      Map input = {
        "user_id": userId,
        "add_plan_date": event.selectedDate,
      };
      GetPlanByDateResponse response = await repository.getSavedPlan(input);

      if (response.success) {
        yield GetSavedPlanState(planDateModel: response.data!);
      } else {
        yield GetAddPlanFailureState(message: response.message);
      }
    } else {
      yield GetAddPlanFailureState(message: "Please check your internet connection!");
    }
  }

  Stream<AddPlanStates> updatePlan(UpdatePlanEvent event) async* {
    if (await Network.isConnected()) {
      EasyLoading.show();
      AddPlanUpdateDataResponse response = await repository.addPlanUpdateData(event.input);
      EasyLoading.dismiss();
      if (response.success) {
        Utility.showToast(response.message);
        // yield AddPlanSuccessState(successMessage: response.message);
      } else {
        Utility.showToast(response.message);
        // yield AddPlanFailureState(failureMessage: response.message);
      }
    } else {
      yield AddPlanFailureState(failureMessage: "Please check your internet connection!");
    }
  }
}
