import 'package:dms/ui/order_booking/order_confirmation/model/get_bu_response.dart';

abstract class ReasonsListener {
  void onReasonSelect(
      String reason, String remark, List<BUModal> buList, bool issueResolve);
}
