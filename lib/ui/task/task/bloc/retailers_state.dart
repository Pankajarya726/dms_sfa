import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:equatable/equatable.dart';

class RetailerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RetailerInitState extends RetailerState {}

class BeatLoadingState extends RetailerState {}

class RetailerLoadingState extends RetailerState {}

class RetailerFailureState extends RetailerState {
  final String msg;

  RetailerFailureState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class GetBeatState extends RetailerState {
  final List<BeatsModal> beats;

  GetBeatState({required this.beats});

  @override
  List<Object?> get props => [beats];
}

class GetRetailersState extends RetailerState {
  final List<RetailersModal> retailers;

  GetRetailersState({required this.retailers});

  @override
  List<Object?> get props => [retailers];
}
