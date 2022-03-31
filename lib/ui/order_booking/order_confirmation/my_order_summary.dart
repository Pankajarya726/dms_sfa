import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/ready_stock_bill_bottom_sheet.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyOrderSummary extends StatefulWidget {
  const MyOrderSummary({Key? key}) : super(key: key);

  @override
  _MyOrderSummaryState createState() => _MyOrderSummaryState();
}

class _MyOrderSummaryState extends State<MyOrderSummary> {
  List<String> tableHeadings = [
    "S.No",
    "SKU Description",
    "MRP",
    "PTR",
    "Qty\n(MOQs)",
    "Qty\n(Boxes)",
    "Total\nValue"
  ];
  List<String> tableGrandTotal = ["Grand Total", "14", "10", "473.59"];
  List<MyData> myDataList = [];
  TextEditingController txtBillController = TextEditingController();
  String stockBill = "";

  @override
  void initState() {
    getMyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xff303030)),
              right: BorderSide(color: Color(0xff303030)),
            ),
          ),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: List.generate(tableHeadings.length, (index) {
                    return Flexible(
                      flex: index == 1 ? 3 : 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xffADD8E6),
                          border: Border(
                            bottom: BorderSide(color: Color(0xff303030)),
                            left: BorderSide(color: Color(0xff303030)),
                          ),
                        ),
                        child: Text(
                          tableHeadings[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Column(
                children: List.generate(
                  myDataList.length,
                  (columnIndex) {
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          7,
                          (rowIndex) {
                            return Flexible(
                              flex: rowIndex == 1 ? 3 : 1,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Color(0xff303030)),
                                    left: BorderSide(color: Color(0xff303030)),
                                  ),
                                ),
                                child: rowIndex == 0
                                    ? const Text(
                                        "S.No",
                                        style: TextStyle(
                                          color: Color(0xff303030),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : rowIndex == 1
                                        ? const Text("Brand Name",
                                            style: TextStyle(
                                                color: Color(0xff303030),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600))
                                        : rowIndex == 2
                                            ? const Text("Mrp",
                                                style: TextStyle(
                                                    color: Color(0xff303030),
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w600))
                                            : rowIndex == 3
                                                ? const Text("Ptr",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff303030),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600))
                                                : rowIndex == 4
                                                    ? const Text("moqQty",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff303030),
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))
                                                    : rowIndex == 5
                                                        ? const Text(
                                                            "boxQty",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff303030),
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )
                                                        : const Text(
                                                            "Tot V",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff303030),
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  children: List.generate(tableGrandTotal.length, (index) {
                    return Flexible(
                      flex: index == 0 ? 6 : 1,
                      child: Container(
                        alignment: index == 0
                            ? Alignment.center
                            : Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 2),
                        decoration: const BoxDecoration(
                          color: Color(0xffADD8E6),
                          border: Border(
                            bottom: BorderSide(color: Color(0xff303030)),
                            left: BorderSide(color: Color(0xff303030)),
                          ),
                        ),
                        child: Text(
                          tableGrandTotal[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Is this a ready stock bill?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onTap: () async {
                        showModalBottomSheet(
                            context: context,
                            shape: bottomSheetShape,
                            isScrollControlled: false,
                            builder: (context) {
                              return ReadyStockBillBottomSheet(
                                prevSelected: stockBill,
                                onbillSelected: (value) {
                                  if (value.isNotEmpty) {
                                    stockBill = value;
                                    txtBillController.text = stockBill;
                                  }
                                },
                              );
                            });
                      },
                      readOnly: true,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.67,
                        color: MColor.backButton,
                      ),
                      controller: txtBillController,
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
                        contentPadding:
                            const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        filled: true,
                        fillColor: const Color(0xffF2F2F2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: MaterialButton(
          height: 50,
          minWidth: MediaQuery.of(context).size.width,
          color: MColor.colorSecondary,
          textColor: Colors.white,
          onPressed: () async {
            logoutDialog(context);
          },
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
              const SizedBox(
                width: 5,
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
      ),
    );
  }

  Future<List<MyData>> getMyData() async {
    myDataList.add(
      MyData([
        MyBrands("1", "Yellow Diamond", [
          MyCategories(
            "1",
            "chulbule",
            [
              MyProducts(
                  id: "23",
                  productName: "productName",
                  mrp: "27",
                  ptr: "4.6",
                  pkgQty: "3",
                  moqQty: "34",
                  total: "345.4"),
              MyProducts(
                  id: "23",
                  productName: "productName",
                  mrp: "27",
                  ptr: "4.6",
                  pkgQty: "3",
                  moqQty: "34",
                  total: "345.4"),
              MyProducts(
                  id: "23",
                  productName: "productName",
                  mrp: "27",
                  ptr: "4.6",
                  pkgQty: "3",
                  moqQty: "34",
                  total: "345.4")
            ],
          ),
          MyCategories("2", "choco chips", []),
          MyCategories("5", "rings", []),
        ])
      ]),
    );
    myDataList.add(
      MyData([
        MyBrands("1", "Yellow Diamond", [
          MyCategories("1", "chulbule", [
            MyProducts(
                id: "23",
                productName: "productName",
                mrp: "27",
                ptr: "4.6",
                pkgQty: "3",
                moqQty: "34",
                total: "345.4"),
            MyProducts(
                id: "23",
                productName: "productName",
                mrp: "27",
                ptr: "4.6",
                pkgQty: "3",
                moqQty: "34",
                total: "345.4")
          ])
        ])
      ]),
    );
    myDataList.add(
      MyData([
        MyBrands("1", "Yellow Diamond", [
          MyCategories("1", "chulbule", [
            MyProducts(
                id: "23",
                productName: "productName",
                mrp: "27",
                ptr: "4.6",
                pkgQty: "3",
                moqQty: "34",
                total: "345.4")
          ])
        ])
      ]),
    );
    return myDataList;
  }

  logoutDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 15),
          titlePadding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          buttonPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            "Are you sure you want to confirm this Order?",
            style: TextStyle(
              fontSize: 15,
              color: MColor.backButton,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.67,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                StringConst.cancel,
                style: TextStyle(
                  color: Colors.grey[600],
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
          ],
        );
      },
    );
  }
}

class MyData {
  MyData(this.brands);
  List<MyBrands> brands;
}

class MyBrands {
  MyBrands(this.brandId, this.brandName, this.categories);
  String brandId;
  String brandName;
  List<MyCategories> categories;
}

class MyCategories {
  MyCategories(this.categoryId, this.categoryName, this.products);
  String categoryId;
  String categoryName;
  List<MyProducts> products;
}

class MyProducts {
  MyProducts({
    required this.id,
    required this.productName,
    required this.mrp,
    required this.ptr,
    required this.total,
    required this.pkgQty,
    required this.moqQty,
  });
  String id;
  String productName;
  String mrp;
  String ptr;
  String pkgQty;
  String moqQty;
  String total;
}
