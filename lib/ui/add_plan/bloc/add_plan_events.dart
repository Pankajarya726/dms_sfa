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
