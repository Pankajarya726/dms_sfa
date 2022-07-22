import 'package:dms/ui/my_performance/model/get_my_performance_response.dart';
import 'package:equatable/equatable.dart';

class MyPerformanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyPerformanceInitState extends MyPerformanceState {}

class GetMyPerformanceState extends MyPerformanceState {
  final MyPerformance performance;

  GetMyPerformanceState({required this.performance});

  @override
  List<Object?> get props => [performance];
}

class MyPerformanceLoadingState extends MyPerformanceState {}

class PerformanceLoadingState extends MyPerformanceState {}

class GetMyPerformanceFailureState extends MyPerformanceState {
  final String msg;

  GetMyPerformanceFailureState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class MyPerformanceTabChangeState extends MyPerformanceState {
  final int index;

  MyPerformanceTabChangeState({required this.index});

  @override
  List<Object?> get props => [index];
}
