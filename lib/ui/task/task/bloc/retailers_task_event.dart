import 'package:equatable/equatable.dart';

abstract class RetailerTaskEvent extends Equatable {}

class GetBeatEvent extends RetailerTaskEvent {
  GetBeatEvent();

  @override
  List<Object?> get props => [];
}

class GetRetailerTaskEvent extends RetailerTaskEvent {
  final String beatId;
  final int status;
  // final String day;

  GetRetailerTaskEvent({
    required this.status,
    required this.beatId,
    // required this.day,
  });

  @override
  List<Object?> get props => [status, beatId];
}
