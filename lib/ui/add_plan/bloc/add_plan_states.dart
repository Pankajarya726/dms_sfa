import 'package:dms/model/get_all_tag_response.dart';
import 'package:dms/model/get_plan_response.dart';
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
  final PlanDataModel planDataModel;

  AddPlanSuccessState({required this.planDataModel});

  @override
  List<Object> get props => [planDataModel];
}

class AddPlanGetDataState extends AddPlanStates {
  // final MyPlanResponse myPlanResponse;
  final String myPlanResponse;

  AddPlanGetDataState({required this.myPlanResponse});

  @override
  List<Object> get props => [myPlanResponse];
}

class GetSavedPlanState extends AddPlanStates {
  final PlanDataModel planDateModel;

  GetSavedPlanState({required this.planDateModel});

  @override
  List<Object> get props => [planDateModel];
}

class GetAddPlanFailureState extends AddPlanStates {
  final String message;

  GetAddPlanFailureState({required this.message});

  @override
  List<Object> get props => [message];
}

class SelectPrimaryTagState extends AddPlanStates {
  final PrimaryTag primaryTag;

  SelectPrimaryTagState({required this.primaryTag});

  @override
  List<Object> get props => [primaryTag];
}

class SelectSecondaryState extends AddPlanStates {
  final List<SecondaryTag> secondaryTag;

  SelectSecondaryState({required this.secondaryTag});

  @override
  List<Object> get props => [secondaryTag];
}

class GetTagState extends AddPlanStates {
  final List<PrimaryTag> primaryTagList;

  GetTagState({required this.primaryTagList});

  @override
  List<Object> get props => [primaryTagList];
}
