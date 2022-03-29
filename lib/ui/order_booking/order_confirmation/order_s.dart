import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OrderS extends StatefulWidget {
  const OrderS({Key? key}) : super(key: key);

  @override
  State<OrderS> createState() => _OrderSState();
}

class _OrderSState extends State<OrderS> {
  List<Empolyee> employee = [];
  late EmployeeDataSource employeeDataSource;

  @override
  void initState() {
    employee = getEmployeeData();
    employeeDataSource = EmployeeDataSource(employee);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SfDataGrid(
          source: employeeDataSource,
          columnWidthMode: ColumnWidthMode.fill,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columns: [
            GridColumn(
              maximumWidth: 30,
              columnName: "sno",
              label: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "S.No",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            GridColumn(
              columnName: "skuDescription",
              label: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "SKU Description",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            GridColumn(
              columnName: "mrp",
              maximumWidth: 50,
              label: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "MRP",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            GridColumn(
              columnName: "ptr",
              maximumWidth: 30,
              label: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "PTR",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            GridColumn(
              columnName: "qtyMoqs",
              maximumWidth: 40,
              label: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Qty(MOQs)",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            GridColumn(
              columnName: "qtyBoxes",
              maximumWidth: 40,
              label: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Qty(Boxes)",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            GridColumn(
              columnName: "totalValues",
              maximumWidth: 50,
              label: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Total Values",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(List<Empolyee> employees) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell(columnName: "S.No", value: dataGridRow.sno),
              DataGridCell(
                  columnName: "Sku Description",
                  value: dataGridRow.skuDescription),
              DataGridCell(columnName: "MRP", value: dataGridRow.mrp),
              DataGridCell(columnName: "PTR", value: dataGridRow.ptr),
              DataGridCell(columnName: "qtyMoqs", value: dataGridRow.qtyMoqs),
              DataGridCell(columnName: "qtyBoxes", value: dataGridRow.qtyBoxes),
              DataGridCell(
                  columnName: "totalValues", value: dataGridRow.totalValue),
            ]))
        .toList();
  }
  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            dataGridCell.value.toString(),
            style: const TextStyle(fontSize: 10),
          ),
        ),
      );
    }).toList());
  }
}

List<Empolyee> getEmployeeData() {
  return [
    Empolyee(
        sno: 1,
        skuDescription:
            "YD Namkeen Ring Toma- to 13 gm 210 pkt Rs. 5 -With Race Toys",
        mrp: "5.00",
        ptr: "4.10",
        qtyMoqs: "4",
        qtyBoxes: "5",
        totalValue: "299.27"),
    Empolyee(
        sno: 2,
        skuDescription: "YD Namkeen Mixture 24gm 360 pkt Rs 5",
        mrp: "5.00",
        ptr: "4.10",
        qtyMoqs: "4",
        qtyBoxes: "5",
        totalValue: "299.27"),
    Empolyee(
        sno: 3,
        skuDescription: "RF Cup Cake Chocolate 18 gm 160 pkt Rs 5",
        mrp: "5.00",
        ptr: "4.10",
        qtyMoqs: "4",
        qtyBoxes: "5",
        totalValue: "299.27"),
    Empolyee(
        sno: 4,
        skuDescription: "HO Glow Pop Animal Rs 5",
        mrp: "5.00",
        ptr: "4.10",
        qtyMoqs: "4",
        qtyBoxes: "5",
        totalValue: "299.27"),
    Empolyee(
        sno: 5,
        skuDescription:
            "YD Namkeen Ring Toma- to 13 gm 210 pkt Rs. 5 -With Race Toys",
        mrp: "5.00",
        ptr: "4.10",
        qtyMoqs: "4",
        qtyBoxes: "5",
        totalValue: "299.27"),
    Empolyee(
        sno: 6,
        skuDescription: "YD Namkeen Mixture 24gm 360 pkt Rs 5",
        mrp: "5.00",
        ptr: "4.10",
        qtyMoqs: "4",
        qtyBoxes: "5",
        totalValue: "299.27"),
    Empolyee(
        sno: 7,
        skuDescription: "RF Cup Cake Chocolate 18 gm 160 pkt Rs 5",
        mrp: "5.00",
        ptr: "4.10",
        qtyMoqs: "4",
        qtyBoxes: "5",
        totalValue: "299.27"),
  ];
}

class Empolyee {
  Empolyee({
    required this.sno,
    required this.skuDescription,
    required this.mrp,
    required this.ptr,
    required this.qtyMoqs,
    required this.qtyBoxes,
    required this.totalValue,
  });

  final int sno;
  final String skuDescription;
  final String mrp;
  final String ptr;
  final String qtyMoqs;
  final String qtyBoxes;
  final String totalValue;
}




// import 'package:flutter/material.dart';

// class OrderS extends StatefulWidget {
//   const OrderS({Key? key}) : super(key: key);

//   @override
//   _OrderSState createState() => _OrderSState();
// }

// class _OrderSState extends State<OrderS> {
//   List<String> tableHeadings = [
//     "S.No",
//     "SKU Description",
//     "MRP",
//     "PTR",
//     "Qty\n(MOQs)",
//     "Qty\n(Boxes)",
//     "Total\nValue"
//   ];
//   List<String> tableBUTotal = ["Yellow Diamond", "4", "2", "174.32"];
//   List<String> tableGrandTotal = ["Grand Total", "14", "10", "473.59"];
//   List<Product> yellowDiamond = [];
//   List<Product> hoppin = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
//         child: Container(
//           decoration: const BoxDecoration(
//             border: Border(
//               top: BorderSide(color: Color(0xff303030)),
//               right: BorderSide(color: Color(0xff303030)),
//             ),
//           ),
//           child: Column(
//             children: [
//               IntrinsicHeight(
//                 child: Row(
//                   children: List.generate(tableHeadings.length, (index) {
//                     return Flexible(
//                       flex: index == 1 ? 3 : 1,
//                       child: Container(
//                         alignment: Alignment.centerLeft,
//                         padding: const EdgeInsets.all(2),
//                         decoration: const BoxDecoration(
//                           color: Color(0xffADD8E6),
//                           border: Border(
//                             bottom: BorderSide(color: Color(0xff303030)),
//                             left: BorderSide(color: Color(0xff303030)),
//                           ),
//                         ),
//                         child: Text(
//                           tableHeadings[index],
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//               IntrinsicHeight(
//                 child: Row(
//                   children: List.generate(tableBUTotal.length, (index) {
//                     return Flexible(
//                       flex: index == 0 ? 6 : 1,
//                       child: Container(
//                         alignment: index == 0
//                             ? Alignment.center
//                             : Alignment.centerLeft,
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 6, horizontal: 2),
//                         decoration: const BoxDecoration(
//                           color: Color(0xffC5F3C5),
//                           border: Border(
//                             bottom: BorderSide(color: Color(0xff303030)),
//                             left: BorderSide(color: Color(0xff303030)),
//                           ),
//                         ),
//                         child: FutureBuilder<SummeryData>(
//                           future: getData(),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData) {
//                               return index == 0
//                                   ? Text(
//                                       snapshot.data!.yellowDiamond[index].brand,
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     )
//                                   : Text(
//                                       tableBUTotal[index],
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     );
//                             } else if (snapshot.hasError) {
//                               return Text('${snapshot.error}');
//                             }
//                             // By default, show a loading spinner.
//                             return const CircularProgressIndicator();
//                           },
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//               Column(
//                 children: List.generate(3, (columnIndex) {
//                   return FutureBuilder<SummeryData>(
//                     future: getData(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         return IntrinsicHeight(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: List.generate(7, (rowIndex) {
//                               return Flexible(
//                                 flex: rowIndex == 1 ? 3 : 1,
//                                 child: Container(
//                                   alignment: Alignment.centerLeft,
//                                   padding: const EdgeInsets.all(2),
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     border: Border(
//                                       bottom:
//                                           BorderSide(color: Color(0xff303030)),
//                                       left:
//                                           BorderSide(color: Color(0xff303030)),
//                                     ),
//                                   ),
//                                   child: rowIndex == 0
//                                       ? Text(
//                                           snapshot.data!
//                                               .yellowDiamond[columnIndex].sno,
//                                           style: const TextStyle(
//                                             color: Color(0xff303030),
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         )
//                                       : rowIndex == 1
//                                           ? Text(
//                                               snapshot
//                                                   .data!
//                                                   .yellowDiamond[columnIndex]
//                                                   .productName,
//                                               style: const TextStyle(
//                                                   color: Color(0xff303030),
//                                                   fontSize: 10,
//                                                   fontWeight: FontWeight.w600))
//                                           : rowIndex == 2
//                                               ? Text(snapshot.data!.yellowDiamond[columnIndex].mrp,
//                                                   style: const TextStyle(
//                                                       color: Color(0xff303030),
//                                                       fontSize: 10,
//                                                       fontWeight:
//                                                           FontWeight.w600))
//                                               : rowIndex == 3
//                                                   ? Text(snapshot.data!.yellowDiamond[columnIndex].ptr,
//                                                       style: const TextStyle(
//                                                           color:
//                                                               Color(0xff303030),
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w600))
//                                                   : rowIndex == 4
//                                                       ? Text(
//                                                           snapshot
//                                                               .data!
//                                                               .yellowDiamond[
//                                                                   columnIndex]
//                                                               .moqQty
//                                                               .toString(),
//                                                           style: const TextStyle(
//                                                               color: Color(
//                                                                   0xff303030),
//                                                               fontSize: 10,
//                                                               fontWeight:
//                                                                   FontWeight.w600))
//                                                       : rowIndex == 5
//                                                           ? Text(
//                                                               snapshot
//                                                                   .data!
//                                                                   .yellowDiamond[
//                                                                       columnIndex]
//                                                                   .boxQty
//                                                                   .toString(),
//                                                               style: const TextStyle(
//                                                                   color: Color(
//                                                                       0xff303030),
//                                                                   fontSize: 10,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w600),
//                                                             )
//                                                           : Text(
//                                                               snapshot
//                                                                   .data!
//                                                                   .yellowDiamond[
//                                                                       columnIndex]
//                                                                   .total,
//                                                               style:
//                                                                   const TextStyle(
//                                                                 color: Color(
//                                                                     0xff303030),
//                                                                 fontSize: 10,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                               ),
//                                                             ),
//                                 ),
//                               );
//                             }),
//                           ),
//                         );
//                       } else if (snapshot.hasError) {
//                         return Text('${snapshot.error}');
//                       }
//                       // By default, show a loading spinner.
//                       return const CircularProgressIndicator();
//                     },
//                   );
//                 }),
//               ),
//               IntrinsicHeight(
//                 child: Row(
//                   children: List.generate(tableBUTotal.length, (index) {
//                     return Flexible(
//                       flex: index == 0 ? 6 : 1,
//                       child: Container(
//                         alignment: index == 0
//                             ? Alignment.center
//                             : Alignment.centerLeft,
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 6, horizontal: 2),
//                         decoration: const BoxDecoration(
//                           color: Color(0xffC5F3C5),
//                           border: Border(
//                             bottom: BorderSide(color: Color(0xff303030)),
//                             left: BorderSide(color: Color(0xff303030)),
//                           ),
//                         ),
//                         child: FutureBuilder<SummeryData>(
//                           future: getData(),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData) {
//                               return index == 0
//                                   ? Text(
//                                       snapshot.data!.hoppin[index].brand,
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     )
//                                   : Text(
//                                       tableBUTotal[index],
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     );
//                             } else if (snapshot.hasError) {
//                               return Text('${snapshot.error}');
//                             }
//                             // By default, show a loading spinner.
//                             return const CircularProgressIndicator();
//                           },
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//               Column(
//                 children: List.generate(2, (columnIndex) {
//                   return FutureBuilder<SummeryData>(
//                     future: getData(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         return IntrinsicHeight(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: List.generate(7, (rowIndex) {
//                               return Flexible(
//                                 flex: rowIndex == 1 ? 3 : 1,
//                                 child: Container(
//                                   alignment: Alignment.centerLeft,
//                                   padding: const EdgeInsets.all(2),
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     border: Border(
//                                       bottom:
//                                           BorderSide(color: Color(0xff303030)),
//                                       left:
//                                           BorderSide(color: Color(0xff303030)),
//                                     ),
//                                   ),
//                                   child: rowIndex == 0
//                                       ? Text(
//                                           snapshot
//                                               .data!.hoppin[columnIndex].sno,
//                                           style: const TextStyle(
//                                             color: Color(0xff303030),
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         )
//                                       : rowIndex == 1
//                                           ? Text(
//                                               snapshot.data!.hoppin[columnIndex]
//                                                   .productName,
//                                               style: const TextStyle(
//                                                   color: Color(0xff303030),
//                                                   fontSize: 10,
//                                                   fontWeight: FontWeight.w600))
//                                           : rowIndex == 2
//                                               ? Text(
//                                                   snapshot.data!
//                                                       .hoppin[columnIndex].mrp,
//                                                   style: const TextStyle(
//                                                     color: Color(0xff303030),
//                                                     fontSize: 10,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 )
//                                               : rowIndex == 3
//                                                   ? Text(
//                                                       snapshot
//                                                           .data!
//                                                           .hoppin[columnIndex]
//                                                           .ptr,
//                                                       style: const TextStyle(
//                                                         color:
//                                                             Color(0xff303030),
//                                                         fontSize: 10,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       ),
//                                                     )
//                                                   : rowIndex == 4
//                                                       ? Text(
//                                                           snapshot
//                                                               .data!
//                                                               .hoppin[
//                                                                   columnIndex]
//                                                               .moqQty
//                                                               .toString(),
//                                                           style:
//                                                               const TextStyle(
//                                                             color: Color(
//                                                                 0xff303030),
//                                                             fontSize: 10,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                           ),
//                                                         )
//                                                       : rowIndex == 5
//                                                           ? Text(
//                                                               snapshot
//                                                                   .data!
//                                                                   .hoppin[
//                                                                       columnIndex]
//                                                                   .boxQty
//                                                                   .toString(),
//                                                               style:
//                                                                   const TextStyle(
//                                                                 color: Color(
//                                                                     0xff303030),
//                                                                 fontSize: 10,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                               ),
//                                                             )
//                                                           : Text(
//                                                               snapshot
//                                                                   .data!
//                                                                   .hoppin[
//                                                                       columnIndex]
//                                                                   .total,
//                                                               style:
//                                                                   const TextStyle(
//                                                                 color: Color(
//                                                                     0xff303030),
//                                                                 fontSize: 10,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                               ),
//                                                             ),
//                                 ),
//                               );
//                             }),
//                           ),
//                         );
//                       } else if (snapshot.hasError) {
//                         return Text('${snapshot.error}');
//                       }
//                       // By default, show a loading spinner.
//                       return const CircularProgressIndicator();
//                     },
//                   );
//                 }),
//               ),
//               IntrinsicHeight(
//                 child: Row(
//                   children: List.generate(tableGrandTotal.length, (index) {
//                     return Flexible(
//                       flex: index == 0 ? 6 : 1,
//                       child: Container(
//                         alignment: index == 0
//                             ? Alignment.center
//                             : Alignment.centerLeft,
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 6, horizontal: 2),
//                         decoration: const BoxDecoration(
//                           color: Color(0xffADD8E6),
//                           border: Border(
//                             bottom: BorderSide(color: Color(0xff303030)),
//                             left: BorderSide(color: Color(0xff303030)),
//                           ),
//                         ),
//                         child: Text(
//                           tableGrandTotal[index],
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<SummeryData> getData() async {
//     yellowDiamond.add(Product(
//       sno: "1",
//       productName:
//           "YD Namkeen Ring Toma- to 13 gm 210 pkt Rs. 5 -With Race Toys",
//       mrp: "5.00",
//       ptr: "4.32 | 4.16",
//       moqQty: 1,
//       boxQty: 1,
//       total: "49.32",
//       brand: "Yellow Diamond",
//     ));
//     yellowDiamond.add(Product(
//       sno: "2",
//       productName: "YD Namkeen Mixture 24gm 360 pkt Rs 5",
//       mrp: "5.25",
//       ptr: "4.10",
//       moqQty: 2,
//       boxQty: 0,
//       total: "35.00",
//       brand: "Yellow Diamond",
//     ));
//     yellowDiamond.add(Product(
//       sno: "3",
//       productName: "RF Cup Cake Chocolate 18 gm 160 pkt Rs 5",
//       mrp: "6.00",
//       ptr: "5.00",
//       moqQty: 1,
//       boxQty: 1,
//       total: "90.00",
//       brand: "Yellow Diamond",
//     ));

//     hoppin.add(Product(
//       sno: "1",
//       productName: "HO Glow Pop Animal Rs 5",
//       mrp: "8.00",
//       ptr: "7.50",
//       moqQty: 4,
//       boxQty: 3,
//       total: "108.00",
//       brand: "Hoppin",
//     ));
//     hoppin.add(Product(
//       sno: "2",
//       productName: "1 HO Glow Pop Duckling Rs 5",
//       mrp: "5.00",
//       ptr: "4.00",
//       moqQty: 2,
//       boxQty: 2,
//       total: "75.27",
//       brand: "Hoppin",
//     ));

//     SummeryData summeryData =
//         SummeryData(yellowDiamond: yellowDiamond, hoppin: hoppin);
//     return summeryData;
//   }
// }

// class SummeryData {
//   List<Product> yellowDiamond;
//   List<Product> hoppin;

//   SummeryData({required this.yellowDiamond, required this.hoppin});
// }

// class Product {
//   String sno;
//   String productName;
//   String mrp;
//   String ptr;
//   int moqQty;
//   int boxQty;
//   String total;
//   String brand;

//   Product(
//       {required this.sno,
//       required this.productName,
//       required this.mrp,
//       required this.ptr,
//       required this.moqQty,
//       required this.boxQty,
//       required this.total,
//       required this.brand});
// }
