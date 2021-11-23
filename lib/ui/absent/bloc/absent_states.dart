import 'package:equatable/equatable.dart';
import 'package:sfa/ui/absent/bloc/model/mark_absent_by_user.dart';
import 'package:sfa/ui/home_screen/home_screen_model/home_screen_model.dart';

class AbsentStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class AbsentLoadingState extends AbsentStates {}

class AbsentInitialState extends AbsentStates {}

class AbsentInitialSuccessState extends AbsentStates {
  final UserDetails userData;
  AbsentInitialSuccessState({required this.userData});
  @override
  List<Object?> get props => [userData];
}

class AbsentFailureState extends AbsentStates {
  final String failureMessage;
  AbsentFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}

class AbsentNetworkFailureState extends AbsentStates {
  final String failureMessage;
  AbsentNetworkFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}

class AbsentSuccessState extends AbsentStates {
  final MarkAbsentByUserResponse markAbsentByUserResponse;
  AbsentSuccessState({required this.markAbsentByUserResponse});
  @override
  List<Object> get props => [markAbsentByUserResponse];
}
