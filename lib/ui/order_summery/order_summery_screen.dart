import 'package:dms/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderSummeryScreen extends StatefulWidget {
  const OrderSummeryScreen({Key? key}) : super(key: key);

  @override
  _OrderSummeryScreenState createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  Data data = Data();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.separated(
            itemCount: 5,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemBuilder: (context, index) {
              return Slidable(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: const [
                    BoxShadow(
                        color: Color(
                          0xffA6A6A6,
                        ),
                        blurRadius: 5)
                  ]),
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
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  key: ValueKey(index),
                  extentRatio: 0.32,
                  dragDismissible: false,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: MColor.colorPrimary, boxShadow: const [
                        BoxShadow(
                            color: Color(
                              0xffA6A6A6,
                            ),
                            blurRadius: 5)
                      ]),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [Image.asset("assets/pdf.png")],
                      ),
                    ),
                    // SlidableAction(
                    //   padding: EdgeInsets.all(8),
                    //   // An action can be bigger than the others.
                    //   flex: 2,
                    //   onPressed: (e) {},
                    //   backgroundColor: const Color(0xFF7BC043),
                    //   foregroundColor: Colors.white,
                    //   icon: Icons.archive,
                    //   label: 'Archive',
                    // ),
                  ],
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
