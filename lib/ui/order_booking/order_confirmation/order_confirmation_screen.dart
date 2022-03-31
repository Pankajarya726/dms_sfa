import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/order_conf_remark_bottom_sheet.dart';
import 'package:dms/ui/order_booking/order_confirmation/my_order_summary.dart';
import 'package:dms/ui/order_booking/order_confirmation/order_s.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'focus_sku_tab.dart';
import 'order_summery_tab.dart';

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
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: bottomSheetShape,
                  isScrollControlled: false,
                  builder: (context) => const OrderConfRemarkBottomSheet(),
                );
              },
              icon: Container(
                decoration: const BoxDecoration(
                    color: MColor.colorSecondary, shape: BoxShape.circle),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.ten_k,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: MColor.colorPrimary,
            indicatorWeight: 3,
            labelPadding: const EdgeInsets.symmetric(horizontal: 15),
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
            physics: const NeverScrollableScrollPhysics(),
            tabs: const [
              Tab(
                child: Text(
                  "Focus SKU",
                  style: TextStyle(color: MColor.textColor),
                ),
              ),
              Tab(
                child: Text(
                  "Summary",
                  style: TextStyle(color: MColor.textColor),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            FocusSkyTab(
              onConfirm: () {
                _tabController.animateTo(1);
              },
            ),
            const MyOrderSummary(),
          ],
        ),
      ),
    );
  }
}
