import 'package:equatable/equatable.dart';

class MyPlanEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMyPlansEvent extends MyPlanEvents {
  final String date;
  GetMyPlansEvent({required this.date});
  @override
  List<Object> get props => [date];
}

class GetMonthsEvent extends MyPlanEvents {
  GetMonthsEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}
