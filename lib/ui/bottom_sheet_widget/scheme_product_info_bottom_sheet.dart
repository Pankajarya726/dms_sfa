import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class SchemeProductInfoBottomSheet extends StatefulWidget {
  final ProductsModal schemes;
  const SchemeProductInfoBottomSheet({
    Key? key,
    required this.schemes,
  }) : super(key: key);

  @override
  _SchemeProductInfoBottomSheetState createState() =>
      _SchemeProductInfoBottomSheetState();
}

class _SchemeProductInfoBottomSheetState
    extends State<SchemeProductInfoBottomSheet> {
  List<String> textLabel = [
    "Long Description: ",
    "Variant: ",
    "Weight: ",
    "Pcs Per Moq: ",
    "Pcs Per Packaging: ",
    "PTR Per Piece: ",
    "PTR Per MOQ: ",
    "PTR Per PKG: ",
  ];

  List<String> textLabel2 = [
    "Scheme Discount: ",
    "From Date: ",
    "To Date: ",
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
              StringConst.schemeProductInfo,
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
            Text(
              widget.schemes.skuCode,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                letterSpacing: 0.67,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              getText(
                textLabel[0],
                widget.schemes.longDescription,
              ),
              getText(
                textLabel[1],
                widget.schemes.variantName,
              ),
              getText(
                textLabel[2],
                widget.schemes.weight,
              ),
              getText(
                textLabel[3],
                widget.schemes.pcsPerMoq,
              ),
              getText(
                textLabel[4],
                widget.schemes.pcsPerPackaging,
              ),
              getText(
                textLabel[5],
                widget.schemes.skuRatePerPiece,
              ),
              getText(
                textLabel[6],
                widget.schemes.skuRatePerMoq,
              ),
              getText(
                textLabel[7],
                widget.schemes.skuRatePerPkg,
              ),
            ]),
            const SizedBox(
              height: 30,
            ),
            const Text(
              StringConst.schemeInfo,
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
              children: [
                getText(
                  textLabel2[0],
                  widget.schemes.schemes!.isNotEmpty
                      ? widget.schemes.schemes!.first.discountPercentage
                      : "",
                ),
                getText(
                  textLabel2[1],
                  widget.schemes.schemes!.isNotEmpty
                      ? widget.schemes.schemes!.first.fromDate
                      : "",
                ),
                getText(
                  textLabel2[2],
                  widget.schemes.schemes!.isNotEmpty
                      ? widget.schemes.schemes!.first.toDate
                      : "",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getText(textLabel, textValue) {
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
