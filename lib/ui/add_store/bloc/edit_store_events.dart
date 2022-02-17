import 'package:equatable/equatable.dart';

class EditStoreEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetEnrolmentTypeEvent extends EditStoreEvents {
  @override
  List<Object> get props => [];
}

class SelectLanguageTypeEvent extends EditStoreEvents {
  @override
  List<Object> get props => [];
}

class SelectRetailerTypeEvent extends EditStoreEvents {
  @override
  List<Object> get props => [];
}

class SelectRetailerCategoryEvent extends EditStoreEvents {
  @override
  List<Object> get props => [];
}

class SelectDistrictEvent extends EditStoreEvents {
  @override
  List<Object> get props => [];
}

class SelectDistributorEvent extends EditStoreEvents {
  final Map districtId;
  SelectDistributorEvent({required this.districtId});
  @override
  List<Object> get props => [districtId];
}

class SelectCallTimeSlotEvent extends EditStoreEvents {
  @override
  List<Object> get props => [];
}
