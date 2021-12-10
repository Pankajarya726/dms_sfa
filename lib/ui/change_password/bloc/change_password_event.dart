import 'package:equatable/equatable.dart';

class ChangePasswordEvent extends Equatable {
  final String id;
  final String currentPassword;
  final String newPassword;
  final String confPassword;
  const ChangePasswordEvent({
    required this.id,
    required this.currentPassword,
    required this.newPassword,
    required this.confPassword,
  });
  @override
  List<Object?> get props => [currentPassword, id, newPassword, confPassword];
}
