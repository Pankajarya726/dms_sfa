import 'package:equatable/equatable.dart';

class LoginEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends LoginEvents {
  final String mobileNumber;
  final String password;
  LoginEvent({required this.mobileNumber, required this.password});
  @override
  List<Object?> get props => [mobileNumber, password];
}

class GetUserEvent extends LoginEvents {
  GetUserEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
