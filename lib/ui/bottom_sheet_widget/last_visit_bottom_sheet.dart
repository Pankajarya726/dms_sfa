import 'package:dms/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LastVisitBottomSheet extends StatefulWidget {
  const LastVisitBottomSheet({Key? key}) : super(key: key);

  @override
  _LastVisitBottomSheetState createState() => _LastVisitBottomSheetState();
}

class _LastVisitBottomSheetState extends State<LastVisitBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Last Visit Status",
              style: TextStyle(color: MColor.colorPrimary, fontSize: 20, letterSpacing: 0.67),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Order Status",
              style: TextStyle(color: Colors.black, fontSize: 16, letterSpacing: 0.67),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Not Connected",
              style: TextStyle(color: MColor.textColor, fontSize: 16, letterSpacing: 0.67),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Remarks",
              style: TextStyle(color: Colors.black, fontSize: 16, letterSpacing: 0.67),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Lorem Ipsum is simply dummy text the printing and typesetting industry.",
              style: TextStyle(color: MColor.textColor, fontSize: 16, letterSpacing: 0.67),
            ),
          ],
        ),
      ),
    );
  }
}
