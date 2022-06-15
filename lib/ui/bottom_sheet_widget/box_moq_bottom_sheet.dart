import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoxMoqSheet extends StatefulWidget {
  final String sheetHeading;
  final String sheetType;
  final int selected;
  final int maxQty;

  final Function(int qty) onSelect;
  const BoxMoqSheet(
      {Key? key,
      required this.sheetHeading,
      required this.sheetType,
      required this.selected,
      required this.onSelect,
      required this.maxQty})
      : super(key: key);

  @override
  _BoxMoqSheetState createState() => _BoxMoqSheetState();
}

class _BoxMoqSheetState extends State<BoxMoqSheet> {
  int qty = 0;
  @override
  void initState() {
    qty = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntrinsicHeight(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomSheetHeading(widget.sheetHeading),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      widget.onSelect(qty);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      StringConst.done,
                      style: TextStyle(color: MColor.colorPrimary, fontSize: 20, letterSpacing: 0.67),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                // diameterRatio: 3,
                // itemExtent: 50,
                // useMagnifier: true,
                // magnification: 1,

                itemExtent: 25,
                diameterRatio: 1,
                useMagnifier: true,
                scrollController: FixedExtentScrollController(initialItem: widget.selected),
                magnification: 1.0,
                looping: true,

                onSelectedItemChanged: (item) {
                  qty = item;
                  debugPrint("item->$item");
                },
                children: List.generate(
                  widget.maxQty + 1,
                  (index) => Text(
                    "$index",
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
