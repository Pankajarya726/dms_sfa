import 'package:equatable/equatable.dart';

class TaskDetailEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPendingTaskEvent extends TaskDetailEvents {
  final String retailerId;
  final String beatId;
  GetPendingTaskEvent({
    required this.retailerId,
    required this.beatId,
  });
  @override
  List<Object> get props => [retailerId, beatId];
}

class EscalateTaskEvent extends TaskDetailEvents {
  final Map<String, dynamic> input;
  EscalateTaskEvent({required this.input});
  @override
  List<Object> get props => [input];
}
