import 'package:equatable/equatable.dart';

class AddPlanStates extends Equatable {
  @override
  List<Object> get props => [];
}

class AddPlanInitialState extends AddPlanStates {}

class AddPlanLoadingState extends AddPlanStates {}

class AddPlanFailureState extends AddPlanStates {
  final String failureMessage;
  AddPlanFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}

class AddPlanSuccessState extends AddPlanStates {
  final String successMessage;
  AddPlanSuccessState({required this.successMessage});
  @override
  List<Object> get props => [successMessage];
}

class AddPlanGetDataState extends AddPlanStates {
  // final MyPlanResponse myPlanResponse;
  final String myPlanResponse;
  AddPlanGetDataState({required this.myPlanResponse});
  @override
  List<Object> get props => [myPlanResponse];
}
