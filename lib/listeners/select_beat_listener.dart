import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';

abstract class SelectBeatListener {
  void onBeatSelect(BeatsModal beatsModal, String day, String type);
  void onSorting(String type);
}
