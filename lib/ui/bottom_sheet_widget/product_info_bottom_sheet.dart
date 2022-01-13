import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class ProductInfoBottomSheet extends StatefulWidget {
  const ProductInfoBottomSheet({Key? key}) : super(key: key);

  @override
  _ProductInfoBottomSheetState createState() => _ProductInfoBottomSheetState();
}

class _ProductInfoBottomSheetState extends State<ProductInfoBottomSheet> {
  List<String> textLabel = [
    "Long Description: ",
    "Variant: "
        "Weight: ",
    "Pcs Per Moq: ",
    "Pcs Per Packaging: ",
    "PTR Per Piece: ",
    "PTR Per MOQ: ",
    "PTR Per PKG: ",
  ];
  List<String> textValue = [
    "YD Namkeen Chana Masala 23 Gm 210 Pkt Rs 5",
    "Chana Masala",
    "23",
    "14",
    "210",
    "₹10",
    "₹15",
    "₹30",
  ];

  List<String> textLabel2 = [
    "Scheme Discount: ",
    "From Date: ",
    "To Date: ",
  ];
  List<String> textValue2 = [
    "4%",
    "07-11-2021",
    "21-11-2021",
  ];

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              productInfo,
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
            const Text(
              "CB121251",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                letterSpacing: 0.67,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(textLabel.length, (index) {
                return getText(
                  textLabel[index],
                  textValue[index],
                  textLabel.last,
                );
              }),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              schemeInfo,
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
            const Text(
              "November 21 Sales Scheme",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                letterSpacing: 0.67,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(textLabel2.length, (index) {
                return getText(
                  textLabel2[index],
                  textValue2[index],
                  textLabel2.last,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget getText(textLabel, textValue, lastIndexLabel) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: textLabel,
            style: const TextStyle(
              color: MColor.textColor,
              fontSize: 16,
              letterSpacing: 0.67,
            ),
            children: <TextSpan>[
              TextSpan(
                text: textValue,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  letterSpacing: 0.67,
                ),
              ),
            ],
          ),
        ),
        textLabel == lastIndexLabel
            ? const SizedBox(
                height: 0,
              )
            : const SizedBox(
                height: 10,
              ),
      ],
    );
  }
}
