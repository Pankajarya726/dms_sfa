import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailers_tab.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../retailers.dart';

class NotConnectedTab extends StatefulWidget {
  final List<BeatsModal> beatList;
  final BeatsModal? selectedBeat;
  final String day;
  final Function(BeatsModal beat) onBeatSelect;

  const NotConnectedTab({Key? key, required this.beatList, this.selectedBeat, required this.onBeatSelect, required this.day})
      : super(key: key);

  @override
  _NotConnectedTabState createState() => _NotConnectedTabState();
}

class _NotConnectedTabState extends State<NotConnectedTab> with TickerProviderStateMixin {
  TabController? _tabController;
  int index = 0;
  List<BeatsModal> beatList = [];
  BeatsModal? selectedBeat;
  String day = DateFormat("EEEE").format(DateTime.now());

  @override
  void initState() {
    debugPrint("come here");
    debugPrint("day1---->${widget.day}");
    beatList = widget.beatList;
    day = widget.day;
    selectedBeat = widget.selectedBeat;
    if (selectedBeat == null) {
      index = 0;
    } else {
      index = beatList.indexWhere((element) => element.id == selectedBeat!.id);
    }

    _tabController = TabController(length: beatList.length, vsync: this, initialIndex: index);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NotConnectedTab oldWidget) {
    debugPrint("come again");
    beatList = widget.beatList;
    selectedBeat = widget.selectedBeat;
    day = widget.day;
    if (selectedBeat == null) {
      index = 0;
    } else {
      index = beatList.indexWhere((element) => element.id == selectedBeat!.id);
    }
    _tabController = TabController(length: beatList.length, vsync: this, initialIndex: index);
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _tabController == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              SizedBox(
                height: 50,
                child: BeatWidget(
                  tags: widget.beatList,
                  onSelect: (BeatsModal tag) {
                    widget.onBeatSelect(tag);
                    selectedBeat = tag;
                    int index = widget.beatList.indexWhere((element) => element.id == tag.id);
                    debugPrint("beatId-->" + selectedBeat!.id);
                    _tabController!.animateTo(index);
                  },
                  selectedBeat: widget.selectedBeat,
                ),
              ),
              Expanded(
                  child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: List.generate(
                    widget.beatList.length,
                    (index) => RetailerList(
                          index: 1,
                          beatId: widget.beatList[index].id,
                          day: day,
                        )),
              ))
            ],
          );
  }
}
