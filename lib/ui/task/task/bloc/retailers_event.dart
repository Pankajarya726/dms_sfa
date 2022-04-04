import 'package:equatable/equatable.dart';

abstract class RetailerEvent extends Equatable {}

class GetBeatEvent extends RetailerEvent {
  GetBeatEvent();

  @override
  List<Object?> get props => [];
}

class GetRetailerEvent extends RetailerEvent {
  final String beatId;
  final int status;
  final String day;
  final String retailerType;

  GetRetailerEvent(
      {required this.status,
      required this.beatId,
      required this.day,
      required this.retailerType});

  @override
  List<Object?> get props => [status, beatId, day, retailerType];
}
