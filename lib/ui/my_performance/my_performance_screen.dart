import 'package:dms/ui/my_performance/bloc/my_performance_bloc.dart';
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

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myPerformanceBloc,
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
          actions: [],
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
        body: TabBarView(
          controller: _tabController,
          children: [
            PerformanceTab(
              index: 0,
              bloc: myPerformanceBloc,
              type: "today",
            ),
            PerformanceTab(
              index: 1,
              bloc: myPerformanceBloc,
              type: "weekly",
            ),
            PerformanceTab(
              index: 2,
              bloc: myPerformanceBloc,
              type: "monthly",
            ),
          ],
        ),
      ),
    );
  }
}
