import 'dart:collection';

import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/retailer_detail/bloc/retailer_details_events.dart';
import 'package:dms/ui/order_booking/retailer_detail/bloc/retailer_details_states.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/no_order_yet_response.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/task_response.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RetailerDetailsBloc extends Bloc<RetailerDetailEvents, RetailerDetailStates> {
  RetailerDetailsBloc() : super(RetailerDetailInitialState());

  @override
  Stream<RetailerDetailStates> mapEventToState(RetailerDetailEvents event) async* {
    if (event is GetRetailerDetailsEvent) {
      yield RetailerDetailLodingState();
      yield* getRetailerDetails(event);
    }
    if (event is NoOrderYetEvent) {
      yield NoOrderYetLodingState();
      yield* noOrderYet(event);
    }
    if (event is GetTaskEvent) {
      yield NoOrderYetLodingState();
      yield* getTask(event);
    }
  }

  Stream<RetailerDetailStates> getRetailerDetails(GetRetailerDetailsEvent event) async* {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["retailer_id"] = event.storeId;
      input["user_id"] = event.storeId;
      RetailersDetailsResponse response = await repository.getRetailerInfo(input);
      if (response.success) {
        yield GetRetailerDetailState(retailer: response.data.first);
      } else {
        yield RetailerDetailFailureState(failureMessage: response.message);
      }
    } else {
      yield RetailerDetailFailureState(failureMessage: StringConst.internetCheck);
    }
  }

  Stream<RetailerDetailStates> noOrderYet(NoOrderYetEvent event) async* {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["retailer_id"] = event.retailerId;

      NoOrderYetResponse response = await repository.noOrderYet(input);
      if (response.success) {
        yield NoOrderYetState(noOrderYet: response.data!);
      } else {
        yield NoOrderYetFailureState(failureMessage: response.message);
      }
    } else {
      yield NoOrderYetFailureState(failureMessage: StringConst.internetCheck);
    }
  }

  Stream<RetailerDetailStates> getTask(GetTaskEvent event) async* {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = {"outlet_code": event.uniqueCode};
      TaskResponse response = await repository.getTaskByRetailer(input);
      if (response.success) {
        yield GetTaskState(taskList: response.data);
      } else {
        yield NoOrderYetFailureState(failureMessage: response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
