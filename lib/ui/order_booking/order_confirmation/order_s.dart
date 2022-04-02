import 'package:dms/database/db_constant.dart';
import 'package:dms/listeners/reason_listener.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/ready_stock_bill_bottom_sheet.dart';
import 'package:dms/ui/order_booking/order_confirmation/model/get_bu_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrderS extends StatefulWidget {
  final Function(ReasonsListener? reasonsListener) onInit;
  const OrderS({
    Key? key,
    required this.onInit,
  }) : super(key: key);

  @override
  State<OrderS> createState() => _OrderSState();
}

class _OrderSState extends State<OrderS> implements ReasonsListener {
  List<Widget> rowList = [];
  TextEditingController txtReadyStockController = TextEditingController();
  String reason = "";
  String remark = "";
  List<BUModal> buList = [];
  bool issueResolve = false;

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
            delegate: SliverChildListDelegate(
              [
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    "Is this a ready stock bill?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    onTap: () async {
                      showModalBottomSheet(
                        context: context,
                        shape: bottomSheetShape,
                        isScrollControlled: false,
                        builder: (context) => ReadyStockBillBottomSheet(
                          prevSelected: txtReadyStockController.text,
                          onbillSelected: (value) {
                            txtReadyStockController.text = value;
                          },
                        ),
                      );
                    },
                    readOnly: true,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.67,
                      color: MColor.backButton,
                    ),
                    controller: txtReadyStockController,
                    decoration: InputDecoration(
                      suffixIcon: const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: MColor.backButton,
                          size: 30,
                        ),
                      ),
                      hintText: StringConst.selectHint,
                      hintStyle: const TextStyle(
                        color: MColor.backButton,
                        letterSpacing: 0.67,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      filled: true,
                      fillColor: const Color(0xffF2F2F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: MaterialButton(
        onPressed: () {
          logoutDialog(context);
        },
        color: MColor.colorSecondary,
        height: 50,
        minWidth: MediaQuery.of(context).size.width,
        shape: const RoundedRectangleBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              StringConst.confirm,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 0.67,
              ),
            ),
            SizedBox(
              width: 20,
              height: 15,
              child: SvgPicture.asset(
                "assets/arrow_right.svg",
                height: 20,
                fit: BoxFit.contain,
                width: 15,
                allowDrawingOutsideViewBox: false,
                matchTextDirection: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  logoutDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 15),
          titlePadding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          buttonPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            "Are you sure you want to confirm this Order?",
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 0.67,
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                StringConst.cancel,
                style: TextStyle(
                  color: MColor.inactiveTextColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.67,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                StringConst.confirmSmall,
                style: TextStyle(
                  color: Color(0xfff4511e),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.67,
                ),
              ),
              onPressed: () async {},
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        );
      },
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
                DataCell(value: brand.total, flex: 3),
              ],
            ),
          ),
        ));
        int i = 1;

        await Future.forEach(brand.cartList, (Cart item) {
          double total = 0;
          total = double.parse(item.skuRatePerPkg) * item.pkgOty +
              double.parse(item.skuRatePerMoq) * item.moqQty;
          rowList.add(IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                DataCell(value: "$i", flex: 1),
                DataCell(value: item.description, flex: 6),
                DataCell(value: item.mrp, flex: 2),
                DataCell(value: item.ptr, flex: 2),
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

  @override
  void onReasonSelect(
      String reason, String remark, List<BUModal> buList, bool issueResolve) {
    this.reason = reason;
    this.remark = remark;
    this.buList = buList;
    this.issueResolve = issueResolve;
    debugPrint("order summary sheet reason ${this.reason}");
    debugPrint("order summary sheet remark ${this.remark}");
    debugPrint("order summary sheet buList ${this.buList.first.businessUnit}");
    debugPrint("order summary sheet issueResolve ${this.issueResolve}");
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
