import 'package:dms/ui/drawer_menu/home_screen/model/user_details_response.dart';
import 'package:dms/ui/login_screen/login_model/login_response.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final LoginData data;

  LoginSuccessState({required this.data});
  @override
  List<Object?> get props => [data];
}

class LoginFailureState extends LoginState {
  final String message;
  LoginFailureState({required this.message});
}

class GetUserDetailsState extends LoginState {
  final GetUserResponse userDetails;
  GetUserDetailsState({required this.userDetails});
  @override
  List<Object> get props => [userDetails];
}
