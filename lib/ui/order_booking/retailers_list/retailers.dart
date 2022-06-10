import 'dart:async';
import 'dart:collection';

import 'package:dms/main.dart';
import 'package:dms/ui/custom_widget/no_internet.dart';
import 'package:dms/ui/custom_widget/retailer_not_found.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailer_list_item.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RetailerList extends StatefulWidget {
  final int index;
  final String beatId;
  final String day;

  const RetailerList({Key? key, required this.index, required this.beatId, required this.day}) : super(key: key);

  @override
  _RetailerListState createState() => _RetailerListState();
}

class _RetailerListState extends State<RetailerList> {
  List<RetailersModal> retailers = [];
  StreamController<List<RetailersModal>> retailerStreamController = StreamController();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  int pageNo = 1;

  @override
  void initState() {
    debugPrint("day---->${widget.day}");
    getRetailers();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RetailerList oldWidget) {
    getRetailers();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RetailersModal>>(
      stream: retailerStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          if (snapshot.error.toString() == "loading") {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: NoInternetConnection(onRefresh: () {
                getRetailers();
              }),
            );
          }
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(
            child: RetailerNotFound(
              onRefresh: () {
                pageNo = 1;
                retailers.clear();
                retailerStreamController.addError("loading");
                getRetailers();
              },
            ),
          );
        }

        return SmartRefresher(
          primary: false,
          controller: refreshController,
          onRefresh: onRefresh,
          enablePullDown: true,
          enablePullUp: true,
          onLoading: () {
            getRetailers();
          },
          footer: CustomFooter(
            builder: (context, loadStatus) {
              if (loadStatus == LoadStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container();
            },
          ),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 15,
              );
            },
            itemBuilder: (context, index) {
              return RetailerListItems(
                index: widget.index,
                retailer: snapshot.data![index],
                // beatId: selectedBeat!.id,
                orderStatus: widget.index == 0
                    ? 1
                    : widget.index == 1
                        ? 2
                        : 3,
              );
            },
          ),
        );
      },
    );
  }

  void onRefresh() async {
    retailers.clear();
    pageNo = 1;
    getRetailers();
    retailerStreamController.addError("loading");
    refreshController.refreshCompleted();
  }

  void getRetailers() async {
    // retailers.clear();
    int page = pageNo;

    if (await Network.isConnected() && !EasyLoading.isShow) {
      // EasyLoading.show();

      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["order_status"] = widget.index;
      input["beat_id"] = widget.beatId;
      input["day"] = widget.day;
      // input["page_no"] = pageNo;
      // input["lat"] = latitude;
      // input["long"] = longitude;
      // input["sort_by"] = sortingType;
      // input["retailer_type"] = retailerType;

      input["page_no"] = pageNo;
      input["lat"] = "";
      input["long"] = "";
      input["sort_by"] = "";
      input["retailer_type"] = "";

      GetRetailersResponse response = await repository.getRetailersOrderWise(input);
      // EasyLoading.dismiss();
      refreshController.loadComplete();
      refreshController.refreshCompleted();
      if (response.success) {
        pageNo = pageNo + 1;
        retailers.addAll(response.data!);
        retailerStreamController.add(retailers);
      } else {
        debugPrint("pageNo-->$pageNo---$page");
        if (pageNo == 1) {
          retailerStreamController.add([]);
        }
        // retailerStreamController.add([]);
      }
    } else {
      retailerStreamController.addError(StringConst.internetCheck);
    }
  }
}
