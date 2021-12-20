import 'package:equatable/equatable.dart';

class MyPlanEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class MyPlanGetDataEvent extends MyPlanEvents {
  final String date;
  MyPlanGetDataEvent({required this.date});
  @override
  List<Object> get props => [date];
}
