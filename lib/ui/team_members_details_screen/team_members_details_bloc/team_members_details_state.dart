import 'package:equatable/equatable.dart';
import 'package:sfa/ui/team_members_details_screen/model/team_members_details_model.dart';

class TeamMembersDetailsState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TeamMembersDetailsInitialState extends TeamMembersDetailsState {}

class SelectDateState extends TeamMembersDetailsState {
  final DateTime date;
  SelectDateState({required this.date});
  @override
  List<Object?> get props => [date];
}

class IncrementDateState extends TeamMembersDetailsState {
  final DateTime date;
  IncrementDateState({required this.date});
  @override
  List<Object?> get props => [date];
}

class DecrementDateState extends TeamMembersDetailsState {
  final DateTime date;
  DecrementDateState({required this.date});
  @override
  List<Object?> get props => [date];
}

class TeamMembersDetailsLoadingState extends TeamMembersDetailsState {}

class TeamMembersDetailsSuccessState extends TeamMembersDetailsState {
  final DetailsStatusResponse response;
  TeamMembersDetailsSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class TeamMembersDetailsFailureState extends TeamMembersDetailsState {
  final String message;
  TeamMembersDetailsFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
