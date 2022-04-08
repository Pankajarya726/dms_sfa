import 'package:dms/listeners/select_beat_listener.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/filter_task_bottom_sheet.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailer_bloc.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailers_event.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailers_state.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/search_retailers/search_retailier_screen.dart';
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

class _TaskListScreenState extends State<TaskListScreen> with TickerProviderStateMixin {
  late TabController tabController;
  RetailersBloc retailersBloc = RetailersBloc();
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
      child: BlocProvider<RetailersBloc>(
        create: (context) => retailersBloc,
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
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 16),
                      readOnly: true,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchRetailerScreen()));
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Search",
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 2,
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xffC5C5C5),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 2,
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xffC5C5C5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 2,
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xffC5C5C5),
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Image(
                                width: 20,
                                image: AssetImage("assets/all.png"),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "All",
                                style: Theme.of(context).textTheme.bodyText1!.merge(
                                      TextStyle(
                                        color: const Color(0xff303030).withOpacity(0.85),
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Image(
                                width: 20,
                                image: AssetImage("assets/hit.png"),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Hit",
                                style: Theme.of(context).textTheme.bodyText2!.merge(
                                      TextStyle(
                                        color: const Color(0xff303030).withOpacity(0.85),
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Image(
                                width: 20,
                                image: AssetImage("assets/special.png"),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  "Special",
                                  style: Theme.of(context).textTheme.bodyText2!.merge(
                                        TextStyle(
                                          color: const Color(0xff303030).withOpacity(0.85),
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          iconMargin: EdgeInsets.zero,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Image(
                                width: 20,
                                image: AssetImage("assets/key.png"),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Key",
                                style: Theme.of(context).textTheme.bodyText2!.merge(
                                      TextStyle(
                                        color: const Color(0xff303030).withOpacity(0.85),
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
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
              BlocBuilder<RetailersBloc, RetailerState>(builder: (context, state) {
                if (state is RetailerInitState) {
                  retailersBloc.add(GetBeatEvent());
                }

                if (state is GetBeatState) {
                  beats = state.beats;
                  beatModal = beats.first;
                }

                return SizedBox(
                  height: 50,
                  child: TaskBeatWidget(
                    tags: beats,
                    onSelect: (BeatsModal tag) {
                      debugPrint("onBeatSelect-->${tag.name}");
                      beatModal = tag;
                      if (selectBeatListener != null) {
                        selectBeatListener!.onBeatSelect(beatModal!, selectedDay, "");
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
                      selectedBeat: beatModal == null ? BeatsModal(id: "", name: "All") : beatModal!,
                      index: 1,
                      onInit: (SelectBeatListener listener) {
                        selectBeatListener = listener;
                      },
                    ),
                    TaskTab(
                      selectedBeat: beatModal == null ? BeatsModal(id: "", name: "All") : beatModal!,
                      index: 2,
                      onInit: (SelectBeatListener listener) {
                        selectBeatListener = listener;
                      },
                    ),
                    TaskTab(
                      selectedBeat: beatModal == null ? BeatsModal(id: "", name: "All") : beatModal!,
                      index: 3,
                      onInit: (SelectBeatListener listener) {
                        selectBeatListener = listener;
                      },
                    ),
                    TaskTab(
                      selectedBeat: beatModal == null ? BeatsModal(id: "", name: "All") : beatModal!,
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
