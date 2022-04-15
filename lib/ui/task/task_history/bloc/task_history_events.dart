import 'package:equatable/equatable.dart';

class TaskHistoryEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTaskHistoryEvent extends TaskHistoryEvents {
  final Map<String, dynamic> input;
  GetTaskHistoryEvent({required this.input});
  @override
  List<Object> get props => [input];
}
