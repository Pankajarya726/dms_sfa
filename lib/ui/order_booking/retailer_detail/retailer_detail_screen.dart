import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/add_store/outlet_information/outlet_information.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/last_visit_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/no_order_reason_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/order_history_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/task_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/tele_caller_status_bottm_sheet.dart';
import 'package:dms/ui/drawer_menu/home_screen/home_screen.dart';
import 'package:dms/ui/order_booking/order_booking_list/order_booking_list_screen.dart';
import 'package:dms/ui/order_booking/retailer_detail/bloc/retailer_details_bloc.dart';
import 'package:dms/ui/order_booking/retailer_detail/bloc/retailer_details_events.dart';
import 'package:dms/ui/order_booking/retailer_detail/bloc/retailer_details_states.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RetailerDetailScreen extends StatefulWidget {
  final String storeId;
  const RetailerDetailScreen({Key? key, required this.storeId})
      : super(key: key);

  @override
  _RetailerDetailScreenState createState() => _RetailerDetailScreenState();
}

class _RetailerDetailScreenState extends State<RetailerDetailScreen> {
  TextEditingController txtRemark = TextEditingController();
  RetailerDetailsModal? retailer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RetailerDetailsBloc(),
      child: BlocBuilder<RetailerDetailsBloc, RetailerDetailStates>(
        builder: (context, state) {
          if (state is RetailerDetailInitialState) {
            BlocProvider.of<RetailerDetailsBloc>(context)
                .add(GetRetailerDetailsEvent(storeId: widget.storeId));
          }
          if (state is RetailerDetailLodingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetRetailerDetailState) {
            retailer = state.retailer;
            if (txtRemark.text.isEmpty) {
              if (txtRemark.text != retailer!.remark) {
                txtRemark.text = state.retailer.remark;
              }
            }
          }
          if (state is RetailerDetailFailureState) {
            return Center(
              child: Text(state.failureMessage),
            );
          }
          if (retailer == null) {
            return Container();
          }

          return Scaffold(
            appBar: _appBar(AppBar().preferredSize.height),
            backgroundColor: const Color(0xffF7F7F7),
            body: CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildListDelegate(
                    [
                      DetailGritItem(
                        value: retailer!.lastVisit!.isNotEmpty
                            ? retailer!.lastVisit!.first.orderDate
                            : "",
                        image: "assets/store.png",
                        name: "Last visit",
                        type: 1,
                        retailerDetails: retailer!,
                      ),
                      const DetailGritItem(
                        value: "3",
                        image: "assets/task.png",
                        name: "Task",
                        type: 2,
                      ),
                      const DetailGritItem(
                        value: "No Order",
                        image: "assets/phone.png",
                        name: "TC Status",
                        type: 3,
                      ),
                      DetailGritItem(
                        value: "Potential",
                        image: "assets/experience.png",
                        name: retailer!.potential,
                        type: 4,
                      ),
                    ],
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.6,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 10, bottom: 0, top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Store Info",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OutletInformation()),
                                );
                              },
                              padding: EdgeInsets.zero,
                              splashRadius: 13,
                              icon: Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                  color: MColor.colorSecondary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(237, 237, 237, 0.25),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: RetailerDetailItem(
                                      value: retailer!.customerName,
                                      image: "assets/user.png",
                                      name: "Owner Name",
                                      type: 1,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 30,
                                    color: const Color(0xffC5C5C5),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Expanded(
                                    child: RetailerDetailItem(
                                      value: "Friday",
                                      image: "assets/telephone.png",
                                      name: "Calling Day",
                                      type: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: RetailerDetailItem(
                                      value: retailer!.primaryMobile,
                                      image: "assets/phone_call.png",
                                      name: "Primary No.",
                                      type: 1,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 30,
                                    color: const Color(0xffC5C5C5),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: RetailerDetailItem(
                                      value: retailer!.secondaryMobile,
                                      image: "assets/phone_call.png",
                                      name: "Secondary No.",
                                      type: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Image(
                                      image: AssetImage("assets/map.png"),
                                      width: 30,
                                      height: 30,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Address",
                                          style: TextStyle(
                                            color: Color(0xff303030),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: Text(
                                            retailer!.primaryAddress,
                                            overflow: TextOverflow.clip,
                                            style: const TextStyle(
                                              color: Color(0xff555555),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 10, bottom: 0, top: 10),
                        child: Text(
                          StringConst.remark,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 10, bottom: 0, top: 5),
                        child: TextFormField(
                          maxLines: 5,
                          minLines: 3,
                          enabled: false,
                          controller: txtRemark,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff555555),
                          ),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 10, bottom: 0, top: 10),
                        child: Text(
                          "Order History",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 10, bottom: 0, top: 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(237, 237, 237, 0.25),
                                  blurRadius: 10,
                                )
                              ]),
                          child: retailer!.orderHistory!.isNotEmpty
                              ? Column(
                                  children: List.generate(
                                    retailer!.orderHistory!.length,
                                    (index) => Material(
                                      child: InkWell(
                                        onTap: () {
                                          Utility.hideKeyboard();
                                          FocusScope.of(context).unfocus();
                                          showModalBottomSheet(
                                            context: context,
                                            shape: bottomSheetShape,
                                            builder: (context) =>
                                                OrderHistoryBottomSheet(
                                              product: retailer!
                                                  .orderHistory![index]
                                                  .products!,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          height: 50,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xffC5C5C5),
                                                  width: 0.5),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Date: ${retailer!.orderHistory![index].orderDate}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xff555555),
                                                  letterSpacing: 0.67,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                "Value: ₹${retailer!.orderHistory![index].amount}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xff555555),
                                                  letterSpacing: 0.67,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const Text("Orders not found"),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 10, bottom: 0, top: 10),
                        child: Text(
                          "No Order yet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 10, bottom: 10, top: 5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              5,
                              (index) {
                                return Padding(
                                  padding: index == 0 || index == 4
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 0)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 10),
                                  child: Container(
                                    height: 45,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              237, 237, 237, 0.25),
                                          blurRadius: 10,
                                        )
                                      ],
                                    ),
                                    child: const Image(
                                      image:
                                          AssetImage("assets/brand_image.png"),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            bottomNavigationBar: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      Utility.hideKeyboard();
                      FocusScope.of(context).unfocus();
                      showModalBottomSheet(
                          context: context,
                          shape: bottomSheetShape,
                          isScrollControlled: true,
                          builder: (context) => const NoOrderReasonSheet());
                    },
                    shape: const RoundedRectangleBorder(),
                    child: const Text(
                      "NO ORDER",
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 20,
                          letterSpacing: 0.72),
                    ),
                    color: const Color(0xff3D8FFF),
                    height: 50,
                    elevation: 0,
                    minWidth: MediaQuery.of(context).size.width / 2,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Utility.hideKeyboard();
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderBookingListScreen(
                                    beatId: retailer!.beatId,
                                    retailerId: retailer!.customerId,
                                  )));
                    },
                    shape: const RoundedRectangleBorder(),
                    child: const Text(
                      "ORDER",
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 20,
                          letterSpacing: 0.72),
                    ),
                    color: MColor.colorSecondary,
                    height: 50,
                    elevation: 0,
                    minWidth: MediaQuery.of(context).size.width / 2,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _appBar(height) => PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, height + 60),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 50,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              onInit: (value) {},
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.home_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                color: MColor.colorPrimary,
                height: height + 20,
                width: MediaQuery.of(context).size.width,
              ),
            ),

            Container(), // Required some widget in between to float AppBar

            Positioned(
              // To take AppBar Size only
              top: 60.0,
              left: 50.0,
              right: 50.0,
              child: AppBar(
                elevation: 5,
                toolbarHeight: 60,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.white,
                primary: false,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        imageUrl: retailer!.outletPicture,
                        imageBuilder: (context, imageProvider) {
                          return Image(
                            image: imageProvider,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          );
                        },
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/placeholder.png"),
                        placeholder: (context, url) =>
                            Image.asset("assets/placeholder.png"),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            retailer!.outlatName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            retailer!.beatName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Image(
                          width: 25,
                          height: 25,
                          image: AssetImage(retailer!.enrollmentTypeId == "1"
                              ? "assets/retailer.png"
                              : "assets/tele.png"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
}

class DetailGritItem extends StatefulWidget {
  final String image;
  final String name;
  final String value;
  final int type;
  final RetailerDetailsModal? retailerDetails;

  const DetailGritItem({
    Key? key,
    required this.image,
    required this.name,
    required this.value,
    required this.type,
    this.retailerDetails,
  }) : super(key: key);

  @override
  _DetailGritItemState createState() => _DetailGritItemState();
}

class _DetailGritItemState extends State<DetailGritItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Utility.hideKeyboard();
        FocusScope.of(context).unfocus();
        if (widget.type == 1) {
          showModalBottomSheet(
              context: context,
              shape: bottomSheetShape,
              builder: (context) => LastVisitBottomSheet(
                    retailerDetails: widget.retailerDetails,
                  ));
        }
        if (widget.type == 2) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: bottomSheetShape,
              builder: (context) => const TaskBottomSheet());
        }
        if (widget.type == 3) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: bottomSheetShape,
              builder: (context) => const TeleCallerStatusSheet());
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(237, 237, 237, 0.25),
                blurRadius: 10,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage(
                widget.image,
              ),
              width: 35,
              height: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                      color: Color(0xff303030),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.value,
                  style: const TextStyle(
                      color: Color(0xff555555),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RetailerDetailItem extends StatefulWidget {
  final String image;
  final String name;
  final String value;
  final int type;

  const RetailerDetailItem(
      {Key? key,
      required this.image,
      required this.name,
      required this.value,
      required this.type})
      : super(key: key);

  @override
  _RetailerDetailItemState createState() => _RetailerDetailItemState();
}

class _RetailerDetailItemState extends State<RetailerDetailItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: AssetImage(
              widget.image,
            ),
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                    color: Color(0xff303030),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.29,
                child: Text(
                  widget.value,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                      color: Color(0xff555555),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
