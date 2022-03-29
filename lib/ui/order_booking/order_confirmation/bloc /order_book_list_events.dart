import 'package:equatable/equatable.dart';

class OrderConfirmationEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetFocusSkuEvent extends OrderConfirmationEvents {
  final Map<String, dynamic> input;
  GetFocusSkuEvent({required this.input});
  @override
  List<Object> get props => [input];
}
