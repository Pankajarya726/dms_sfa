import 'dart:collection';

import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_events.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_states.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDetailsBloc extends Bloc<TaskDetailEvents, TaskDetailStates> {
  TaskDetailsBloc() : super(TaskDetailInitialState());

  @override
  Stream<TaskDetailStates> mapEventToState(TaskDetailEvents event) async* {
    if (event is GetTaskDetailsEvent) {
      yield TaskDetailLodingState();
      yield* getTaskDetails(event);
    }
  }

  Stream<TaskDetailStates> getTaskDetails(GetTaskDetailsEvent event) async* {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["retailer_id"] = event.storeId;
      RetailersDetailsResponse response = await repository.getRetailerInfo(input);
      if (response.success) {
        yield GetTaskDetailState(retailer: response.data.first);
      } else {
        yield TaskDetailFailureState(failureMessage: response.message);
      }
    } else {
      yield TaskDetailFailureState(failureMessage: StringConst.internetCheck);
    }
  }
}
