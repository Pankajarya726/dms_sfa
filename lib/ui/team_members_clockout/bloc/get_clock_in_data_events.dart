import 'package:equatable/equatable.dart';

class GetClockInDataEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetClockInDataSuccessEvent extends GetClockInDataEvents {
  final String dateAdded;
  GetClockInDataSuccessEvent({required this.dateAdded});
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
