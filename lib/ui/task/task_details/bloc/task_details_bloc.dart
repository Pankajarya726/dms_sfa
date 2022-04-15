import 'dart:collection';
import 'package:dms/main.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_events.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_states.dart';
import 'package:dms/ui/task/task_details/model/retailer_details_response.dart';
import 'package:dms/ui/task/task_details/model/task_escalate_response.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';

class TaskDetailsBloc extends Bloc<TaskDetailEvents, TaskDetailStates> {
  TaskDetailsBloc() : super(TaskDetailInitialState());

  @override
  Stream<TaskDetailStates> mapEventToState(TaskDetailEvents event) async* {
    if (event is GetPendingTaskEvent) {
      yield TaskDetailLodingState();
      yield* getPendingTask(event);
    }
    if (event is EscalateTaskEvent) {
      yield EscalateTaskLodingState();
      yield* escalateTask(event);
    }
  }

  Stream<TaskDetailStates> getPendingTask(GetPendingTaskEvent event) async* {
    DateTime currentDate =
        await NTP.now().timeout(const Duration(seconds: 5), onTimeout: () {
      return DateTime.now();
    });
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["retailer_id"] = event.retailerId;
      input["beat_id"] = event.beatId;
      GetPendingTaskResponse response = await repository.getPendingTask(input);
      if (response.success) {
        yield GetPendingTaskState(
            pendingTask: response.data!, currentDate: currentDate);
      } else {
        yield TaskDetailFailureState(failureMessage: response.message);
      }
    } else {
      yield TaskDetailFailureState(failureMessage: StringConst.internetCheck);
    }
  }

  Stream<TaskDetailStates> escalateTask(EscalateTaskEvent event) async* {
    if (await Network.isConnected()) {
      TaskEscalateResponse response =
          await repository.taskEscalate(event.input);
      if (response.success) {
        yield EscalateTaskState(responseMessage: response.message);
      } else {
        yield EscalateTaskFailureState(failureMessage: response.message);
      }
    } else {
      yield EscalateTaskFailureState(failureMessage: StringConst.internetCheck);
    }
  }
}
