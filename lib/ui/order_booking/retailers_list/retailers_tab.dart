import 'dart:async';

import 'package:dms/model/retaileres_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailer_list_item.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

import '../../../main.dart';

class RetailerTab extends StatefulWidget {
  final int index;

  const RetailerTab({Key? key, required this.index}) : super(key: key);

  @override
  _RetailerTabState createState() => _RetailerTabState();
}

class _RetailerTabState extends State<RetailerTab>
    with AutomaticKeepAliveClientMixin<RetailerTab> {
  List<Retailers> retailers = [];
  List<String> tags = ["All", "Vijay Nagar", "Palasia", "Rajwada"];
  String tag = "All";
  StreamController<List<Retailers>> retailerStreamController =
      StreamController();

  @override
  void initState() {
    debugPrint("retailerTab--->");
    getRetailers();
    getAllBeats();
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Column(
      children: [
        BeatWidget(
            tags: tags,
            onSelect: (String tag) {
              if (tag == "All") {
                retailerStreamController.add(retailers);
              } else {
                List<Retailers> filterList = retailers
                    .where((element) => element.primaryAddress == tag)
                    .toList();
                retailerStreamController.add(filterList);
              }
            }),
        Expanded(
          child: StreamBuilder<List<Retailers>>(
            stream: retailerStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Retailers not found"),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(15),
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
                    beatId: "15",
                    orderStatus: widget.index == 0
                        ? 1
                        : widget.index == 1
                            ? 2
                            : 3,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void getAllBeats() async {
    GetAllBeatsResponse response = await repository.getAllBeats();
    if (response.success) {
      debugPrint("response = ${response.message}");
    } else {
      debugPrint("response = ${response.message}");
    }
  }

  void getRetailers() async {
    retailers.add(Retailers(
        id: 1,
        uniqueCode: "478956",
        outletName: "AK Store",
        primaryAddress: "1502, Pennsylvania Avenue",
        customerName: "Vijay Nagar",
        userId: 10,
        outletPicture:
            "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
        primaryMobile: '',
        lng: '',
        districtId: 1,
        enrollmentTypeId: 0,
        secondaryMobile: '',
        lat: '',
        beatId: 0,
        beatName: "vijaynagar",
        connectionStatus: 0));
    // retailers.add(Retailers(
    //     id: "1",
    //     code: "651023",
    //     storeName: "Naveen Store",
    //     address: "1994, Oldsmobile Bravado",
    //     locationName: "Palasia",
    //     locationId: "10",
    //     outletPicture:
    //         "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
    //     priority: "P1"));
    // retailers.add(Retailers(
    //     id: "1",
    //     code: "109845",
    //     storeName: "Muffins Store",
    //     address: "630, Cambridge Court",
    //     locationName: "Vijay Nagar",
    //     locationId: "10",
    //     image:
    //         "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
    //     priority: "P0"));
    // retailers.add(Retailer(
    //     id: "1",
    //     code: "651023",
    //     storeName: "Namkeen Store",
    //     address: "1994, Oldsmobile Bravada",
    //     locationName: "Palasia",
    //     locationId: "10",
    //     image:
    //         "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
    //     priority: "P1"));
    // retailers.add(Retailer(
    //     id: "1",
    //     code: "109845",
    //     storeName: "Muffins Store",
    //     address: "630, Cambridge Court",
    //     locationName: "Vijay Nagar",
    //     locationId: "10",
    //     image:
    //         "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
    //     priority: "P0"));
    // retailers.add(Retailer(
    //     id: "1",
    //     code: "109845",
    //     storeName: "Muffins Store",
    //     address: "630, Cambridge Court",
    //     locationName: "Rajwada",
    //     locationId: "10",
    //     image:
    //         "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
    //     priority: "P0"));
    retailerStreamController.add(retailers);
  }

  @override
  bool get wantKeepAlive => retailers.isNotEmpty;
}

class BeatWidget extends StatefulWidget {
  final List<String> tags;
  final Function(String tag) onSelect;

  const BeatWidget({Key? key, required this.tags, required this.onSelect})
      : super(key: key);

  @override
  _BeatWidgetState createState() => _BeatWidgetState();
}

class _BeatWidgetState extends State<BeatWidget> {
  String tag = "All";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Tags(
      direction: Axis.horizontal,
      itemCount: widget.tags.length,
      horizontalScroll: true,
      itemBuilder: (index) {
        return ItemTags(
          index: index,
          onPressed: (item) {
            tag = item.customData;
            widget.onSelect(item.customData);
            setState(() {});
          },
          active: widget.tags[index] == tag,
          customData: widget.tags[index],
          textActiveColor: Colors.black,
          textColor: const Color(0xff555555),
          elevation: 0,
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          border: Border.all(
              color: widget.tags[index] == tag
                  ? MColor.colorPrimary
                  : const Color(0xffC5C5C5),
              width: 1.5),
          singleItem: true,
          activeColor: widget.tags[index] == tag
              ? const Color(0xffFFC9CC)
              : const Color(0xffFAFAFA),
          color: widget.tags[index] == tag
              ? const Color(0xffFFC9CC)
              : const Color(0xffFAFAFA),
          title: widget.tags[index],
        );
      },
    );
  }
}
