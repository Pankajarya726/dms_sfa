import 'package:equatable/equatable.dart';

class OrderSummeryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetOrderSummeryEvent extends OrderSummeryEvent {
  final Map<String, dynamic> input;

  GetOrderSummeryEvent({required this.input});

  @override
  List<Object?> get props => [input];
}

class ApplyFilterEvent extends OrderSummeryEvent {
  ApplyFilterEvent();
  @override
  List<Object?> get props => [];
}
