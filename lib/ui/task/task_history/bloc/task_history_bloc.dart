import 'package:dms/main.dart';
import 'package:dms/ui/task/task_history/bloc/task_history_events.dart';
import 'package:dms/ui/task/task_history/bloc/task_history_states.dart';
import 'package:dms/ui/task/task_history/model/task_history_respone.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';

class TaskHistoryBloc extends Bloc<TaskHistoryEvents, TaskHistoryStates> {
  TaskHistoryBloc() : super(TaskHistoryInitialState());

  @override
  Stream<TaskHistoryStates> mapEventToState(TaskHistoryEvents event) async* {
    if (event is GetTaskHistoryEvent) {
      yield TaskHistoryLodingState();
      yield* getTaskHistory(event);
    }
  }

  Stream<TaskHistoryStates> getTaskHistory(GetTaskHistoryEvent event) async* {
    DateTime currentDate =
        await NTP.now().timeout(const Duration(seconds: 5), onTimeout: () {
      return DateTime.now();
    });
    if (await Network.isConnected()) {
      // Map<String, dynamic> input = HashMap<String, dynamic>();
      // input["retailer_id"] = event.retailerId;
      // input["beat_id"] = event.beatId;
      TaskHistoryResponse response =
          await repository.getTaskHistory(event.input);
      if (response.success) {
        yield GetTaskHistoryState(
            taskHistory: response.data!, currentDate: currentDate);
      } else {
        yield TaskHistoryFailureState(failureMessage: response.message);
      }
    } else {
      yield TaskHistoryFailureState(failureMessage: StringConst.internetCheck);
    }
  }
}
