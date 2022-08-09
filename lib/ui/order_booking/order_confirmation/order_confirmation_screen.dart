import 'package:dms/listeners/reason_listener.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/order_conf_remark_bottom_sheet.dart';
import 'package:dms/ui/order_booking/order_confirmation/model/get_bu_response.dart';
import 'package:dms/ui/order_booking/order_confirmation/model/get_reason_response.dart';
import 'package:dms/ui/order_booking/order_confirmation/order_summery.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

import 'focus_sku_tab.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String beatId;
  final String retailerId;
  final String orderId;
  final String outletName;
  final String outletCode;

  const OrderConfirmationScreen(
      {Key? key,
      required this.beatId,
      required this.retailerId,
      required this.outletName,
      required this.outletCode,
      required this.orderId})
      : super(key: key);

  @override
  _OrderConfirmationScreenState createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  ValueNotifier<int> valueNotifier = ValueNotifier(0);

  ReasonsModal reason = ReasonsModal(tagName: "", id: "", taskType: "");
  String remark = "";
  List<BUModal> buList = [];
  bool issueResolve = false;

  ReasonsListener? reasonsListener;
  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _globalKey1 = GlobalKey();
  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          elevation: 1,
          title: const Text("Order Confirmation"),
          actions: [
            ValueListenableBuilder(
                valueListenable: valueNotifier,
                builder: (context, value, child) {
                  return value == 1
                      ? IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: bottomSheetShape,
                              isScrollControlled: true,
                              builder: (context) {
                                return OrderConfRemarkBottomSheet(
                                  retailerId: widget.retailerId,
                                  reason: reason,
                                  remark: remark,
                                  buList: buList,
                                  issueResolve: issueResolve,
                                  onReasonSelected: (reason, remark, buList, issueResolve) {
                                    this.reason = reason;
                                    this.remark = remark;
                                    this.buList = buList;
                                    this.issueResolve = issueResolve;
                                    if (reasonsListener != null) {
                                      reasonsListener!.onReasonSelect(this.reason, this.remark, this.buList, this.issueResolve);
                                    }
                                  },
                                );
                              },
                            );
                          },
                          icon: Container(
                            decoration: const BoxDecoration(color: MColor.colorSecondary, shape: BoxShape.circle),
                            padding: const EdgeInsets.all(6),
                            alignment: Alignment.center,
                            child: const Image(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/message_icon.png"),
                            ),
                          ),
                        )
                      : Container();
                })
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              key: _globalKey1,
              color: const Color(0xffEDEDED),
              child: TabBar(
                controller: _tabController,
                indicatorColor: MColor.colorPrimary,
                indicatorWeight: 4,
                labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                physics: const NeverScrollableScrollPhysics(),
                onTap: (index) {
                  debugPrint(_globalKey1.currentContext!.size!.height.toString());
                  debugPrint(_globalKey.currentContext!.size!.height.toString());
                  valueNotifier.value = index;
                },
                tabs: const [
                  Tab(
                    child: Text(
                      "Focus SKU",
                      style: TextStyle(color: Color(0xff303030), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Summary",
                      style: TextStyle(color: Color(0xff303030), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            FocusSkyTab(
              beatId: widget.beatId,
              retailerId: widget.retailerId,
              onConfirm: () {
                _tabController.animateTo(1);
                valueNotifier.value = 1;
              },
            ),
            OrderSummery(
              beatId: widget.beatId,
              retailerId: widget.retailerId,
              orderId: widget.orderId,
              outletName: widget.outletName,
              outletCode: widget.outletCode,
              onInit: (listener) {
                reasonsListener = listener;
              },
            ),
          ],
        ),
      ),
    );
  }
}
