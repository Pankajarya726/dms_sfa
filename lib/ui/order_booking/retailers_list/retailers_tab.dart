import 'dart:async';
import 'dart:collection';

import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailer_list_item.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

import '../../../main.dart';

class RetailerTab extends StatefulWidget {
  final int index;

  const RetailerTab({Key? key, required this.index}) : super(key: key);

  @override
  _RetailerTabState createState() => _RetailerTabState();
}

class _RetailerTabState extends State<RetailerTab> with AutomaticKeepAliveClientMixin<RetailerTab> {
  List<RetailersModal> retailers = [];
  List<BeatsModal> beatList = [];
  BeatsModal? selectedBeat;

  String tag = "All";
  StreamController<List<RetailersModal>> retailerStreamController = StreamController();

  @override
  void initState() {
    beatList.add(BeatsModal(id: "", name: "All"));
    selectedBeat = beatList.first;

    getAllBeats();
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Column(
      children: [
        BeatWidget(
            tags: beatList,
            onSelect: (BeatsModal tag) {
              if (selectedBeat != tag) {
                selectedBeat = tag;
                getRetailers();
              }
            }),
        Expanded(
          child: StreamBuilder<List<RetailersModal>>(
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
                    beatId: selectedBeat!.id,
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
    if (await Network.isConnected()) {
      GetAllBeatsResponse response = await repository.getAllBeats();
      if (response.success) {
        beatList.addAll(response.data!);
        getRetailers();
        setState(() {});
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  void getRetailers() async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["order_status"] = widget.index + 1;
      input["beat_id"] = selectedBeat!.id;
      GetRetailersResponse response = await repository.getRetailersOrderWise(input);
      if (response.success) {
        retailers = response.data!;
        retailerStreamController.add(retailers);
        debugPrint("response = ${response.message}");
      } else {
        retailerStreamController.addError(response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  @override
  bool get wantKeepAlive => retailers.isNotEmpty;
}

class BeatWidget extends StatefulWidget {
  final List<BeatsModal> tags;
  final Function(BeatsModal tag) onSelect;

  const BeatWidget({Key? key, required this.tags, required this.onSelect}) : super(key: key);

  @override
  _BeatWidgetState createState() => _BeatWidgetState();
}

class _BeatWidgetState extends State<BeatWidget> {
  BeatsModal tag = BeatsModal(name: "All", id: "");

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
          active: widget.tags[index].name == tag.name,
          customData: widget.tags[index],
          textActiveColor: Colors.black,
          textColor: const Color(0xff555555),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          border: Border.all(color: widget.tags[index].name == tag.name ? MColor.colorPrimary : const Color(0xffC5C5C5), width: 1.5),
          singleItem: true,
          activeColor: widget.tags[index].name == tag.name ? const Color(0xffFFC9CC) : const Color(0xffFAFAFA),
          color: widget.tags[index].name == tag.name ? const Color(0xffFFC9CC) : const Color(0xffFAFAFA),
          title: widget.tags[index].name,
        );
      },
    );
  }
}
