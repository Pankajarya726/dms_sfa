import 'package:dms/ui/task/task_details/model/retailer_details_response.dart';
import 'package:equatable/equatable.dart';

class TaskDetailStates extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskDetailInitialState extends TaskDetailStates {}

class TaskDetailLodingState extends TaskDetailStates {}

class EscalateTaskLodingState extends TaskDetailStates {}

class TaskDetailFailureState extends TaskDetailStates {
  final String failureMessage;
  TaskDetailFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}

class GetPendingTaskState extends TaskDetailStates {
  final List<PendingTaskModal> pendingTask;
  final DateTime currentDate;
  GetPendingTaskState({
    required this.pendingTask,
    required this.currentDate,
  });
  @override
  List<Object> get props => [pendingTask, currentDate];
}

class EscalateTaskState extends TaskDetailStates {
  final String responseMessage;
  EscalateTaskState({
    required this.responseMessage,
  });
  @override
  List<Object> get props => [responseMessage];
}

class EscalateTaskFailureState extends TaskDetailStates {
  final String failureMessage;
  EscalateTaskFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}
