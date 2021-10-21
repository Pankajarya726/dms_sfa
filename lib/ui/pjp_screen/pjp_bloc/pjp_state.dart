import 'package:equatable/equatable.dart';
import 'package:sfa/ui/pjp_screen/pjp_model/pjp_model.dart';
import 'package:sfa/ui/pjp_screen/update_pjp_model/update_pjp_model.dart';

class PjpState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

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

class UpdatePjpInitialState extends PjpState {}

class UpdateLoadingState extends PjpState {}

class UpdateSuccessState extends PjpState {
  final UpdateResponce response;
  UpdateSuccessState({required this.response});
}

class UpdatePjpFailureState extends PjpState {
  final String message;
  UpdatePjpFailureState({required this.message});
}
