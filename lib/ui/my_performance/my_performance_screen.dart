import 'dart:async';

import 'package:dms/ui/my_performance/bloc/my_performance_bloc.dart';
import 'package:dms/ui/my_performance/bloc/my_performance_event.dart';
import 'package:dms/ui/my_performance/bloc/my_performance_state.dart';
import 'package:dms/ui/my_performance/perfromance_tab.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyPerformanceScreen extends StatefulWidget {
  final String title;

  const MyPerformanceScreen({Key? key, this.title = "My Performance"}) : super(key: key);

  @override
  State<MyPerformanceScreen> createState() => _MyPerformanceScreenState();
}

class _MyPerformanceScreenState extends State<MyPerformanceScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  MyPerformanceBloc myPerformanceBloc = MyPerformanceBloc();
  int index = 0;
  DateTime? date = DateTime.now();
  OnDateChangeListener? dateChangeListener;
  StreamController<int> tabStream = StreamController();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    tabStream.add(0);

    // _tabController.addListener(onTabChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyPerformanceBloc>(
      create: (context) => myPerformanceBloc,
      child: BlocListener<MyPerformanceBloc, MyPerformanceState>(
        listener: (context, state) {
          if (state is MyPerformanceTabChangeState) {
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
              BlocBuilder<MyPerformanceBloc, MyPerformanceState>(builder: (context, state) {
                debugPrint("state-->$state");

                if (state is MyPerformanceTabChangeState) {
                  index = state.index;
                }
                if (index != 0) {
                  return Container();
                }
                return IconButton(
                    onPressed: () async {
                      date = await showDatePicker(
                          context: context, initialDate: DateTime.now(), lastDate: DateTime.now(), firstDate: DateTime(2000, 01, 01));

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
                    myPerformanceBloc.add(MyPerformanceTabChangeEvent(index: index));
                    // if (duplicateTabIndex != index) {
                    //   tabStream.add(index + 1);
                    // }
                    // duplicateTabIndex = index;
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
                return PerformanceTab(
                  index: snap.data!,
                  dateTime: date ?? DateTime.now(),
                  bloc: myPerformanceBloc,
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

              return PerformanceTab(
                index: 0,
                dateTime: date ?? DateTime.now(),
                bloc: myPerformanceBloc,
                type: "monthly",
                init: (OnDateChangeListener listener) {
                  dateChangeListener = listener;
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void onTabChange() {
    myPerformanceBloc.add(MyPerformanceTabChangeEvent(index: _tabController.index));
  }
}
