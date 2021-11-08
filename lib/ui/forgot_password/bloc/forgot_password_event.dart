import 'package:equatable/equatable.dart';

class ForgotPasswordEvent extends Equatable {
  final String mobileNo;
  final String password;
  final String confPass;
  const ForgotPasswordEvent(
      {required this.mobileNo, required this.password, required this.confPass});
  @override
  List<Object?> get props => [mobileNo, password, confPass];
}
