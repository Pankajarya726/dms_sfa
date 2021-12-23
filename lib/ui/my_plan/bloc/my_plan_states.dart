import 'package:dms/model/get_plan_response.dart';
import 'package:equatable/equatable.dart';

class MyPlanStates extends Equatable {
  @override
  List<Object> get props => [];
}

class MyPlanInitialState extends MyPlanStates {}

class MyPlanLoadingState extends MyPlanStates {}

class MyPlanFailureState extends MyPlanStates {
  final String failureMessage;

  MyPlanFailureState({required this.failureMessage});

  @override
  List<Object> get props => [failureMessage];
}

class GetPlanSuccessState extends MyPlanStates {
  final List<PlanDataModel> myPlan;

  GetPlanSuccessState({required this.myPlan});

  @override
  List<Object> get props => [myPlan];
}

class GetMonthState extends MyPlanStates {
  final bool pjpButton;
  final List<DateTime> months;

  GetMonthState({required this.months, required this.pjpButton});

  @override
  List<Object> get props => [months, pjpButton];
}
