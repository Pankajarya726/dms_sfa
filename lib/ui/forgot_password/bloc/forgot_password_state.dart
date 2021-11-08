import 'package:equatable/equatable.dart';
import 'package:sfa/ui/forgot_password/model/forgot_password_model.dart';

class ForgotPasswordState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ForgotPasswordInitalState extends ForgotPasswordState {}

class ForgotPasswordLoadingState extends ForgotPasswordState {}

class ForgotPasswordSuccessState extends ForgotPasswordState {
  final ForgotPasswordResponse response;
  ForgotPasswordSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class ForgotPasswordFailureState extends ForgotPasswordState {
  final String message;
  ForgotPasswordFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
