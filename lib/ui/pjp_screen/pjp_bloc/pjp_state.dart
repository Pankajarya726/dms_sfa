import 'package:equatable/equatable.dart';
import 'package:sfa/ui/pjp_screen/pjp_model/pjp_model.dart';
import 'package:sfa/ui/pjp_screen/update_pjp_model/update_pjp_model.dart';

class PjpState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

// PJP States
class PjpInitialState extends PjpState {}

class PjpLoadingState extends PjpState {}

class PjpSuccessState extends PjpState {
  final List<PjpData> response;
  PjpSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class PjpFailureState extends PjpState {
  final String message;
  PjpFailureState({required this.message});
}

// PJP Update States
class UpdateInitialState extends PjpState {}

class UpdateLoadingState extends PjpState {}

class UpdateSuccessState extends PjpState {
  final UpdateResponce response;
  UpdateSuccessState({required this.response});
}

class UpdateFailureState extends PjpState {
  final String message;
  UpdateFailureState({required this.message});
}

// PJP Date States

class DateIncrementState extends PjpState {
  final String dateTime;
  DateIncrementState({required this.dateTime});
}

class DateDecrementState extends PjpState {
  final String dateTime;
  DateDecrementState({required this.dateTime});
}
