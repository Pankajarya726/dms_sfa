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

  TeamMembersPreviousDateEvent({required this.previousDate});
  @override
  List<Object?> get props => [previousDate];
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
