import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class OrderHistoryBottomSheet extends StatefulWidget {
  final List<Product> product;

  const OrderHistoryBottomSheet({Key? key, required this.product}) : super(key: key);

  @override
  _OrderHistoryBottomSheetState createState() => _OrderHistoryBottomSheetState();
}

class _OrderHistoryBottomSheetState extends State<OrderHistoryBottomSheet> {
  List<Widget> itemList = [];
  int totalMoq = 0;
  int totalPkg = 0;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
        minHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      child: widget.product.isNotEmpty
          ? Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      itemList.length,
                      (index) {
                        return itemList[index];
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: MColor.colorPrimary, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: const [
                              Text(
                                "Total Qty",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  letterSpacing: 0.67,
                                ),
                              ),
                              Text(
                                "Total Value",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  letterSpacing: 0.67,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "$totalPkg | $totalMoq",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 0.67,
                                ),
                              ),
                              Text(
                                currencyFormat.format(total),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 0.67,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          : const IntrinsicHeight(
              child: Center(
                child: Text("Products not found!"),
              ),
            ),
    );
  }

  getList() {
    itemList.add(heading);

    for (int i = 0; i < widget.product.length; i++) {
      // OrderHistory history = OrderHistory(
      //   name: widget.product[i].categoryName +
      //       " " +
      //       widget.product[i].variantName,
      //   quantity: widget.product[i].qtyPkg + " | " + widget.product[i].qtyMoq,
      //   price:
      //       currencyFormat.format(double.parse(widget.product[i].totalAmount)),
      // );
      totalPkg = totalPkg + int.parse(widget.product[i].qtyPkg);
      totalMoq = totalMoq + int.parse(widget.product[i].qtyMoq);
      total = total + double.parse(widget.product[i].totalAmount);
      // OrderHistory history = OrderHistory(
      //   product: widget.product[i]
      // );

      itemList.add(
        OrderHistoryWidget(product: widget.product[i]),
      );
    }
  }

  Widget heading = const Padding(
    padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
    child: Text(
      StringConst.orderSummary,
      style: TextStyle(
        fontSize: 19,
        color: MColor.colorPrimary,
        letterSpacing: 0.67,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class OrderHistoryWidget extends StatelessWidget {
  final Product product;

  const OrderHistoryWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffC5C5C5), width: 0.5)),
      ),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.longDescription,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: "Brand: ",
                  style: const TextStyle(
                    color: Color(0xff555555),
                    fontSize: 16,
                    letterSpacing: 0.67,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: product.categoryName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        letterSpacing: 0.67,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "MRP: ",
                  style: const TextStyle(
                    color: Color(0xff555555),
                    fontSize: 16,
                    letterSpacing: 0.67,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: product.mrp,
                      style: const TextStyle(
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
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: "Qty: ",
                  style: const TextStyle(
                    color: Color(0xff555555),
                    fontSize: 16,
                    letterSpacing: 0.67,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: product.qtyPkg + " | " + product.qtyMoq,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        letterSpacing: 0.67,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "Total: ",
                  style: const TextStyle(
                    color: Color(0xff555555),
                    fontSize: 16,
                    letterSpacing: 0.67,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: product.totalAmount,
                      style: const TextStyle(
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
        ],
      ),
    );
  }
}
