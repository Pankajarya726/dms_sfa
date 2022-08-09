import 'package:equatable/equatable.dart';

class ChangePasswordEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangePasswordEvent extends ChangePasswordEvents {
  final String id;
  final String currentPassword;
  final String newPassword;
  final String confPassword;
  ChangePasswordEvent({
    required this.id,
    required this.currentPassword,
    required this.newPassword,
    required this.confPassword,
  });
  @override
  List<Object?> get props => [currentPassword, id, newPassword, confPassword];
}
