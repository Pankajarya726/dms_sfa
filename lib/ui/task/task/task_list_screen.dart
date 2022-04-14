import 'package:dms/listeners/select_beat_listener.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/filter_task_bottom_sheet.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/task/search_task/search_task_screen.dart';
import 'package:dms/ui/task/task/bloc/retailer_task_bloc.dart';
import 'package:dms/ui/task/task/bloc/retailers_task_event.dart';
import 'package:dms/ui/task/task/bloc/retailers_task_state.dart';
import 'package:dms/ui/task/task/task_tab.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  String selectedBeat = "";

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
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
                          beat: selectedBeat,
                          onFilter: (day, beat) {
                            selectedDay = day;
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
                                builder: (_) => const SearchTaskScreen()));
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
            children: [
              BlocBuilder<RetailersTaskBloc, RetailerTaskState>(
                  builder: (context, state) {
                if (state is RetailerTaskInitState) {
                  retailersTaskBloc.add(GetBeatEvent());
                }

                if (state is GetBeatState) {
                  beats = state.beats;
                  beatModal = beats.first;
                }

                if (beats.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.only(top: 5),
                  );
                }

                return SizedBox(
                  height: 50,
                  child: TaskBeatWidget(
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
              }),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    TaskTab(
                      selectedBeat: beatModal == null
                          ? BeatsModal(id: "", name: "All")
                          : beatModal!,
                      index: 1,
                      onInit: (SelectBeatListener listener) {
                        selectBeatListener = listener;
                      },
                    ),
                    TaskTab(
                      selectedBeat: beatModal == null
                          ? BeatsModal(id: "", name: "All")
                          : beatModal!,
                      index: 2,
                      onInit: (SelectBeatListener listener) {
                        selectBeatListener = listener;
                      },
                    ),
                    TaskTab(
                      selectedBeat: beatModal == null
                          ? BeatsModal(id: "", name: "All")
                          : beatModal!,
                      index: 3,
                      onInit: (SelectBeatListener listener) {
                        selectBeatListener = listener;
                      },
                    ),
                    TaskTab(
                      selectedBeat: beatModal == null
                          ? BeatsModal(id: "", name: "All")
                          : beatModal!,
                      index: 4,
                      onInit: (SelectBeatListener listener) {
                        selectBeatListener = listener;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
