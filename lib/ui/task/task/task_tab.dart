import 'dart:async';
import 'dart:collection';
import 'package:dms/listeners/select_beat_listener.dart';
import 'package:dms/ui/custom_widget/no_internet.dart';
import 'package:dms/ui/custom_widget/no_task_found.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/task/task/model/get_retailers_task_response.dart';
import 'package:dms/ui/task/task/task_list_item.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  List<RetailersTaskModal> retailers = [];
  List<BeatsModal> beatList = [];
  BeatsModal? selectedBeat;
  String tag = StringConst.all;
  StreamController<List<RetailersTaskModal>> retailerStreamController =
      StreamController();
  String day = "";
  DateTime? currentDate;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    debugPrint("initState--->${widget.selectedBeat.id}");
    widget.onInit(this);
    selectedBeat ??= widget.selectedBeat;
    getTaskRetailers();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TaskTab oldWidget) {
    selectedBeat = widget.selectedBeat;
    getTaskRetailers();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<RetailersTaskModal>>(
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
                    child: NoInternetConnection(
                      onRefresh: () {
                        getTaskRetailers();
                      },
                    ),
                  );
                }
              }

              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(
                  child: TaskNotFound(
                    onRefresh: () {
                      getTaskRetailers();
                    },
                  ),
                );
              }

              return SmartRefresher(
                primary: false,
                controller: refreshController,
                onRefresh: onRefresh,
                enablePullDown: true,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 15,
                    );
                  },
                  itemBuilder: (context, index) {
                    // calculate months from enrolled date to current date
                    if (snapshot.data![index].enrollmentDate.isNotEmpty) {
                      int monthCounts = 0;
                      DateTime enrolledDate =
                          DateTime.parse(snapshot.data![index].enrollmentDate);
                      if (enrolledDate.year == currentDate!.year) {
                        monthCounts = currentDate!.month - enrolledDate.month;
                        if (monthCounts < 2) {
                          snapshot.data![index].totalMonths =
                              monthCounts.toString() + " month ago";
                        } else {
                          snapshot.data![index].totalMonths =
                              monthCounts.toString() + " months ago";
                        }
                      } else {
                        monthCounts = 12 - enrolledDate.month;
                        monthCounts = monthCounts + currentDate!.month;
                        int count = 0;
                        for (int i = enrolledDate.year + 1;
                            i <= currentDate!.year - 1;
                            i++) {
                          count++;
                        }
                        monthCounts = monthCounts + (count * 12);
                        if (monthCounts < 2) {
                          snapshot.data![index].totalMonths =
                              monthCounts.toString() + " month ago";
                        } else {
                          snapshot.data![index].totalMonths =
                              monthCounts.toString() + " months ago";
                        }
                      }
                    }

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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void getTaskRetailers() async {
    retailerStreamController.addError("loading");
    if (await Network.isConnected()) {
      if (day.isEmpty) {
        currentDate =
            await NTP.now().timeout(const Duration(seconds: 5), onTimeout: () {
          return DateTime.now();
        });
        day = DateFormat("EEEE").format(currentDate!);
      }

      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["task_status"] = widget.index;
      input["beat_id"] = selectedBeat!.id;
      input["day"] = day;

      GetRetailersTaskResponse response =
          await repository.getRetailersTaskWise(input);
      if (response.success) {
        retailers = response.data!;
        debugPrint("response = ${response.message}");
        retailerStreamController.add(retailers);
      } else {
        debugPrint("response = ${response.message}");
        retailerStreamController.add(retailers);
      }
    } else {
      retailerStreamController.addError(StringConst.internetCheck);
    }
  }

  @override
  void onBeatSelect(BeatsModal beatsModal, String day, String type) async {
    if (selectedBeat!.id != beatsModal.id) {
      retailerStreamController.add(retailers);
    }

    selectedBeat = beatsModal;
    if (day.isEmpty) {
      DateTime dateTime =
          await NTP.now().timeout(const Duration(seconds: 5), onTimeout: () {
        return DateTime.now();
      });
      this.day = DateFormat.EEEE().format(dateTime);
    } else {
      this.day = day;
    }
    getTaskRetailers();
  }

  @override
  void onSorting(String type) {}

  void onRefresh() async {
    retailers.clear();
    getTaskRetailers();
    refreshController.refreshCompleted();
  }
}

class TaskBeatWidget extends StatefulWidget {
  final List<BeatsModal> tags;
  final BeatsModal? beatsModal;
  final Function(BeatsModal tag) onSelect;

  const TaskBeatWidget({
    Key? key,
    required this.tags,
    required this.onSelect,
    required this.beatsModal,
  }) : super(key: key);

  @override
  _TaskBeatWidgetState createState() => _TaskBeatWidgetState();
}

class _TaskBeatWidgetState extends State<TaskBeatWidget> {
  BeatsModal? tag = BeatsModal(id: "", name: "All");

  @override
  void initState() {
    if (widget.tags.length > 1) {
      widget.onSelect(tag!);
    } else {
      tag = BeatsModal(name: "", id: "");
      widget.onSelect(tag!);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(TaskBeatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.beatsModal != null) {
      tag = widget.beatsModal;
    }
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
              ? const EdgeInsets.only(left: 10)
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
            active: widget.tags[index].name == tag!.name,
            customData: widget.tags[index],
            textActiveColor: Colors.black,
            textColor: const Color(0xff555555),
            elevation: 0,
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            border: Border.all(
                color: widget.tags[index].name == tag!.name
                    ? MColor.colorPrimary
                    : const Color(0xffC5C5C5),
                width: 1.5),
            singleItem: true,
            activeColor: widget.tags[index].name == tag!.name
                ? const Color(0xffFFC9CC)
                : const Color(0xffFAFAFA),
            color: widget.tags[index].name == tag!.name
                ? const Color(0xffFFC9CC)
                : const Color(0xffFAFAFA),
            title: widget.tags[index].name,
          ),
        );
      },
    );
  }
}
