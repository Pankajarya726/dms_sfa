import 'package:dms/ui/add_plan/model/GetAddPlanDataResponse.dart';
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

class GetAddPlanDataState extends AddPlanStates {
  final GetAddPlanDataResponse getAddPlanDataResponse;
  GetAddPlanDataState({required this.getAddPlanDataResponse});
  @override
  List<Object> get props => [getAddPlanDataResponse];
}

class GetAddPlanFailureState extends AddPlanStates {
  final bool success;
  GetAddPlanFailureState({required this.success});
  @override
  List<Object> get props => [success];
}
