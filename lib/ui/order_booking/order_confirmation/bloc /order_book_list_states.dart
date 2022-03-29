import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:equatable/equatable.dart';

class OrderConfirmationStates extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderConfirmationInitialState extends OrderConfirmationStates {}

class OrderConfirmationLoadingState extends OrderConfirmationStates {}

class GetFocusSkuState extends OrderConfirmationStates {
  final List<ProductsModal> prouductsModal;
  GetFocusSkuState({required this.prouductsModal});
  @override
  List<Object> get props => [prouductsModal];
}

class OrderConfirmationFailureState extends OrderConfirmationStates {
  final String msg;
  OrderConfirmationFailureState({required this.msg});
  @override
  List<Object> get props => [msg];
}
