import 'package:equatable/equatable.dart';

class GetClockInDataEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetClockInDataSuccessEvent extends GetClockInDataEvents {
  final String dateAdded;
  final String? filterName;
  final String? locationType;
  final String? location;
  GetClockInDataSuccessEvent(
      {required this.dateAdded,
      this.filterName,
      this.locationType,
      this.location});
  @override
  List<Object?> get props => [dateAdded];
}

class ClockInApproveRejectEvent extends GetClockInDataEvents {
  final String id;

  final String status;
  final String approvedBy;
  ClockInApproveRejectEvent(
      {required this.id, required this.status, required this.approvedBy});
  @override
  List<Object?> get props => [id, status, approvedBy];
}
