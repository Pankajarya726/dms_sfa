import 'package:dms/database/db_constant.dart';
import 'package:dms/main.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';

class OrderS extends StatefulWidget {
  const OrderS({Key? key}) : super(key: key);

  @override
  State<OrderS> createState() => _OrderSState();
}

class _OrderSState extends State<OrderS> {
  List<Widget> rowList = [];
  String isReadyStock = "No";

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
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
            )
          ]),
        )
      ],
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
          total = double.parse(item.skuRatePerPkg) * item.pkgOty + double.parse(item.skuRatePerMoq) * item.moqQty;
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
