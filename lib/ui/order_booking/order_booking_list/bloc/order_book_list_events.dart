import 'package:equatable/equatable.dart';

class OrderBookListEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetBrandAndCatgEvent extends OrderBookListEvents {
  final Map<String, dynamic> input;
  GetBrandAndCatgEvent({required this.input});
  @override
  List<Object> get props => [input];
}
