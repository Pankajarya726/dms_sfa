import 'package:equatable/equatable.dart';

class SettingsEvent extends Equatable {
  final String userId;
  const SettingsEvent({required this.userId});
  @override
  List<Object?> get props => [userId];
}
