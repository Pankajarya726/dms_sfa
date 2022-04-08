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

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 1,
      minChildSize: 0.6,
      builder: (BuildContext context, ScrollController scrollController) {
        return widget.product.isNotEmpty
            ? ListView.builder(
                controller: scrollController,
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  return itemList[index];
                },
              )
            : const Center(
                child: Text("Products not found!"),
              );
      },
    );
  }

  getList() {
    itemList.add(heading);
    for (int i = 0; i < widget.product.length; i++) {
      OrderHistory history = OrderHistory(
        name: widget.product[i].categoryName + " " + widget.product[i].variantName,
        quantity: widget.product[i].qtyPkg + " | " + widget.product[i].qtyMoq,
        price: currencyFormat.format(double.parse(widget.product[i].totalAmount)),
      );

      itemList.add(
        OrderHistoryWidget(
          history: history,
        ),
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

class OrderHistory {
  final String name;
  final String quantity;
  final String price;
  OrderHistory({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class OrderHistoryWidget extends StatelessWidget {
  final OrderHistory history;

  const OrderHistoryWidget({
    Key? key,
    required this.history,
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
            history.name,
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
                  text: "Qty: ",
                  style: const TextStyle(
                    color: MColor.textColor,
                    fontSize: 16,
                    letterSpacing: 0.67,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: history.quantity,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        letterSpacing: 0.67,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                history.price,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
