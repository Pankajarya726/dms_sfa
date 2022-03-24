import 'package:dms/ui/order_booking/order_booking_list/model/get_brand_category_resonse.dart';
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

class ChangeTabEvent extends OrderBookListEvents {
  final int index;

  ChangeTabEvent({required this.index});

  @override
  List<Object> get props => [index];
}

class GetCategoryEvent extends OrderBookListEvents {
  final BrandAndCategoryModel category;

  GetCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}
