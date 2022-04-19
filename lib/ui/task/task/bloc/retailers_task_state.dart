import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/task/task/model/get_retailers_task_response.dart';
import 'package:equatable/equatable.dart';

class RetailerTaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RetailerTaskInitState extends RetailerTaskState {}

class BeatLoadingState extends RetailerTaskState {}

class RetailerTaskLoadingState extends RetailerTaskState {}

class RetailerTaskFailureState extends RetailerTaskState {
  final String msg;

  RetailerTaskFailureState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class GetBeatState extends RetailerTaskState {
  final List<BeatsModal> beats;

  GetBeatState({required this.beats});

  @override
  List<Object?> get props => [beats];
}

class GetRetailersTaskState extends RetailerTaskState {
  final List<RetailersTaskModal> retailers;
  final DateTime currentDate;
  GetRetailersTaskState({
    required this.retailers,
    required this.currentDate,
  });

  @override
  List<Object?> get props => [retailers];
}
