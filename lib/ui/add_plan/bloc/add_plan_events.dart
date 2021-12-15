import 'package:equatable/equatable.dart';

class AddPlanEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class AddPlanEvent extends AddPlanEvents {
  final String addPlanDate;
  final String primaryTag;
  final String secondaryTag;
  final String remark;
  AddPlanEvent(
      {required this.addPlanDate,
      required this.primaryTag,
      required this.secondaryTag,
      required this.remark});
  @override
  List<Object> get props => [addPlanDate, primaryTag, secondaryTag, remark];
}

class AddPlanUpdateEvent extends AddPlanEvents {
  final String id;
  final String addPlanDate;
  final String primaryTag;
  final String secondaryTag;
  final String remark;
  AddPlanUpdateEvent(
      {required this.id,
      required this.addPlanDate,
      required this.primaryTag,
      required this.secondaryTag,
      required this.remark});
  @override
  List<Object> get props => [id, addPlanDate, primaryTag, secondaryTag, remark];
}

class GetAddPlanDataEvent extends AddPlanEvents {
  final String selectedDate;
  GetAddPlanDataEvent({required this.selectedDate});
  @override
  List<Object> get props => [];
}
