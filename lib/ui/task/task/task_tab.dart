import 'dart:async';
import 'dart:collection';

import 'package:dms/listeners/select_beat_listener.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/ui/task/task/task_list_item.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';

class TaskTab extends StatefulWidget {
  final int index;
  final BeatsModal selectedBeat;
  final Function(SelectBeatListener listener) onInit;

  const TaskTab({
    Key? key,
    required this.index,
    required this.onInit,
    required this.selectedBeat,
  }) : super(key: key);

  @override
  _TaskTabState createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> implements SelectBeatListener {
  List<RetailersModal> retailers = [];
  List<BeatsModal> beatList = [];
  BeatsModal? selectedBeat;
  String tag = "All";
  StreamController<List<RetailersModal>> retailerStreamController = StreamController();
  String day = "";
  String retailerType = "";
  double latitude = 0.0;
  double longitude = 0.0;
  String sortingType = "";

  @override
  void initState() {
    debugPrint("initState--->${widget.selectedBeat.id}");
    widget.onInit(this);
    selectedBeat ??= widget.selectedBeat;
    day = DateFormat.EEEE().format(DateTime.now());
    getRetailers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                if (snapshot.error.toString() == "loading") {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                }
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
                  return TaskListItems(
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

  void getRetailers() async {
    retailerStreamController.addError("loading");
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      // input["order_status"] = widget.index;
      // input["beat_id"] = selectedBeat!.id;
      // input["day"] = day;
      // input["retailer_type"] = retailerType;

      input["order_status"] = widget.index;
      input["beat_id"] = "";
      input["day"] = "Saturday";
      input["retailer_type"] = "";
      GetRetailersResponse response = await repository.getRetailersOrderWise(input);
      if (response.success) {
        retailers = response.data!;
        debugPrint("response = ${response.message}");
        retailerStreamController.add(retailers);
      } else {
        retailerStreamController.addError(response.message);
      }
    } else {
      retailerStreamController.addError(StringConst.internetCheck);
    }
  }

  @override
  void onBeatSelect(BeatsModal beatsModal, String day, String type) {
    if (selectedBeat!.id != beatsModal.id) {
      retailerStreamController.add(retailers);
    }

    selectedBeat = beatsModal;
    if (day.isEmpty) {
      this.day = DateFormat.EEEE().format(DateTime.now());
    } else {
      this.day = day;
    }
    getRetailers();
  }

  @override
  void onSorting(String type) {}
}

class TaskBeatWidget extends StatefulWidget {
  final List<BeatsModal> tags;
  final Function(BeatsModal tag) onSelect;

  const TaskBeatWidget({
    Key? key,
    required this.tags,
    required this.onSelect,
  }) : super(key: key);

  @override
  _TaskBeatWidgetState createState() => _TaskBeatWidgetState();
}

class _TaskBeatWidgetState extends State<TaskBeatWidget> {
  BeatsModal tag = BeatsModal(name: "All", id: "");

  @override
  void initState() {
    widget.onSelect(tag);
    super.initState();
  }

  @override
  void didUpdateWidget(TaskBeatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.selectedBeat.isNotEmpty) {
    //   tag.name = widget.selectedBeat;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Tags(
      direction: Axis.horizontal,
      itemCount: widget.tags.length,
      horizontalScroll: true,
      itemBuilder: (index) {
        return Padding(
          padding: index == 0
              ? const EdgeInsets.only(left: 5)
              : widget.tags[index] == widget.tags.last
                  ? const EdgeInsets.only(right: 10)
                  : const EdgeInsets.all(0),
          child: ItemTags(
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
          ),
        );
      },
    );
  }
}
