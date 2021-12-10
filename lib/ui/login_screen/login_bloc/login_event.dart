import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  final String mobileNumber;
  final String password;
  const LoginEvent({required this.mobileNumber, required this.password});
  @override
  List<Object?> get props => [mobileNumber, password];
}
