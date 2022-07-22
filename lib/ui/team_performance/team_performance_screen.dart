import 'dart:async';

import 'package:dms/ui/my_performance/perfromance_tab.dart';
import 'package:dms/ui/team_performance/bloc/team_performance_bloc.dart';
import 'package:dms/ui/team_performance/bloc/team_performance_event.dart';
import 'package:dms/ui/team_performance/bloc/team_performance_state.dart';
import 'package:dms/ui/team_performance/team_perfromance_tab.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamPerformanceScreen extends StatefulWidget {
  final String title;
  final String userId;

  const TeamPerformanceScreen({Key? key, this.title = "Team Report", required this.userId}) : super(key: key);

  @override
  State<TeamPerformanceScreen> createState() => _TeamPerformanceScreenState();
}

class _TeamPerformanceScreenState extends State<TeamPerformanceScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  TeamPerformanceBloc teamPerformanceBloc = TeamPerformanceBloc();
  int index = 0;
  DateTime? date = DateTime.now();
  OnDateChangeListener? dateChangeListener;
  StreamController<int> tabStream = StreamController();
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    tabStream.add(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeamPerformanceBloc>(
      create: (context) => teamPerformanceBloc,
      child: BlocListener<TeamPerformanceBloc, TeamPerformanceState>(
        listener: (context, state) {
          if (state is TeamPerformanceTabChangeState) {
            index = state.index;
            tabStream.add(index);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                splashRadius: 25,
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              actions: [
                BlocBuilder<TeamPerformanceBloc, TeamPerformanceState>(builder: (context, state) {
                  debugPrint("state-->$state");

                  if (state is TeamPerformanceTabChangeState) {
                    index = state.index;
                  }
                  if (index != 0) {
                    return Container();
                  }
                  return IconButton(
                      onPressed: () async {
                        date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            lastDate: DateTime.now(),
                            firstDate: DateTime(2000, 01, 01));

                        if (date != null && dateChangeListener != null) {
                          dateChangeListener!.onDateSelect(date ?? DateTime.now());
                        }
                      },
                      splashRadius: 15,
                      icon: Image.asset(
                        "assets/date.png",
                        height: 25,
                        width: 25,
                      ));
                })
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  height: 50,
                  color: const Color(0xffEDEDED),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 3,
                    overlayColor: MaterialStateProperty.all(Colors.grey),
                    indicatorColor: MColor.colorPrimary,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                    onTap: (index) {
                      teamPerformanceBloc.add(TeamPerformanceTabChangeEvent(index: index));
                    },
                    tabs: [
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "FTD",
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                  TextStyle(
                                    color: const Color(0xff303030).withOpacity(0.85),
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "WTD",
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                  TextStyle(
                                    color: const Color(0xff303030).withOpacity(0.85),
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "MTD",
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                  TextStyle(
                                    color: const Color(0xff303030).withOpacity(0.85),
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: StreamBuilder<int>(
              stream: tabStream.stream,
              builder: (context, snap) {
                if (snap.hasData) {
                  return TeamPerformanceTab(
                    index: snap.data!,
                    userId: widget.userId,
                    dateTime: date ?? DateTime.now(),
                    bloc: teamPerformanceBloc,
                    type: snap.data == 2
                        ? "monthly"
                        : snap.data == 1
                            ? "weekly"
                            : "today",
                    init: (OnDateChangeListener listener) {
                      dateChangeListener = listener;
                    },
                  );
                }

                return TeamPerformanceTab(
                  index: 0,
                  dateTime: date ?? DateTime.now(),
                  bloc: teamPerformanceBloc,
                  userId: widget.userId,
                  type: "today",
                  init: (OnDateChangeListener listener) {
                    dateChangeListener = listener;
                  },
                );
              },
            )),
      ),
    );
  }
}
