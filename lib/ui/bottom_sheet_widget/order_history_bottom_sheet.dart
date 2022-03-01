import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class OrderHistoryBottomSheet extends StatefulWidget {
  final List<Product> product;
  const OrderHistoryBottomSheet({Key? key, required this.product})
      : super(key: key);

  @override
  _OrderHistoryBottomSheetState createState() =>
      _OrderHistoryBottomSheetState();
}

class _OrderHistoryBottomSheetState extends State<OrderHistoryBottomSheet> {
  List<Widget> itemList = [];
  // List<String> flavourName = [
  //   "Surprise Egg Jhony Bravo",
  //   "Lollipop Elaichi Kulfi",
  //   "Candy Cookie N Cream",
  //   "Pepstick Crunchy Chocolate",
  //   "Candy Cookie N Cream",
  //   "Surprise Egg Jhony Bravo",
  //   "Lollipop Elaichi Kulfi",
  //   "Candy Cookie N Cream",
  //   "Pepstick Crunchy Chocolate",
  //   "Candy Cookie N Cream",
  // ];

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
                child: Text("Data not found"),
              );
      },
    );
  }

  getList() {
    itemList.add(heading);
    for (int i = 0; i < widget.product.length; i++) {
      OrderHistory history = OrderHistory(
        name: widget.product[i].variant.isEmpty
            ? widget.product[i].category
            : widget.product[i].category.isEmpty
                ? widget.product[i].variant
                : widget.product[i].variant + " " + widget.product[i].category,
        quantity: widget.product[i].qtyPkg.isNotEmpty &&
                widget.product[i].qtyMoq.isNotEmpty
            ? widget.product[i].qtyPkg + " | " + widget.product[i].qtyMoq
            : "",
        price:
            widget.product[i].mrp.isNotEmpty ? "₹" + widget.product[i].mrp : "",
      );

      itemList.add(
        OrderhistoryWidget(
          history: history,
        ),
      );
    }
  }

  Widget heading = const Padding(
    padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
    child: Text(
      StringConst.summary,
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

class OrderhistoryWidget extends StatelessWidget {
  final OrderHistory history;

  const OrderhistoryWidget({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Color(0xffC5C5C5), width: 0.5)),
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
