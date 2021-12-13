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

class MyPlanGetDataState extends MyPlanStates {
  // final MyPlanResponse myPlanResponse;
  final String myPlanResponse;
  MyPlanGetDataState({required this.myPlanResponse});
  @override
  List<Object> get props => [myPlanResponse];
}
