import 'package:equatable/equatable.dart';

class RetailerDetailEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetRetailerDetailsEvent extends RetailerDetailEvents {
  final String storeId;
  GetRetailerDetailsEvent({required this.storeId});
  @override
  List<Object> get props => [storeId];
}

class NoOrderYetEvent extends RetailerDetailEvents {
  final String retailerId;
  NoOrderYetEvent({required this.retailerId});
  @override
  List<Object> get props => [retailerId];
}

class GetTaskEvent extends RetailerDetailEvents {
  final String uniqueCode;
  GetTaskEvent({required this.uniqueCode});
  @override
  List<Object> get props => [uniqueCode];
}
