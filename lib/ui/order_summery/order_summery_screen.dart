import 'dart:async';
import 'dart:io';

import 'package:dms/main.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/filter_order_summery.dart';
import 'package:dms/ui/bottom_sheet_widget/selection_bottom_sheet.dart';
import 'package:dms/ui/order_summery/bloc/order_summery_bloc.dart';
import 'package:dms/ui/order_summery/bloc/order_summery_event.dart';
import 'package:dms/ui/order_summery/bloc/order_summery_state.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import 'model/get_order_summery_response.dart';

class OrderSummeryScreen extends StatefulWidget {
  const OrderSummeryScreen({Key? key}) : super(key: key);

  @override
  _OrderSummeryScreenState createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  DateTime fromDate = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  DateTime toDate = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  Selection? locationType;
  String locationId = "";
  String customerId = "";
  Selection? customerType;
  Selection? customer;
  Selection? location;

  List<OrderSummery> summeryList = [];
  StreamController<List<OrderSummery>> summeryStream = StreamController();
  OrderSummeryBloc orderSummeryBloc = OrderSummeryBloc();
  final subject = BehaviorSubject<String>();

  @override
  void initState() {
    getOrderSummery();

    subject.stream.debounce((event) => TimerStream(event, const Duration(milliseconds: 200))).listen((query) {
      debugPrint("query--->$query");
      List<OrderSummery> searchList = [];
      searchList = summeryList.where((element) => element.customerName.toLowerCase().contains(query.toLowerCase())).toList();
      summeryStream.add(searchList);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderSummeryBloc>(
      create: (context) => orderSummeryBloc,
      child: Scaffold(
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
                            locationType: locationType ?? Selection(name: "", id: ""),
                            customer: customer,
                            customerType: customerType,
                            onSelect: (DateTime fromDate, DateTime toDate, Selection? locationType, Selection? location,
                                Selection? customerType, Selection? customer) {
                              this.customer = customer ?? Selection(name: "", id: "");
                              this.customerType = customerType ?? Selection(name: "", id: "");
                              this.location = location ?? Selection(name: "", id: "");
                              this.locationType = locationType ?? Selection(name: "", id: "");
                              this.fromDate = DateFormat("yyyy-MM-dd").parse(fromDate.toString());
                              this.toDate = DateFormat("yyyy-MM-dd").parse(toDate.toString());
                              orderSummeryBloc.add(ApplyFilterEvent());
                              summeryStream.addError("loading");
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
                      readOnly: false,
                      onChanged: (text) {
                        if (text.trim().isEmpty) {
                          summeryStream.add(summeryList);
                        } else {
                          List<OrderSummery> searchList = [];
                          searchList =
                              summeryList.where((element) => element.customerName.toLowerCase().contains(text.toLowerCase())).toList();
                          summeryStream.add(searchList);
                        }
                      },
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
                        child: BlocBuilder<OrderSummeryBloc, OrderSummeryState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xffC5C5C5), width: 1)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(fromDate) == DateFormat('dd/MM/yyyy').format(toDate)
                                            ? " ${DateFormat('dd/MM/yyyy').format(fromDate)} "
                                            : " ${DateFormat('dd/MM/yyyy').format(fromDate)} to ${DateFormat('dd/MM/yyyy').format(toDate)} ",
                                        style: GoogleFonts.roboto(
                                            color: const Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w500),
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
                                locationType != null && locationType!.id.isNotEmpty
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        margin: const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: const Color(0xffC5C5C5), width: 1)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              " ${locationType!.name} : ${location != null ? location!.name : ""} ",
                                              style: GoogleFonts.roboto(
                                                  color: const Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                customerType != null && customerType!.id.isNotEmpty
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        margin: const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: const Color(0xffC5C5C5), width: 1)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              " Customer Type : ${customerType!.name} ",
                                              style: GoogleFonts.roboto(
                                                  color: const Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                customer != null && customer!.id.isNotEmpty
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        margin: const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: const Color(0xffC5C5C5), width: 1)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              " Customer : ${customer!.name} ",
                                              style: GoogleFonts.roboto(
                                                  color: const Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            );
                          },
                        ),
                      ))
                ],
              ),
            ),
          ),
          body: StreamBuilder<List<OrderSummery>>(
            stream: summeryStream.stream,
            builder: (context, snapshot) {
              debugPrint("connectionState-->${snapshot.connectionState}");

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

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
                                        NumberFormat("###.0#").format(double.parse(data.totalAmount)),
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
                                              text: " TC - ",
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
                                        //   " TC - " + data.tc,
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
                                              text: " PC - ",
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
                                              text: " Avg - ",
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
                                        " " + data.districtName,
                                        style: GoogleFonts.roboto(
                                            color: const Color(0xff777777), fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Image.asset("assets/tehsil.png", width: 15, height: 15, color: const Color(0xff777777)),
                                    Text(
                                      " " + data.cityName,
                                      style: GoogleFonts.roboto(
                                          color: const Color(0xff777777), fontSize: 14, fontWeight: FontWeight.w500),
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
                                  if (data.pdfLink.trim().isEmpty) {
                                    Utility.showToast("File not exists");
                                  } else {
                                    download(data.pdfLink.trim());
                                  }
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

              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Record not available"),
                );
              }
              if (snapshot.hasError && snapshot.error.toString() == "loading") {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container();
            },
          )),
    );
  }

  void download(String url) async {
    if (await Network.isConnected()) {
      if (await _checkPermission()) {
        final d = Directory('/storage/emulated/0/Download/');
        String localPath = await Utility.findLocalPath() + Platform.pathSeparator + 'DMS-SFA';
        debugPrint("dddd->$d");
        // String localPath = d.path;

        var savedDir = Directory(localPath);
        bool hasExisted = await savedDir.exists();
        if (!hasExisted) {
          savedDir.create();
        }

        String name = url.split("/").last;

        debugPrint("name--$name");

        String savePath = localPath + "/" + name;
        debugPrint("savePath--$savePath");
        EasyLoading.show(status: "Downloading file...");

        await FileDownloader.downloadFile(
            url: url,
            name: name,
            onProgress: (String? fileName, double progress) {
              debugPrint('FILE fileName HAS PROGRESS $fileName $progress');
            },
            onDownloadCompleted: (String path) {
              Utility.dismissLoading();
              debugPrint('FILE DOWNLOADED TO PATH: $path');

              OpenFile.open(path);
            },
            onDownloadError: (String error) {
              Utility.dismissLoading();
              debugPrint('DOWNLOAD ERROR: $error');
            });
        Utility.dismissLoading();
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  void getOrderSummery() async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = {};
      input["from_date"] = DateFormat("yyyy-MM-dd").format(fromDate);
      input["to_date"] = DateFormat("yyyy-MM-dd").format(toDate);
      input["location_type"] = locationType != null ? locationType!.id.toLowerCase() : "";
      input["location_id"] = location != null ? location!.id : "";
      input["customer_id"] = customer != null ? customer!.id : "";

      GetOrderSummeryResponse response = await repository.getOrderSummery(input);
      if (response.success) {
        summeryList = response.data;
        summeryList.sort((a, b) => a.date.compareTo(b.date));
        summeryStream.add(summeryList);
      } else {
        summeryStream.add([]);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  Future<bool> _checkPermission() async {
    PermissionStatus statuss = await Permission.storage.status;
    if (statuss == PermissionStatus.denied) {
      PermissionStatus status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
