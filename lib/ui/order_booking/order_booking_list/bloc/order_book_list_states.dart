import 'package:dms/ui/order_booking/order_booking_list/model/get_brand_&_category_resonse.dart';
import 'package:equatable/equatable.dart';

class OrderBookListStates extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderBookListInitialState extends OrderBookListStates {}

class OrderBookListLoadingState extends OrderBookListStates {}

class GetBrandAndCatgState extends OrderBookListStates {
  final List<BrandAndCategoryModel> brandAndCategoryModal;
  GetBrandAndCatgState({required this.brandAndCategoryModal});
  @override
  List<Object> get props => [brandAndCategoryModal];
}

class OrderBookListFailureState extends OrderBookListStates {
  final String failureMessage;
  OrderBookListFailureState({required this.failureMessage});
  @override
  List<Object> get props => [failureMessage];
}

class GetCategoryState extends OrderBookListStates {
  final BrandAndCategoryModel category;
  GetCategoryState({required this.category});
  @override
  List<Object> get props => [category];
}
