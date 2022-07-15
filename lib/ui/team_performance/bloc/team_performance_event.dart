import 'package:equatable/equatable.dart';

class TeamPerformanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPerformanceEvent extends TeamPerformanceEvent {
  final String type;
  final String date;
  final String userId;

  GetPerformanceEvent({required this.date, required this.type, required this.userId});

  @override
  List<Object?> get props => [type, date, userId];
}
