import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class LastVisitBottomSheet extends StatefulWidget {
  final RetailerDetailsModal? retailerDetails;
  const LastVisitBottomSheet({
    Key? key,
    required this.retailerDetails,
  }) : super(key: key);

  @override
  _LastVisitBottomSheetState createState() => _LastVisitBottomSheetState();
}

class _LastVisitBottomSheetState extends State<LastVisitBottomSheet> {
  LastVisit lastVisit = LastVisit(
      orderId: "", orderDate: "", amount: "", remark: "", products: []);
  String orderStatus = "";

  @override
  void initState() {
    if (widget.retailerDetails!.lastVisit.isNotEmpty) {
      lastVisit = widget.retailerDetails!.lastVisit.first;
    }
    if (widget.retailerDetails!.connectionStatus == "1") {
      orderStatus = "Not Connected";
    } else if (widget.retailerDetails!.connectionStatus == "2") {
      orderStatus = "Connected";
    } else if (widget.retailerDetails!.connectionStatus == "3") {
      orderStatus = "Order";
    } else {
      orderStatus = "";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Last Visit Status",
              style: TextStyle(
                  color: MColor.colorPrimary,
                  fontSize: 20,
                  letterSpacing: 0.67),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Order Status",
              style: TextStyle(
                  color: Colors.black, fontSize: 16, letterSpacing: 0.67),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              orderStatus,
              style: const TextStyle(
                  color: MColor.textColor, fontSize: 16, letterSpacing: 0.67),
            ),
            const SizedBox(
              height: 10,
            ),
            lastVisit.remark.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        StringConst.remark,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 0.67),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        lastVisit.remark,
                        style: const TextStyle(
                          color: MColor.textColor,
                          fontSize: 16,
                          letterSpacing: 0.67,
                        ),
                      )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
