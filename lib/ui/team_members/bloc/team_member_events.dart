import 'package:equatable/equatable.dart';

class TeamMemberEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamMemberInitialSuccessEvent extends TeamMemberEvents {
  @override
  List<Object?> get props => [];
}

class TeamMembersPreviousDateEvent extends TeamMemberEvents {
  final String previousDate;
  final context;
  TeamMembersPreviousDateEvent(
      {required this.previousDate, required this.context});
  @override
  List<Object?> get props => [previousDate, context];
}

class TeamMembersNextDateEvent extends TeamMemberEvents {
  final String nextDate;
  TeamMembersNextDateEvent({required this.nextDate});
  @override
  List<Object?> get props => [nextDate];
}

class TeamMembersSelectCalenderDateEvent extends TeamMemberEvents {
  final String calanderDate;
  TeamMembersSelectCalenderDateEvent({required this.calanderDate});
  @override
  List<Object?> get props => [calanderDate];
}
