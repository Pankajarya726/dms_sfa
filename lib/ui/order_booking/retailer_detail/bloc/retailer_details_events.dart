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
