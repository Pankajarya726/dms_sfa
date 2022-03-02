import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/custom_widget/tag_widget.dart';
import 'package:flutter/material.dart';

class NoOrderReasonSheet extends StatefulWidget {
  const NoOrderReasonSheet({Key? key}) : super(key: key);

  @override
  _NoOrderReasonSheetState createState() => _NoOrderReasonSheetState();
}

class _NoOrderReasonSheetState extends State<NoOrderReasonSheet> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetHeading("Reason"),
            Column(
                children: List.generate(5, (index) {
              return Row(
                children: [
                  Radio(
                    value: index,
                    groupValue: 1,
                    onChanged: (value) {},
                    splashRadius: 15,
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text("Partial delivery failure")
                ],
              );
            })),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text("Select BU"),
            const SizedBox(
              height: 10,
            ),
            const TagWidget(
              items: ["Yellow Diamond", "Hoppin", "Shree", "Anik", "TinyTush"],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                  splashRadius: 15,
                  visualDensity: VisualDensity.compact,
                ),
                const Text("Issue Resolve"),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: DoneButton(onPressed: () {
                Navigator.pop(context);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
