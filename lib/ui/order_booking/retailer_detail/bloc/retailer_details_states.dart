import 'package:dms/ui/order_booking/retailer_detail/model/no_order_yet_response.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/task_response.dart';
import 'package:equatable/equatable.dart';

class RetailerDetailStates extends Equatable {
  @override
  List<Object> get props => [];
}

class RetailerDetailInitialState extends RetailerDetailStates {}

class RetailerDetailLodingState extends RetailerDetailStates {}

class RetailerDetailFailureState extends RetailerDetailStates {
  final String failureMessage;

  RetailerDetailFailureState({required this.failureMessage});

  @override
  List<Object> get props => [failureMessage];
}

class GetRetailerDetailState extends RetailerDetailStates {
  final RetailerDetailsModal retailer;

  GetRetailerDetailState({required this.retailer});

  @override
  List<Object> get props => [retailer];
}

class NoOrderYetState extends RetailerDetailStates {
  final List<NoOrderYetModal> noOrderYet;

  NoOrderYetState({required this.noOrderYet});

  @override
  List<Object> get props => [noOrderYet];
}

class NoOrderYetFailureState extends RetailerDetailStates {
  final String failureMessage;

  NoOrderYetFailureState({required this.failureMessage});

  @override
  List<Object> get props => [failureMessage];
}

class GetTaskState extends RetailerDetailStates {
  final List<Task> taskList;

  GetTaskState({required this.taskList});

  @override
  List<Object> get props => [taskList];
}

class NoOrderYetLodingState extends RetailerDetailStates {}
