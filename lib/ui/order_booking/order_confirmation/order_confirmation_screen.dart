import 'package:dms/listeners/reason_listener.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/order_conf_remark_bottom_sheet.dart';
import 'package:dms/ui/order_booking/order_confirmation/model/get_bu_response.dart';
import 'package:dms/ui/order_booking/order_confirmation/order_s.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

import 'focus_sku_tab.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String beatId;
  final String retailerId;

  const OrderConfirmationScreen({
    Key? key,
    required this.beatId,
    required this.retailerId,
  }) : super(key: key);

  @override
  _OrderConfirmationScreenState createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  ValueNotifier<int> valueNotifier = ValueNotifier(0);
  String reason = "";
  String remark = "";
  List<BUModal> buList = [];
  bool issueResolve = false;
  ReasonsListener? reasonsListener;

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
                              isScrollControlled: false,
                              builder: (context) => OrderConfRemarkBottomSheet(
                                reason: reason,
                                remark: remark,
                                buList: buList,
                                issueResolve: issueResolve,
                                onReasonSelected:
                                    (reason, remark, buList, issueResolve) {
                                  this.reason = reason;
                                  this.remark = remark;
                                  this.buList = buList;
                                  this.issueResolve = issueResolve;
                                  if (reasonsListener != null) {
                                    reasonsListener!.onReasonSelect(
                                        this.reason,
                                        this.remark,
                                        this.buList,
                                        this.issueResolve);
                                  }
                                },
                              ),
                            );
                          },
                          icon: Container(
                            decoration: const BoxDecoration(
                                color: MColor.colorSecondary,
                                shape: BoxShape.circle),
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.ten_k,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      : Container();
                })
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: const Color(0xffEDEDED),
              child: TabBar(
                controller: _tabController,
                indicatorColor: MColor.colorPrimary,
                indicatorWeight: 4,
                labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                physics: const NeverScrollableScrollPhysics(),
                onTap: (index) {
                  valueNotifier.value = index;
                },
                tabs: const [
                  Tab(
                    child: Text(
                      "Focus SKU",
                      style: TextStyle(
                          color: Color(0xff303030),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Summary",
                      style: TextStyle(
                          color: Color(0xff303030),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
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
              onConfirm: () {
                _tabController.animateTo(1);
                valueNotifier.value = 1;
              },
            ),
            OrderS(
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
