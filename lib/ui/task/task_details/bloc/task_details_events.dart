import 'package:equatable/equatable.dart';

class TaskDetailEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTaskDetailsEvent extends TaskDetailEvents {
  final String storeId;
  GetTaskDetailsEvent({required this.storeId});
  @override
  List<Object> get props => [storeId];
}
