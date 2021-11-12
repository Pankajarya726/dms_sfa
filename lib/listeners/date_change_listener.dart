import 'package:sfa/ui/bottom_sheet/filter_model/filter_model.dart';

abstract class DateChangeListener {
  void onDateChange(String date);
  void onFilterSelect(FilterData? location, String? name, String? type);
}
