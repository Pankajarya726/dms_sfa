import 'package:equatable/equatable.dart';

class TeamMembersDetailsEvents extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SelectDateEvent extends TeamMembersDetailsEvents {
  final DateTime date;
  SelectDateEvent({required this.date});
  @override
  List<Object?> get props => [date];
}

class DateIncrementEvent extends TeamMembersDetailsEvents {
  final DateTime date;
  DateIncrementEvent({required this.date});
  @override
  List<Object?> get props => [date];
}

class DateDecrementEvent extends TeamMembersDetailsEvents {
  final DateTime date;
  DateDecrementEvent({required this.date});
  @override
  List<Object?> get props => [date];
}

class GetTeamMembersDetailsEvents extends TeamMembersDetailsEvents {
  final String id;
  final String date;
  GetTeamMembersDetailsEvents({required this.id, required this.date});
  @override
  List<Object?> get props => [id, date];
}
