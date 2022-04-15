import 'package:dms/ui/task/task_history/model/task_history_respone.dart';
import 'package:equatable/equatable.dart';

class TaskHistoryStates extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskHistoryInitialState extends TaskHistoryStates {}

class TaskHistoryLodingState extends TaskHistoryStates {}

class TaskHistoryFailureState extends TaskHistoryStates {
  final String failureMessage;
  TaskHistoryFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}

class GetTaskHistoryState extends TaskHistoryStates {
  final List<TaskHistoryModal> taskHistory;
  final DateTime currentDate;
  GetTaskHistoryState({
    required this.taskHistory,
    required this.currentDate,
  });
  @override
  List<Object> get props => [taskHistory, currentDate];
}
