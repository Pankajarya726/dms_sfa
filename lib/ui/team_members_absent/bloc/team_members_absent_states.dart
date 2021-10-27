import 'package:equatable/equatable.dart';
import 'package:sfa/ui/team_members_absent/model/get_absent_data_response.dart';

class TeamMembersAbsentStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamMembersAbsentInitialState extends TeamMembersAbsentStates {}

class TeamMembersAbsentLoadingState extends TeamMembersAbsentStates {}

class TeamMembersAbsentSuccessState extends TeamMembersAbsentStates {
  final GetAbsentDataResponse getAbsentDataResponse;
  TeamMembersAbsentSuccessState({required this.getAbsentDataResponse});
  @override
  List<Object> get props => [getAbsentDataResponse];
}

class TeamMembersAbsentFailureState extends TeamMembersAbsentStates {
  final String failureMessage;
  TeamMembersAbsentFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}

class AbsentApproveSuccessState extends TeamMembersAbsentStates {
  final String successMessage;
  AbsentApproveSuccessState({required this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class AbsentApproveFailureState extends TeamMembersAbsentStates {
  final String failureMessage;
  AbsentApproveFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}
