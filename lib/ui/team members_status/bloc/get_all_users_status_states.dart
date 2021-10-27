import 'package:equatable/equatable.dart';
import 'package:sfa/ui/team%20members_status/model/get_all_users_status.dart';

class GetAllUserStatusStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllUserStatusInitialState extends GetAllUserStatusStates {}

class GetAllUserStatusLoadingState extends GetAllUserStatusStates {}

class GetAllUserStatusInitialSuccessState extends GetAllUserStatusStates {
  final GetAllUsersStatusResponse getAllUsersStatusResponse;
  GetAllUserStatusInitialSuccessState(
      {required this.getAllUsersStatusResponse});
  @override
  List<Object?> get props => [getAllUsersStatusResponse];
}

class GetAllUserStatusFailureState extends GetAllUserStatusStates {
  final String failureMessage;
  GetAllUserStatusFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}
