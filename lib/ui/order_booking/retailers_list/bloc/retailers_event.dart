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

  GetRetailerEvent({required this.status, required this.beatId});

  @override
  List<Object?> get props => [];
}
