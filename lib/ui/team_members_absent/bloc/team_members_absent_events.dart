import 'package:equatable/equatable.dart';

class TeamMembersAbsentEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamMembersAbsentSuccessEvent extends TeamMembersAbsentEvents {
  final String currentDate;
  TeamMembersAbsentSuccessEvent({required this.currentDate});
  @override
  List<Object?> get props => [currentDate];
}
