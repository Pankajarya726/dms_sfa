import 'package:equatable/equatable.dart';

class MyPerformanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPerformanceEvent extends MyPerformanceEvent {
  final String type;
  final String date;

  GetPerformanceEvent({required this.date, required this.type});

  @override
  List<Object?> get props => [type, date];
}
