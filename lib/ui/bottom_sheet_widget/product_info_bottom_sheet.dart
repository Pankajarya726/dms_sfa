import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductInfoBottomSheet extends StatefulWidget {
  final ProductsModal products;
  const ProductInfoBottomSheet({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  _ProductInfoBottomSheetState createState() => _ProductInfoBottomSheetState();
}

class _ProductInfoBottomSheetState extends State<ProductInfoBottomSheet> {
  List<String> textLabel = [
    "Long Description: ",
    "Variant: ",
    "Weight: ",
    "Pcs Per MOQ: ",
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
        minHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    StringConst.productInfo,
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
                    widget.products.skuCode,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      letterSpacing: 0.67,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  getText(
                    textLabel[0],
                    widget.products.longDescription,
                  ),
                  getText(
                    textLabel[1],
                    widget.products.variantName,
                  ),
                  getText(
                    textLabel[2],
                    widget.products.weight,
                  ),
                  getText(
                    "Pcs Per ${widget.products.moqName}: ",
                    widget.products.pcsPerMoq,
                  ),
                  getText(
                    "Pcs Per ${widget.products.packagingName}: ",
                    widget.products.pcsPerPackaging,
                  ),
                  getText(
                    textLabel[5],
                    currencyFormat.format(double.parse(widget.products.skuRatePerPiece)),
                  ),
                  getText(
                    "PTR Per ${widget.products.moqName}: ",
                    currencyFormat.format(double.parse(widget.products.skuRatePerMoq)),
                  ),
                  getText(
                    "PTR Per ${widget.products.packagingName}: ",
                    currencyFormat.format(double.parse(widget.products.skuRatePerPkg)),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: const Color(0xffDCDCDC),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  widget.products.schemes.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.products.schemes.first.schemeName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                letterSpacing: 0.67,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            getText(
                              textLabel2[0],
                              widget.products.schemes.first.discountPercentage.isNotEmpty
                                  ? widget.products.schemes.first.discountPercentage + "%"
                                  : currencyFormat.format(double.parse(widget.products.schemes.first.discountAmount)),
                            ),
                            getText(textLabel2[1],
                                DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.products.schemes.first.fromDate))),
                            getText(
                                textLabel2[2], DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.products.schemes.first.toDate))),
                          ],
                        )
                      : const Text(
                          "Schemes not found",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 0.67,
                          ),
                        ),
                ],
              ),
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
