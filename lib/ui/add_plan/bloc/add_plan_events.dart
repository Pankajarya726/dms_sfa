import 'package:dms/model/get_all_tag_response.dart';
import 'package:equatable/equatable.dart';

class AddPlanEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class AddPlanEvent extends AddPlanEvents {
  final Map input;

  AddPlanEvent({
    required this.input,
  });

  @override
  List<Object> get props => [input];
}

class UpdatePlanEvent extends AddPlanEvents {
  final Map input;

  UpdatePlanEvent({required this.input});

  @override
  List<Object> get props => [input];
}

class SelectPrimaryEvent extends AddPlanEvents {
  final PrimaryTag primaryTag;

  SelectPrimaryEvent({required this.primaryTag});

  @override
  List<Object> get props => [primaryTag];
}

class GetPrimaryTagEvent extends AddPlanEvents {
  GetPrimaryTagEvent();
  @override
  List<Object> get props => [];
}

class GetTagEvent extends AddPlanEvents {
  GetTagEvent();
  @override
  List<Object> get props => [];
}

class GetSecondaryTagEvent extends AddPlanEvents {
  final String primaryTagId;

  GetSecondaryTagEvent({required this.primaryTagId});
  @override
  List<Object> get props => [primaryTagId];
}

class SelectSecondaryEvent extends AddPlanEvents {
  final List<SecondaryTag> secondaryTag;

  SelectSecondaryEvent({required this.secondaryTag});

  @override
  List<Object> get props => [secondaryTag];
}

class GetSavedPlanEvent extends AddPlanEvents {
  final String selectedDate;

  GetSavedPlanEvent({required this.selectedDate});

  @override
  List<Object> get props => [];
}
