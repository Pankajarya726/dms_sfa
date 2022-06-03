import 'package:dms/ui/order_summery/model/get_order_summery_response.dart';
import 'package:equatable/equatable.dart';

class OrderSummeryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetOrderInitialState extends OrderSummeryState {}

class GetOrderLoadingState extends OrderSummeryState {}

class GetOrderSummeryState extends OrderSummeryState {
  final List<OrderSummery> orderSummery;

  GetOrderSummeryState({required this.orderSummery});

  @override
  List<Object?> get props => [orderSummery];
}

class GetOrderSummeryFailureState extends OrderSummeryState {
  final String message;

  GetOrderSummeryFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ApplyFilterState extends OrderSummeryState {
  ApplyFilterState();

  @override
  List<Object?> get props => [];
}
