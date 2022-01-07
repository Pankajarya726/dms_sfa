import 'package:dms/ui/custom_widget/drop_down_field.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

class FilterRetailerBottomSheet extends StatefulWidget {
  const FilterRetailerBottomSheet({Key? key}) : super(key: key);

  @override
  _FilterRetailerBottomSheetState createState() => _FilterRetailerBottomSheetState();
}

class _FilterRetailerBottomSheetState extends State<FilterRetailerBottomSheet> {
  TextEditingController edtBookingDay = TextEditingController();
  TextEditingController edtPriority = TextEditingController();

  @override
  void initState() {
    debugPrint("FilterRetailerBottomSheet");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: IntrinsicHeight(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // shrinkWrap: false,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Filter",
            style: TextStyle(color: MColor.colorPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          DropDownField(
              onSelect: (value) {
                debugPrint("select-->$value");
              },
              hint: "Select Order Booking Day"),
          const SizedBox(
            height: 10,
          ),
          DropDownField(
              onSelect: (value) {
                debugPrint("select-->$value");
              },
              hint: "Select Priority Type"),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: MColor.colorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  child: const Text(
                    "Done",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
