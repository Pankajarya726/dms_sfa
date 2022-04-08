import 'package:dms/database/db_constant.dart';
import 'package:dms/main.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';

class OrderSummeryTable extends StatefulWidget {
  const OrderSummeryTable({Key? key}) : super(key: key);

  @override
  _OrderSummeryTableState createState() => _OrderSummeryTableState();
}

class _OrderSummeryTableState extends State<OrderSummeryTable> {
  List<Widget> rowList = [];

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
        itemCount: rowList.length);
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
                DataCell(value: double.parse(brand.total).toStringAsFixed(2), flex: 3),
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
                DataCell(value: double.parse(item.mrp).toStringAsFixed(2), flex: 2),
                DataCell1(
                    price: double.parse(item.skuRatePerPiece).toStringAsFixed(2),
                    schemePrice: double.parse(item.schemeRatePerPcs).toStringAsFixed(2),
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
}

class DataCell extends StatelessWidget {
  final String value;
  final int flex;

  const DataCell({Key? key, required this.value, required this.flex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(border: Border(right: BorderSide(width: 0.6, color: Color(0xff555555)))),
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

  const DataCell1({Key? key, required this.price, required this.schemePrice, required this.flex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(border: Border(right: BorderSide(width: 0.6, color: Color(0xff555555)))),
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: price,
              style: TextStyle(
                  color: MColor.textColor,
                  fontSize: 12,
                  decoration: double.parse(schemePrice) == 0 ? TextDecoration.none : TextDecoration.lineThrough),
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
