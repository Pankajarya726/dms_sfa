import 'dart:async';
import 'dart:ui';

import 'package:dms/main.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/filter_order_summery.dart';
import 'package:dms/ui/order_summery/model/get_customer_response.dart';
import 'package:dms/ui/order_summery/model/get_customer_type_response.dart';
import 'package:dms/ui/order_summery/model/get_location_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/get_order_summery_response.dart';

class OrderSummeryScreen extends StatefulWidget {
  const OrderSummeryScreen({Key? key}) : super(key: key);

  @override
  _OrderSummeryScreenState createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  DateTime fromDate = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  DateTime toDate = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  String locationType = "";
  String locationId = "";
  String customerId = "";
  CustomerType? customerType;
  Customer? customer;
  LocationModel? location;

  List<OrderSummery> summeryList = [];
  StreamController<List<OrderSummery>> summeryStream = StreamController();

  @override
  void initState() {
    getOrderSummery();
    super.initState();
  }

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
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: bottomSheetShape,
                    builder: (context) => FilterOrderSummerySheet(
                          fromDate: fromDate,
                          toDate: toDate,
                          location: location,
                          locationType: locationType,
                          customer: customer,
                          customerType: customerType,
                          onSelect: (DateTime fromDate, DateTime toDate, String? locaitonType, LocationModel? location,
                              CustomerType? customerType, Customer? customer) {
                            this.customer = customer;
                            this.customerType = customerType;
                            this.location = location;
                            locationType = locaitonType ?? "";
                            this.fromDate = DateFormat("yyyy-MM-dd").parse(fromDate.toString());
                            this.toDate = DateFormat("yyyy-MM-dd").parse(toDate.toString());

                            getOrderSummery();
                          },
                        ));
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xffC5C5C5), width: 1)),
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
                          locationType.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xffC5C5C5), width: 1)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "\t$locationType :\t${location != null ? location!.name : ""}\t",
                                        style: GoogleFonts.roboto(
                                            color: const Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          customerType != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xffC5C5C5), width: 1)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "\tCustomer Type :\t${customerType!.name}\t",
                                        style: GoogleFonts.roboto(
                                            color: const Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          customer != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xffC5C5C5), width: 1)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "\tCustomer :\t${customer!.customerName}\t",
                                        style: GoogleFonts.roboto(
                                            color: const Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
        body: StreamBuilder<List<OrderSummery>>(
          stream: summeryStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.separated(
                  itemCount: snapshot.data!.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                  itemBuilder: (context, index) {
                    OrderSummery data = snapshot.data![index];

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
                                      data.totalAmount,
                                      style: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Image.asset("assets/date.png", width: 15, height: 15, color: const Color(0xff777777)),
                                  Text(
                                    DateFormat("dd MMM yyyy").format(data.date),
                                    style: const TextStyle(color: Color(0xff777777), fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/tc.png",
                                        width: 27,
                                        height: 27,
                                      ),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: "\tTC\t-\t",
                                            style: GoogleFonts.roboto(
                                                color: const Color(0xff777777), fontSize: 15, fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(
                                            text: data.tc,
                                            style: GoogleFonts.roboto(
                                                color: const Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w500),
                                          )
                                        ]),
                                      ),
                                      // Text(
                                      //   "\tTC\t-\t" + data.tc,
                                      //   style: GoogleFonts.roboto(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                                      // ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/pc.png",
                                        width: 27,
                                        height: 27,
                                      ),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: "\tPC\t-\t",
                                            style: GoogleFonts.roboto(
                                                color: const Color(0xff777777), fontSize: 15, fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(
                                            text: data.pc,
                                            style: GoogleFonts.roboto(
                                                color: const Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w500),
                                          )
                                        ]),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/avg.png",
                                        width: 27,
                                        height: 27,
                                      ),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: "\tAvg\t-\t",
                                            style: GoogleFonts.roboto(
                                                color: const Color(0xff777777), fontSize: 15, fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(
                                            text: NumberFormat("###.0#").format(double.parse(data.avg)),
                                            style: GoogleFonts.roboto(
                                                color: const Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w500),
                                          )
                                        ]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                data.customerName,
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
                                    " " + data.beatName,
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
                                      "\t" + data.districtName,
                                      style: GoogleFonts.roboto(
                                          color: const Color(0xff777777), fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Image.asset("assets/tehsil.png", width: 15, height: 15, color: const Color(0xff777777)),
                                  Text(
                                    "\t" + data.cityName,
                                    style:
                                        GoogleFonts.roboto(color: const Color(0xff777777), fontSize: 14, fontWeight: FontWeight.w500),
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
                                download(data.pdfLink);
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
                  });
            }
            return Container();
          },
        ));
  }

  void download(String url) async {
    if (await Network.isConnected()) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Utility.showToast("Unable to get route...");
      }

      // String url = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
      //
      // String localPath = await Utility.findLocalPath() + Platform.pathSeparator + 'DMS-SFA';
      //
      // var savedDir = Directory(localPath);
      // bool hasExisted = await savedDir.exists();
      // if (!hasExisted) {
      //   savedDir.create();
      // }
      //
      // String name = url.split("/").last;
      //
      // debugPrint("name--$name");
      //
      // String savePath = localPath + "/" + name;
      // debugPrint("savePath--$savePath");
      //
      //
      // PermissionStatus status = await Permission.storage.request();
      //
      // debugPrint("Status-->$status");
      //
      // if (status == PermissionStatus.granted) {
      //   try {
      //     EasyLoading.show(status: "downloading file..");
      //
      //     Response response = await dio.get(
      //       url,
      //       onReceiveProgress: (received, total) async {
      //         if (total != -1) {
      //           // await EasyLoading.showProgress((received / total * 100));
      //           debugPrint((received / total * 100).toStringAsFixed(0) + "%");
      //         }
      //       },
      //       options: Options(
      //           responseType: ResponseType.bytes,
      //           followRedirects: true,
      //           validateStatus: (status) {
      //             return status! < 500;
      //           }),
      //     );
      //     debugPrint("resume response" + response.toString());
      //     debugPrint(response.headers.toString());
      //     File file = File(savePath);
      //     var raf = file.openSync(mode: FileMode.write);
      //     raf.writeFromSync(response.data);
      //     await raf.close();
      //     EasyLoading.dismiss();
      //
      //     // view.onDownloadResume(savePath);
      //   } catch (e) {
      //     debugPrint("e --> " + e.toString());
      //   }
      // }
    } else {}
  }

  void getOrderSummery() async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = {};
      input["from_date"] = DateFormat("yyyy-MM-dd").format(fromDate);
      input["to_date"] = DateFormat("yyyy-MM-dd").format(toDate);
      input["location_type"] = locationType;
      input["location_id"] = location != null ? location!.id : "";
      input["customer_id"] = customer != null ? customer!.id : "";

      GetOrderSummeryResponse response = await repository.getOrderSummery(input);
      if (response.success) {
        summeryList = response.data;
        summeryList.sort((a, b) => a.date.compareTo(b.date));
        summeryStream.add(summeryList);
      } else {}
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
