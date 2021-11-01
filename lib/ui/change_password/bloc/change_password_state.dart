import 'package:equatable/equatable.dart';
import 'package:sfa/ui/change_password/model/model.dart';

class ChangePasswordState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ChangePasswordInitialState extends ChangePasswordState {}

class ChangePasswordLoadingState extends ChangePasswordState {}

class ChangePasswordSuccessState extends ChangePasswordState {
  final ChangePassResponse response;
  ChangePasswordSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class ChangePasswordFailureState extends ChangePasswordState {
  final String message;
  ChangePasswordFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
