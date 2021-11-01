import 'package:equatable/equatable.dart';
import 'package:sfa/ui/team_members_details_screen/model/team_members_details_model.dart';

class MyProfileDetailsState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class MyProfileDetailsInitialState extends MyProfileDetailsState {}

class MyProfileDetailsLoadingState extends MyProfileDetailsState {}

class MyProfileDetailsInitialSuccessState extends MyProfileDetailsState {
  final DetailsStatusResponse detailsStatusResponse;
  MyProfileDetailsInitialSuccessState({required this.detailsStatusResponse});
  @override
  List<Object?> get props => [detailsStatusResponse];
}

class MyProfileDetailsSelectDateState extends MyProfileDetailsState {
  final DateTime dateTime;
  MyProfileDetailsSelectDateState({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class MyProfileDetailsIncrementDateState extends MyProfileDetailsState {
  final DateTime dateTime;
  MyProfileDetailsIncrementDateState({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class MyProfileDetailsDecrementDateState extends MyProfileDetailsState {
  final DateTime dateTime;
  MyProfileDetailsDecrementDateState({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class MyProfileDetailsFailureState extends MyProfileDetailsState {
  final String failureMessage;
  MyProfileDetailsFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}
