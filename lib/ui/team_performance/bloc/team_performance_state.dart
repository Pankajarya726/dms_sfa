import 'package:dms/ui/team_performance/model/get_team_performance_response.dart';
import 'package:equatable/equatable.dart';

class TeamPerformanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamPerformanceInitState extends TeamPerformanceState {}

class GetTeamPerformanceState extends TeamPerformanceState {
  final TeamPerformance performance;

  GetTeamPerformanceState({required this.performance});

  @override
  List<Object?> get props => [performance];
}

class TeamPerformanceLoadingState extends TeamPerformanceState {}

class GetTeamPerformanceFailureState extends TeamPerformanceState {
  final String msg;
  GetTeamPerformanceFailureState({required this.msg});
  @override
  List<Object?> get props => [msg];
}

class TeamPerformanceTabChangeState extends TeamPerformanceState {
  final int index;

  TeamPerformanceTabChangeState({required this.index});

  @override
  List<Object?> get props => [index];
}
