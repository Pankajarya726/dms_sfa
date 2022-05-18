import 'dart:convert';
import 'dart:developer';

import 'package:dms/database/db_constant.dart';
import 'package:dms/listeners/reason_listener.dart';
import 'package:dms/main.dart';
import 'package:dms/model/base_response.dart';
import 'package:dms/ui/order_booking/order_confirmation/model/get_bu_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailers_list_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'model/get_reason_response.dart';

class OrderSummery extends StatefulWidget {
  final String beatId;
  final String retailerId;
  final String orderId;
  final Function(ReasonsListener? reasonsListener) onInit;

  const OrderSummery(
      {Key? key,
      required this.onInit,
      required this.beatId,
      required this.orderId,
      required this.retailerId})
      : super(key: key);

  @override
  State<OrderSummery> createState() => _OrderSummeryState();
}

class _OrderSummeryState extends State<OrderSummery>
    implements ReasonsListener {
  List<Widget> rowList = [];
  TextEditingController txtReadyStockController = TextEditingController();
  ReasonsModal reason = ReasonsModal(taskType: "", id: "", tagName: "");
  String remark = "";
  List<BUModal> buList = [];
  bool issueResolve = false;
  String isReadyStock = "No";

  @override
  void initState() {
    widget.onInit(this);
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(child: rowList[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 0.6,
                      color: Color(0xff555555),
                      height: 0.6,
                    );
                  },
                  itemCount: rowList.length),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Is this a ready stock bill?",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: "No",
                      child: ListTile(
                        title: Text("No"),
                      ),
                    ),
                    const PopupMenuItem(
                      value: "Yes",
                      child: ListTile(
                        title: Text("Yes"),
                      ),
                    )
                  ];
                },
                initialValue: "No",
                onSelected: (item) {
                  debugPrint("item---->$item");
                  isReadyStock = item.toString();
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isReadyStock),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
          onPressed: () {
            submit(context);
          },
          color: MColor.colorSecondary,
          minWidth: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "CONFIRM",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5),
              ),
              const SizedBox(
                width: 5,
              ),
              Image.asset(
                "assets/arrow.png",
                height: 27,
              )
            ],
          ),
        ),
      ),
    );
  }

  void getProduct() async {
    List<BrandWiseCart> brandList = await databaseHelper.getCartBrandWise();
    debugPrint("brandList-->${brandList.length}");

    if (brandList.isNotEmpty) {
      rowList.add(Container(
        decoration: const BoxDecoration(
            color: Color(0xffADD8E6),
            border: Border(
              top: BorderSide(color: Color(0xff555555), width: 0.6),
              // bottom: BorderSide(color: Color(0xff555555), width: 0.6),
            )),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: const [
              DataCell(value: "Sn", flex: 1),
              DataCell(value: "SKU Description", flex: 6),
              DataCell(value: "MRP", flex: 2),
              DataCell(value: "PTR", flex: 2),
              DataCell(value: "Qty\n(MOQs)", flex: 2),
              DataCell(value: "Qty\n(Boxes)", flex: 2),
              DataCell(value: "Total", flex: 3),
            ],
          ),
        ),
      ));

      int totalMoq = 0;
      int totalPkg = 0;
      double totalAmount = 0;

      await Future.forEach(brandList, (BrandWiseCart brand) async {
        totalMoq += int.parse(brand.moqTotal);
        totalPkg += int.parse(brand.pkgTotal);
        totalAmount += double.parse(brand.total);

        rowList.add(Container(
          color: const Color(0xffC5F3C5),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                DataCell(value: brand.brandName, flex: 11),
                DataCell(value: brand.moqTotal, flex: 2),
                DataCell(value: brand.pkgTotal, flex: 2),
                DataCell(
                    value: double.parse(brand.total).toStringAsFixed(2),
                    flex: 3),
              ],
            ),
          ),
        ));
        int i = 1;

        await Future.forEach(brand.cartList, (Cart item) {
          double total = 0;
          total = double.parse(item.totalPrice);
          rowList.add(IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                DataCell(value: "$i", flex: 1),
                DataCell(value: item.description, flex: 6),
                DataCell(
                    value: double.parse(item.mrp).toStringAsFixed(2), flex: 2),
                DataCell1(
                    price:
                        double.parse(item.skuRatePerPiece).toStringAsFixed(2),
                    schemePrice:
                        double.parse(item.schemeRatePerPcs).toStringAsFixed(2),
                    flex: 2),
                // DataCell(value: item.skuRatePerPiece, flex: 2),
                DataCell(value: item.moqQty.toString(), flex: 2),
                DataCell(value: item.pkgOty.toString(), flex: 2),
                DataCell(value: total.toStringAsFixed(2), flex: 3),
              ],
            ),
          ));
          i++;
        });
      });

      rowList.add(Container(
        decoration: const BoxDecoration(
            color: Color(0xffADD8E6),
            border: Border(
              // top: BorderSide(color: Color(0xff555555), width: 0.6),
              bottom: BorderSide(color: Color(0xff555555), width: 0.6),
            )),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              const DataCell(value: "Grand Total", flex: 11),
              DataCell(value: totalMoq.toString(), flex: 2),
              DataCell(value: totalPkg.toString(), flex: 2),
              DataCell(value: totalAmount.toStringAsFixed(2), flex: 3),
            ],
          ),
        ),
      ));

      // employeeDataSource = EmployeeDataSource(summery);
      setState(() {});
    } else {
      Utility.showToast("No item in your cart");
    }
  }

  void submit(BuildContext context) async {
    List<Cart> products = await databaseHelper.getCart();
    List<Map<String, dynamic>> productListMap = [];
    Map<String, dynamic> input = {};

    if (products.isEmpty) {
      Utility.showToast("Please select at least one product");
      return;
    }

    int totalMoq = 0;
    int totalPkg = 0;
    double totalAmount = 0;
    await Future.forEach(products, (Cart product) {
      Map<String, dynamic> productMap = {};

      productMap["sku_id"] = product.productId;
      productMap["category_id"] = product.categoryId;
      productMap["variant_id"] = product.variantId;
      productMap["mrp"] = product.mrp;
      productMap["ptr_pkg_price"] = product.skuRatePerPiece;
      productMap["ptr_moq_price"] = product.skuRatePerMoq;
      productMap["scheme_pkg_price"] = product.priceAfterDiscount;
      productMap["scheme_moq_price"] = product.priceAfterDiscount;
      productMap["qty_pkg"] = product.pkgOty;
      productMap["qty_moq"] = product.moqQty;
      productMap["rate_category_id"] = product.rateCategoryId;
      productMap["scheme_id"] = product.schemeId;
      productMap["amount"] = product.totalPrice;
      productMap["customer_id"] = product.customerId;
      productMap["bu_id"] = product.buId;
      productMap["brand_id"] = product.brandId;

      totalMoq += product.moqQty;
      totalPkg += product.pkgOty;
      totalAmount += double.parse(product.totalPrice);

      productListMap.add(productMap);
    });

    input["beat_id"] = widget.beatId;
    input["retailer_id"] = widget.retailerId;
    input["total_pkg"] = totalPkg;
    input["total_moq"] = totalMoq;
    input["total_amount"] = totalAmount;
    input["products"] = productListMap;
    input["is_ready_stock_bill"] = isReadyStock == "Yes" ? 1 : 0;

    if (widget.orderId.isEmpty) {
      input["task_type"] = reason.taskType;
      input["escalation_id"] = reason.id;
      input["escalation_tag"] = reason.tagName;
      input["task_remark"] = remark;

      String buIds = "";

      for (int i = 0; i < buList.length; i++) {
        if (i == buList.length - 1) {
          buIds += buList[i].id;
        } else {
          buIds += buList[i].id + ",";
        }
      }

      input["bu_id"] = buIds;
    } else {
      input["order_id"] = widget.orderId;
    }

    log("input--->${jsonEncode(input)}");
    bool? save = await Utility.showConfirmAlert(
        title: 'Are you sure you want to confirm this Order?',
        context: context,
        cancelText: "Cancel",
        confirmText: "Confirm");
    if (save != null && save) {
      if (await Network.isConnected()) {
        EasyLoading.show();
        BaseResponse response;
        if (widget.orderId.isEmpty) {
          response = await repository.saveOrder(input);
        } else {
          response = await repository.updateOrder(input);
        }

        EasyLoading.dismiss();
        Utility.showToast(response.message);
        if (response.success) {
          await databaseHelper.clearCart();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const RetailerListScreen()),
              (Route<dynamic> route) => false);
        }
      } else {
        Utility.showToast(Constants.internetAlert);
      }
    }
  }

  @override
  void onReasonSelect(ReasonsModal reason, String remark, List<BUModal> buList,
      bool issueResolve) {
    this.reason = reason;
    this.remark = remark;
    this.buList = buList;
    this.issueResolve = issueResolve;
  }

  Future<bool?> showConfirmAlert(BuildContext context) async {
    return await showDialog<bool?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(15),
            content: const Text("Are you sure you want to confirm this Order?"),
            actions: [
              TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: MColor.colorPrimary, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }
}

class DataCell extends StatelessWidget {
  final String value;
  final int flex;

  const DataCell({Key? key, required this.value, required this.flex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(width: 0.6, color: Color(0xff555555)))),
        alignment: Alignment.center,
        child: Text(
          value,
          maxLines: 5,
          style: const TextStyle(color: MColor.textColor, fontSize: 12),
        ),
      ),
      fit: FlexFit.tight,
      flex: flex,
    );
  }
}

class DataCell1 extends StatelessWidget {
  final String price;
  final String schemePrice;
  final int flex;

  const DataCell1(
      {Key? key,
      required this.price,
      required this.schemePrice,
      required this.flex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(width: 0.6, color: Color(0xff555555)))),
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: price,
              style: TextStyle(
                  color: MColor.textColor,
                  fontSize: 12,
                  decoration: double.parse(schemePrice) == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            TextSpan(
              text: double.parse(schemePrice) == 0 ? "" : "\n" + schemePrice,
              style: const TextStyle(color: MColor.textColor, fontSize: 12),
            )
          ]),
          maxLines: 5,
        ),
      ),
      fit: FlexFit.tight,
      flex: flex,
    );
  }
}
