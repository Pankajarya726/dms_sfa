import 'package:equatable/equatable.dart';
import 'package:sfa/ui/team_members_clockout/model/clockin_approve_reject_model.dart';
import 'package:sfa/ui/team_members_clockout/model/get_clock_in_data_response.dart';

class GetClockInDataStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetClockInDataLoadingState extends GetClockInDataStates {}

class GetClockInDataInitialState extends GetClockInDataStates {}

class GetClockInDataSuccessState extends GetClockInDataStates {
  final GetClockInDataResponse getClockInDataResponse;
  GetClockInDataSuccessState({required this.getClockInDataResponse});
  @override
  List<Object?> get props => [getClockInDataResponse];
}

class GetClockInDataFailureState extends GetClockInDataStates {
  final String failureMessage;
  GetClockInDataFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}

class ClockInApproveRejectSuccessState extends GetClockInDataStates {
  final ClockInApproveRes res;
  ClockInApproveRejectSuccessState({required this.res});
  @override
  List<Object?> get props => [res];
}

class ClockInApproveRejectFailureState extends GetClockInDataStates {
  final String message;
  ClockInApproveRejectFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
