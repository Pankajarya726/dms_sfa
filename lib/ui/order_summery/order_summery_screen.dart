import 'dart:ui';

import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/date_picker_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/filter_order_summery.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderSummeryScreen extends StatefulWidget {
  const OrderSummeryScreen({Key? key}) : super(key: key);

  @override
  _OrderSummeryScreenState createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  Data data = Data();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Order Summary"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            splashRadius: 25,
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(context: context, shape: bottomSheetShape, builder: (context) => const FilterOrderSummerySheet());
              },
              splashRadius: 25,
              icon: Image.asset(
                "assets/filter.png",
                width: 27,
                height: 27,
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 16),
                    readOnly: true,
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => SearchRetailerScreen(
                      //           retailerType: selectedEnrollmentType,
                      //           beatsModal: beatsModal != null ? beatsModal! : BeatsModal(id: "", name: ""),
                      //           day: selectedDay,
                      //           index: tabController.index + 1,
                      //         )));
                    },
                    decoration: InputDecoration(
                        hintText: StringConst.search,
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 2,
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFF6E6E6E),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 2,
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFF6E6E6E),
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xff555555),
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  color: const Color(0xffEDEDED),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () async {
                      showModalBottomSheet(
                          context: context,
                          shape: bottomSheetShape,
                          builder: (context) => DatePickerSheet(
                                onSelect: (DateTime frmDate, DateTime endDate) {
                                  fromDate = frmDate;
                                  toDate = endDate;
                                  setState(() {});
                                },
                                toDate: toDate,
                                fromDate: fromDate,
                              ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25), border: Border.all(color: Color(0xffC5C5C5), width: 1)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            fromDate == toDate
                                ? "\t${DateFormat('dd/MM/yyyy').format(fromDate)}\t"
                                : "\t${DateFormat('dd/MM/yyyy').format(fromDate)}\tto\t${DateFormat('dd/MM/yyyy').format(toDate)}\t",
                            style: GoogleFonts.roboto(color: const Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            "assets/date.png",
                            width: 20,
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: ListView.separated(
            itemCount: 5,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 5,
              );
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: const [
                  BoxShadow(
                      color: Color(
                        0xffA6A6A6,
                      ),
                      blurRadius: 5)
                ]),
                child: Slidable(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/amount.png",
                              width: 30,
                              height: 30,
                            ),
                            Expanded(
                              child: Text(
                                data.amount,
                                style: const TextStyle(color: Colors.black, fontSize: 16),
                              ),
                            ),
                            Image.asset("assets/date.png", width: 15, height: 15, color: const Color(0xff777777)),
                            Text(
                              data.date,
                              style: const TextStyle(color: Color(0xff777777), fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/tc.png",
                                    width: 27,
                                    height: 27,
                                  ),
                                  Text(
                                    "\tTC\t-\t" + data.tc,
                                    style: GoogleFonts.roboto(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              flex: 1,
                            ),
                            Flexible(
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/pc.png",
                                    width: 27,
                                    height: 27,
                                  ),
                                  Text(
                                    "\tPC\t-\t" + data.pc,
                                    style: GoogleFonts.roboto(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              flex: 1,
                            ),
                            Flexible(
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/avg.png",
                                    width: 27,
                                    height: 27,
                                  ),
                                  Text(
                                    "\tAvg\t-\t" + data.avg,
                                    style: GoogleFonts.roboto(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Benjamin Wolf",
                          style: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/beat.png",
                              width: 20,
                              height: 20,
                            ),
                            Text(
                              " Vijay Nagar",
                              style: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xffC5C5C5),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/district.png", width: 15, height: 15, color: const Color(0xff777777)),
                            Expanded(
                              child: Text(
                                "\t" + data.district,
                                style: GoogleFonts.roboto(color: const Color(0xff777777), fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Image.asset("assets/tehsil.png", width: 15, height: 15, color: const Color(0xff777777)),
                            Text(
                              "\t" + data.tehsil,
                              style: GoogleFonts.roboto(color: const Color(0xff777777), fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    key: ValueKey(index),
                    extentRatio: 0.30,
                    dragDismissible: false,
                    children: [
                      SlidableAction(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                        padding: const EdgeInsets.all(8),
                        flex: 2,
                        onPressed: (e) {
                          debugPrint("e-->${e.toString()}");
                        },
                        backgroundColor: MColor.colorPrimary,
                        foregroundColor: Colors.white,
                        icon: Icons.download,
                        label: 'Download',
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}

class Data {
  String amount = "100";
  String date = "25 April 2022";
  String tc = "65";
  String pc = "20";
  String avg = "444";
  String name = "Benjamin Wolf";
  String beat = "Vijay Nagar";
  String district = "Bhopal";
  String tehsil = "Paraswada";
}
