import 'dart:async';
import 'package:dms/listeners/select_beat_listener.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/filter_task_bottom_sheet.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/task/search_task/search_task_screen.dart';
import 'package:dms/ui/task/task/bloc/retailer_task_bloc.dart';
import 'package:dms/ui/task/task/task_tab.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import '../../../main.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({
    Key? key,
  }) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  RetailersTaskBloc retailersTaskBloc = RetailersTaskBloc();
  List<BeatsModal> beats = [];
  BeatsModal? beatModal;
  SelectBeatListener? selectBeatListener;
  String selectedDay = "";
  StreamController<List<BeatsModal>> beatsStreamController = StreamController();
  StreamController<int> tabStream = StreamController();

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    getBeats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: BlocProvider<RetailersTaskBloc>(
        create: (context) => retailersTaskBloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              StringConst.task,
              style: TextStyle(
                color: MColor.backButton,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      isScrollControlled: true,
                      builder: (context) {
                        return FilterTaskBottomSheet(
                          beatList: beats,
                          day: selectedDay,
                          beat: beatModal != null
                              ? beatModal!
                              : BeatsModal(id: "", name: ""),
                          onFilter: (day, beatModal, beatList) {
                            selectedDay = day;
                            beats = beatList;
                            this.beatModal = beatModal;
                            beatsStreamController.add(beats);
                            if (selectBeatListener != null) {
                              selectBeatListener!.onBeatSelect(
                                  this.beatModal!, selectedDay, "");
                            }
                          },
                        );
                      });
                },
                icon: const Image(
                  width: 30,
                  image: AssetImage("assets/filter.png"),
                ),
              )
            ],
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: MColor.backButton,
              ),
            ),
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 16),
                      readOnly: true,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    SearchTaskScreen(day: selectedDay)));
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: StringConst.search,
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 2,
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFF6E6E6E),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 2,
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFF6E6E6E),
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xff555555),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    color: const Color(0xffEDEDED),
                    child: TabBar(
                      controller: tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 3,
                      indicatorColor: MColor.colorPrimary,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                      onTap: (index) {
                        debugPrint("select-tag-->${beatModal!.name}");
                        tabStream.add(index + 1);
                      },
                      tabs: [
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Image(
                                  width: 20,
                                  image: AssetImage("assets/all.png"),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  StringConst.all,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .merge(
                                        TextStyle(
                                          color: const Color(0xff303030)
                                              .withOpacity(0.85),
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Image(
                                  width: 20,
                                  image: AssetImage("assets/hit.png"),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  StringConst.hit,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .merge(
                                        TextStyle(
                                          color: const Color(0xff303030)
                                              .withOpacity(0.85),
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Image(
                                  width: 20,
                                  image: AssetImage("assets/special.png"),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Text(
                                    StringConst.special,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .merge(
                                          TextStyle(
                                            color: const Color(0xff303030)
                                                .withOpacity(0.85),
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          iconMargin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Image(
                                  width: 20,
                                  image: AssetImage("assets/key.png"),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  StringConst.key,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .merge(
                                        TextStyle(
                                          color: const Color(0xff303030)
                                              .withOpacity(0.85),
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<List<BeatsModal>>(
                stream: beatsStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.error.toString() == "loading") {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (beats.isEmpty) {
                    return Container();
                  }

                  return SizedBox(
                    height: 50,
                    child: TaskBeatWidget(
                      beatsModal: beatModal,
                      tags: beats,
                      onSelect: (BeatsModal tag) {
                        debugPrint("onBeatSelect-->${tag.name}");
                        beatModal = tag;
                        if (selectBeatListener != null) {
                          selectBeatListener!
                              .onBeatSelect(beatModal!, selectedDay, "");
                        }
                      },
                    ),
                  );
                },
              ),
              Expanded(
                child: StreamBuilder<int>(
                  stream: tabStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return TaskTab(
                        index: snapshot.data!,
                        selectedBeat: beatModal == null
                            ? BeatsModal(id: "", name: "All")
                            : beatModal!,
                        onInit: (SelectBeatListener listener) {
                          selectBeatListener = listener;
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getBeats() async {
    if (await Network.isConnected()) {
      DateTime dateTime =
          await NTP.now().timeout(const Duration(seconds: 15), onTimeout: () {
        return DateTime.now();
      });
      if (selectedDay.isEmpty) {
        selectedDay = DateFormat("EEEE").format(dateTime);
      }
      beatsStreamController.addError("loading");
      Map<String, dynamic> input = {"day": "Friday"};
      GetAllBeatsResponse response =
          await repository.getBeatByOrderBookingDay(input);
      if (response.success) {
        if (response.data!.length > 1) {
          beats.add(BeatsModal(id: "", name: "All"));
        } else {
          beatModal = response.data!.first;
        }
        beats.addAll(response.data!);
        beatsStreamController.add(beats);
        tabStream.add(tabController.index + 1);
      } else {
        beatsStreamController.addError(response.message);
        tabStream.add(tabController.index + 1);
        Utility.showToast(response.message);
      }
    } else {
      tabStream.add(tabController.index + 1);
    }
  }
}
