import 'package:dms/ui/order_booking/order_details/model/get_order_response.dart';
import 'package:equatable/equatable.dart';

class OrderDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderDetailInitialState extends OrderDetailState {}

class GetOrderSuccessState extends OrderDetailState {
  final Task? task;
  final Order orders;
  final List<Product> products;

  GetOrderSuccessState({required this.products, required this.orders, this.task});

  @override
  List<Object?> get props => [task, orders, products];
}

class GetOrderFailureState extends OrderDetailState {
  final String msg;

  GetOrderFailureState({required this.msg});

  @override
  List<Object?> get props => [msg];
}
