import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoxMoqSheet extends StatefulWidget {
  const BoxMoqSheet({Key? key}) : super(key: key);

  @override
  _BoxMoqSheetState createState() => _BoxMoqSheetState();
}

class _BoxMoqSheetState extends State<BoxMoqSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntrinsicHeight(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BottomSheetHeading("MOQ"),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(color: MColor.colorPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                  diameterRatio: 3,
                  itemExtent: 50,
                  useMagnifier: true,
                  magnification: 1,
                  onSelectedItemChanged: (item) {
                    debugPrint("item->$item");
                  },
                  children: List.generate(20, (index) => Text("${index + 1}"))),
            )
          ],
        ),
      ),
    );
  }
}
