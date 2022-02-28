import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:equatable/equatable.dart';

class RetailerDetailStates extends Equatable {
  @override
  List<Object> get props => [];
}

class RetailerDetailInitialState extends RetailerDetailStates {}

class RetailerDetailLodingState extends RetailerDetailStates {}

class RetailerDetailFailureState extends RetailerDetailStates {
  final String failureMessage;
  RetailerDetailFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}

class GetRetailerDetailState extends RetailerDetailStates {
  final RetailersDetailsResponse retailersDetailsResponse;
  GetRetailerDetailState({required this.retailersDetailsResponse});
  @override
  List<Object> get props => [retailersDetailsResponse];
}
