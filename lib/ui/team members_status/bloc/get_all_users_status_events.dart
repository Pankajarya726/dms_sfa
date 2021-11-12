import 'package:equatable/equatable.dart';

class GetAllUserStatusEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllUserStatusInitialEvent extends GetAllUserStatusEvents {
  final String statusDate;
  final String? filterName;
  final String? locationType;
  final String? location;
  GetAllUserStatusInitialEvent(
      {required this.statusDate,
      this.filterName,
      this.locationType,
      this.location});
  @override
  List<Object?> get props => [statusDate];
}
