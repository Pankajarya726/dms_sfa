import 'package:equatable/equatable.dart';
import 'package:sfa/ui/login_screen/login_model/login_response.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final LoginResponse loginResponse;

  LoginSuccessState({required this.loginResponse});
  @override
  List<Object?> get props => [loginResponse];
}

class LoginFailureState extends LoginState {
  final String message;
  LoginFailureState({required this.message});
}
