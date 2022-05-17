import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/main.dart';
import 'package:dms/model/base_response.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/last_visit_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/no_order_reason_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/order_history_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/task_bottom_sheet.dart';
import 'package:dms/ui/custom_widget/no_internet.dart';
import 'package:dms/ui/custom_widget/retailer_not_found.dart';
import 'package:dms/ui/drawer_screen/drawer_screen.dart';
import 'package:dms/ui/order_booking/order_booking_list/order_booking_list_screen.dart';
import 'package:dms/ui/order_booking/retailer_detail/bloc/retailer_details_bloc.dart';
import 'package:dms/ui/order_booking/retailer_detail/bloc/retailer_details_events.dart';
import 'package:dms/ui/order_booking/retailer_detail/bloc/retailer_details_states.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/no_order_yet_response.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/task_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RetailerDetailScreen extends StatefulWidget {
  final RetailersModal retailer;
  final int orderStatus;

  const RetailerDetailScreen({
    Key? key,
    required this.retailer,
    required this.orderStatus,
  }) : super(key: key);

  @override
  _RetailerDetailScreenState createState() => _RetailerDetailScreenState();
}

class _RetailerDetailScreenState extends State<RetailerDetailScreen> {
  TextEditingController txtRemark = TextEditingController();
  RetailerDetailsModal? retailer;
  List<NoOrderYetModal> noOrderYet = [];
  List<Task> taskList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RetailerDetailsBloc retailerDetailsBloc = RetailerDetailsBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => retailerDetailsBloc,
      child: BlocListener<RetailerDetailsBloc, RetailerDetailStates>(
        listener: (context, state) {
          if (state is GetTaskState) {
            taskList = state.taskList;
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xffF7F7F7),
          appBar: _appBar(AppBar().preferredSize.height),
          body: BlocBuilder<RetailerDetailsBloc, RetailerDetailStates>(
            builder: (context, state) {
              if (state is RetailerDetailInitialState) {
                retailerDetailsBloc
                    .add(GetTaskEvent(uniqueCode: widget.retailer.uniqueCode));
                retailerDetailsBloc.add(GetRetailerDetailsEvent(
                    storeId: widget.retailer.customerId));
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
                // BlocProvider.of<RetailerDetailsBloc>(context)
                //     .add(GetTaskEvent(uniqueCode: widget.retailer.uniqueCode));
                retailerDetailsBloc.add(
                    NoOrderYetEvent(retailerId: widget.retailer.customerId));
              }
              if (state is RetailerDetailFailureState) {
                if (state.failureMessage == StringConst.internetCheck) {
                  return Center(
                    child: NoInternetConnection(onRefresh: () {
                      retailerDetailsBloc.add(
                          GetTaskEvent(uniqueCode: widget.retailer.uniqueCode));
                      retailerDetailsBloc.add(GetRetailerDetailsEvent(
                          storeId: widget.retailer.customerId));
                    }),
                  );
                } else {
                  Center(
                    child: RetailerNotFound(onRefresh: () {
                      retailerDetailsBloc.add(
                          GetTaskEvent(uniqueCode: widget.retailer.uniqueCode));
                      retailerDetailsBloc.add(GetRetailerDetailsEvent(
                          storeId: widget.retailer.customerId));
                    }),
                  );
                }
              }
              if (retailer == null) {
                return Container();
              }

              return SmartRefresher(
                primary: false,
                controller: refreshController,
                onRefresh: onRefresh,
                enablePullDown: true,
                child: CustomScrollView(
                  slivers: [
                    SliverGrid(
                      delegate: SliverChildListDelegate(
                        [
                          DetailGritItem(
                            value: retailer!.lastVisit != null
                                ? retailer!.lastVisit!.orderDate
                                : "No visit yet!",
                            image: "assets/store.png",
                            name: StringConst.lastVisit,
                            type: 1,
                            retailerDetails: retailer!,
                          ),
                          DetailGritItem(
                            value: retailer!.pendingTask.isNotEmpty
                                ? retailer!.pendingTask
                                : "0",
                            image: "assets/task.png",
                            name: StringConst.task,
                            type: 2,
                            retailerDetails: retailer!,
                            taskList: taskList,
                          ),
                          DetailGritItem(
                            value: retailer!.tcStatus,
                            image: "assets/phone.png",
                            name: StringConst.tcStatus,
                            type: 3,
                            retailerDetails: retailer!,
                          ),
                          DetailGritItem(
                            value: currencyFormat
                                .format(double.parse(retailer!.potential)),
                            image: "assets/experience.png",
                            name: StringConst.potential,
                            type: 4,
                            retailerDetails: retailer!,
                          ),
                        ],
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  StringConst.storeInfo,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => const OutletInformation()),
                                    // );
                                  },
                                  padding: EdgeInsets.zero,
                                  // splashRadius: 13,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                                          name: StringConst.ownerName,
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
                                          value: retailer!.orderBookingDay,
                                          image: "assets/telephone.png",
                                          name: StringConst.callingDay,
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
                                          name: StringConst.primaryNo,
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
                                          value:
                                              retailer!.secondaryMobile.isEmpty
                                                  ? "Not Given"
                                                  : retailer!.secondaryMobile,
                                          image: "assets/phone_call.png",
                                          name: StringConst.secondaryNo,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                              StringConst.address,
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
                              readOnly: true,
                              controller: txtRemark,
                              enableInteractiveSelection: false,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xff555555),
                              ),
                              decoration: const InputDecoration(
                                filled: true,
                                hintText: "Remark",
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
                              StringConst.orderHistory,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 10, top: 5),
                            child: Container(
                              padding: retailer!.orderHistory.isNotEmpty
                                  ? const EdgeInsets.fromLTRB(5, 0, 5, 0)
                                  : const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(237, 237, 237, 0.25),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: retailer!.orderHistory.isNotEmpty
                                  ? Column(
                                      children: List.generate(
                                        retailer!.orderHistory.length,
                                        (index) => Material(
                                          color: Colors.white,
                                          child: InkWell(
                                            customBorder:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            onTap: () {
                                              Utility.hideKeyboard();
                                              FocusScope.of(context).unfocus();
                                              showModalBottomSheet(
                                                context: context,
                                                shape: bottomSheetShape,
                                                isScrollControlled: true,
                                                builder: (context) =>
                                                    OrderHistoryBottomSheet(
                                                  product: retailer!
                                                      .orderHistory[index]
                                                      .products,
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 5),
                                              height: 50,
                                              decoration:
                                                  retailer!.orderHistory[
                                                              index] !=
                                                          retailer!
                                                              .orderHistory.last
                                                      ? const BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                                color: Color(
                                                                    0xffC5C5C5),
                                                                width: 0.5),
                                                          ),
                                                        )
                                                      : null,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: RichText(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                        text: "Date: ",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Color(0xff555555),
                                                          letterSpacing: 0.67,
                                                          fontSize: 15,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: retailer!
                                                                .orderHistory[
                                                                    index]
                                                                .orderDate,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color(
                                                                  0xff303030),
                                                              letterSpacing:
                                                                  0.67,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: RichText(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                        text: "Value: ₹",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Color(0xff555555),
                                                          letterSpacing: 0.67,
                                                          fontSize: 15,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: retailer!
                                                                .orderHistory[
                                                                    index]
                                                                .amount,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color(
                                                                  0xff303030),
                                                              letterSpacing:
                                                                  0.67,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const Text(StringConst.noOrdersTaken),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 15, right: 10, bottom: 0, top: 10),
                            child: Text(
                              StringConst.buNotOrdered,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          BlocBuilder<RetailerDetailsBloc,
                              RetailerDetailStates>(
                            builder: (context, state) {
                              if (state is NoOrderYetLodingState) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is NoOrderYetState) {
                                noOrderYet = state.noOrderYet;
                              }
                              if (state is NoOrderYetFailureState) {
                                return Center(
                                  child: Text(state.failureMessage),
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 10, bottom: 10, top: 5),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                      noOrderYet.length,
                                      (index) {
                                        return Padding(
                                          padding: index == 0 || index == 4
                                              ? const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                )
                                              : const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                          child: Container(
                                            height: 45,
                                            width: 100,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 1),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      237, 237, 237, 0.25),
                                                  blurRadius: 10,
                                                )
                                              ],
                                            ),
                                            child: CachedNetworkImage(
                                              height: 20,
                                              fit: BoxFit.cover,
                                              imageUrl: noOrderYet[index].image,
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return Image(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      "assets/placeholder.png"),
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                      "assets/placeholder.png"),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                widget.orderStatus == 1
                    ? MaterialButton(
                        onPressed: () {
                          Utility.hideKeyboard();
                          FocusScope.of(context).unfocus();
                          noOrder(context);
                        },
                        shape: const RoundedRectangleBorder(),
                        child: const Text(
                          StringConst.noOrderCaps,
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 20,
                              letterSpacing: 0.72),
                        ),
                        color: const Color(0xff3D8FFF),
                        height: 50,
                        elevation: 0,
                        minWidth: MediaQuery.of(context).size.width / 2,
                      )
                    : Container(),
                MaterialButton(
                  onPressed: () async {
                    Utility.hideKeyboard();
                    FocusScope.of(context).unfocus();
                    await databaseHelper.clearCart();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderBookingListScreen(
                          beatId: widget.retailer.beatId,
                          retailerId: widget.retailer.customerId,
                        ),
                      ),
                    );
                  },
                  shape: const RoundedRectangleBorder(),
                  child: const Text(
                    StringConst.orderCaps,
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 20,
                        letterSpacing: 0.72),
                  ),
                  color: MColor.colorSecondary,
                  height: 50,
                  elevation: 0,
                  minWidth: widget.orderStatus == 1
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ),
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
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DrawerScreen(),
                            ),
                            ModalRoute.withName("/"));
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
              left: 45.0,
              right: 45.0,
              child: AppBar(
                elevation: 5,
                toolbarHeight: 60,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.white,
                primary: false,
                automaticallyImplyLeading: false,
                titleSpacing: 8,
                title: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        imageUrl: widget.retailer.outletPicture,
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
                            widget.retailer.outlatName,
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
                            widget.retailer.beatName,
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
                          image: AssetImage(
                              widget.retailer.enrollmentTypeId == "1"
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

  void noOrder(BuildContext context) async {
    if (retailer!.pendingTask.isNotEmpty &&
        int.parse(retailer!.pendingTask) > 0) {
      bool? save = await Utility.showConfirmAlert(
          title: 'There are ${retailer!.pendingTask} pending Task',
          subTitle: "Do you want to resolve?",
          context: context,
          cancelText: "No",
          confirmText: "Yes");

      if (save != null && save) {
        var res = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            enableDrag: true,
            shape: bottomSheetShape,
            builder: (context) => TaskBottomSheet(
                  taskList: taskList,
                  retailerCode: widget.retailer.uniqueCode,
                ));

        if (res != null && res as int > 0) {
          saveNoOrder(context);
        }
      } else {
        saveNoOrder(context);
      }
    } else {
      saveNoOrder(context);
    }
  }

  void saveNoOrder(BuildContext context) async {
    var res = await showModalBottomSheet(
        isDismissible: false,
        context: context,
        shape: bottomSheetShape,
        isScrollControlled: true,
        builder: (context) => NoOrderReasonSheet(
              retailerId: retailer!.customerId,
            ));

    if (res != null && res) {
      // Map<String, dynamic> input = res as Map<String, dynamic>;
      // input["retailer_id"] = retailer!.customerId;
      // noOrderApi(input);
      Navigator.pop(context);
    }
  }

  void noOrderApi(Map<String, dynamic> input) async {
    if (await Network.isConnected()) {
      EasyLoading.show(status: "Loading...");
      BaseResponse response = await repository.saveNoOrder(input);
      EasyLoading.dismiss();
      if (response.success) {
        Utility.showToast(response.message);
        Navigator.pop(context);
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  void onRefresh() async {
    txtRemark.clear();
    retailerDetailsBloc
        .add(GetTaskEvent(uniqueCode: widget.retailer.uniqueCode));
    retailerDetailsBloc
        .add(GetRetailerDetailsEvent(storeId: widget.retailer.customerId));
    refreshController.refreshCompleted();
  }
}

class DetailGritItem extends StatefulWidget {
  final String image;
  final String name;
  final String value;
  final int type;
  final List<Task> taskList;
  final RetailerDetailsModal retailerDetails;

  const DetailGritItem({
    Key? key,
    required this.image,
    required this.name,
    required this.value,
    required this.type,
    required this.retailerDetails,
    this.taskList = const [],
  }) : super(key: key);

  @override
  _DetailGritItemState createState() => _DetailGritItemState();
}

class _DetailGritItemState extends State<DetailGritItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(237, 237, 237, 0.25),
            blurRadius: 10,
          )
        ],
      ),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: widget.type != 4
              ? () {
                  Utility.hideKeyboard();
                  FocusScope.of(context).unfocus();
                  if (widget.type == 1) {
                    widget.retailerDetails.lastVisit != null
                        ? showModalBottomSheet(
                            context: context,
                            shape: bottomSheetShape,
                            isScrollControlled: true,
                            builder: (context) => LastVisitBottomSheet(
                                  lastVisit: widget.retailerDetails.lastVisit,
                                ))
                        : null;
                  }
                  if (widget.type == 2) {
                    widget.retailerDetails.pendingTask.isNotEmpty
                        ? showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            enableDrag: true,
                            shape: bottomSheetShape,
                            builder: (context) => TaskBottomSheet(
                                  taskList: widget.taskList,
                                  retailerCode:
                                      widget.retailerDetails.uniqueCode,
                                ))
                        : Utility.showToast("No task available");
                  }
                  // tc status bottom sheet
                  // if (widget.type == 3) {
                  //   showModalBottomSheet(
                  //       context: context,
                  //       isScrollControlled: true,
                  //       shape: bottomSheetShape,
                  //       builder: (context) => const TeleCallerStatusSheet());
                  // }
                }
              : null,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
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
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Color(0xff303030),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.67,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.value,
                        style: const TextStyle(
                          color: Color(0xff555555),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
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
