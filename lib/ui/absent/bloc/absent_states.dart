import 'package:equatable/equatable.dart';
import 'package:sfa/ui/absent/bloc/model/mark_absent_by_user.dart';

class AbsentStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class AbsentLoadingState extends AbsentStates {}

class AbsentInitialState extends AbsentStates {}

class AbsentFailureState extends AbsentStates {
  final String failureMessage;
  AbsentFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}

class AbsentSuccessState extends AbsentStates {
  final MarkAbsentByUserResponse markAbsentByUserResponse;
  AbsentSuccessState({required this.markAbsentByUserResponse});
  @override
  List<Object> get props => [markAbsentByUserResponse];
}
