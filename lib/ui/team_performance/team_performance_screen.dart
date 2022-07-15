import 'package:dms/ui/team_performance/bloc/team_performance_bloc.dart';
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

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeamPerformanceBloc>(
      create: (context) => teamPerformanceBloc,
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
            TeamPerformanceTab(
              index: 0,
              bloc: teamPerformanceBloc,
              type: "today",
              title: widget.title,
              userId: widget.userId,
            ),
            TeamPerformanceTab(
              index: 1,
              bloc: teamPerformanceBloc,
              type: "weekly",
              title: widget.title,
              userId: widget.userId,
            ),
            TeamPerformanceTab(
              index: 2,
              bloc: teamPerformanceBloc,
              type: "monthly",
              title: widget.title,
              userId: widget.userId,
            ),
          ],
        ),
      ),
    );
  }
}
