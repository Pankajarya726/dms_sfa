import 'package:dms/ui/order_booking/order_booking_list/model/get_brand_category_resonse.dart';

abstract class SelectCategoryListener {
  void onCategorySelect(BrandAndCategoryModel brandAndCategoryModel, Category category);
}
