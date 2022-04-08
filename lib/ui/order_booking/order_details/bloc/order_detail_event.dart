import 'package:equatable/equatable.dart';

class OrderDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetOrderEvent extends OrderDetailEvent {
  final String retailerId;
  final String beatId;

  GetOrderEvent({required this.retailerId, required this.beatId});

  @override
  List<Object?> get props => [retailerId, beatId];
}
