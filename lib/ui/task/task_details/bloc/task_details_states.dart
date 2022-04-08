import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:equatable/equatable.dart';

class TaskDetailStates extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskDetailInitialState extends TaskDetailStates {}

class TaskDetailLodingState extends TaskDetailStates {}

class TaskDetailFailureState extends TaskDetailStates {
  final String failureMessage;
  TaskDetailFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}

class GetTaskDetailState extends TaskDetailStates {
  final RetailerDetailsModal retailer;
  GetTaskDetailState({required this.retailer});
  @override
  List<Object> get props => [retailer];
}
