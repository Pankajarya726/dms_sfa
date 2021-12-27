import 'package:equatable/equatable.dart';

class SettingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetSettingEvent extends SettingEvent {
  final String userId;

  GetSettingEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
