import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class ReadyStockBillBottomSheet extends StatefulWidget {
  final String prevSelected;
  final Function(String selectedValue) onbillSelected;
  const ReadyStockBillBottomSheet({
    Key? key,
    required this.prevSelected,
    required this.onbillSelected,
  }) : super(key: key);

  @override
  _ReadyStockBillBottomSheetState createState() =>
      _ReadyStockBillBottomSheetState();
}

class _ReadyStockBillBottomSheetState extends State<ReadyStockBillBottomSheet> {
  String groupValue = "";
  List<String> names = [StringConst.yes, StringConst.no];

  @override
  void initState() {
    groupValue = widget.prevSelected;
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
              "Is this a ready stock bill?",
              style: TextStyle(
                fontSize: 19,
                color: MColor.colorPrimary,
                letterSpacing: 0.67,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    2,
                    (index) => RadioListTile<String>(
                      contentPadding: const EdgeInsets.all(0),
                      value: names[index],
                      groupValue: groupValue,
                      title: Text(
                        names[index],
                        style: const TextStyle(
                          fontSize: 17.0,
                          color: MColor.backButton,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (value) {
                        groupValue = value!;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.onbillSelected(groupValue);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(180, 55)),
                  backgroundColor:
                      MaterialStateProperty.all(MColor.colorPrimary),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                child: const Text(
                  StringConst.done,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
