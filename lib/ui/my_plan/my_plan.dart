import 'package:dms/model/get_plan_response.dart';
import 'package:dms/ui/add_plan/add_plan_screen.dart';
import 'package:dms/ui/my_plan/bloc/my_plan_bloc.dart';
import 'package:dms/ui/my_plan/bloc/my_plan_events.dart';
import 'package:dms/ui/my_plan/bloc/my_plan_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import 'my_plan_tab_screen.dart';

class MyPlan extends StatefulWidget {
  const MyPlan({Key? key}) : super(key: key);

  @override
  _MyPlanState createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlan> with TickerProviderStateMixin {
  List<DateTime> months = [];
  String selectedWeek = "week 1";
  List<String> weeks = [
    "week 1",
    "week 2",
    "week 3",
    "week 4",
    "week 5",
    "week 6",
  ];
  DateTime? dateTime;
  String shortMonth = "";
  String date = "";
  String day = "";
  String week = "";
  bool pjpButton = false;

  MyPlanBloc myPlanBloc = MyPlanBloc();
  List<PlanDataModel> myplan = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // getTabs();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyPlanBloc>(
      create: (context) => myPlanBloc,
      child: BlocBuilder<MyPlanBloc, MyPlanStates>(
        builder: (context, state) {
          if (state is MyPlanInitialState) {
            myPlanBloc.add(GetMonthsEvent());
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetMonthState) {
            pjpButton = state.pjpButton;
            months = state.months;
            _tabController = TabController(vsync: this, length: months.length);
            myPlanBloc.add(GetMyPlansEvent(date: DateFormat("yyyy-MM").format(months[0])));
          }

          if (state is GetPlanSuccessState) {
            debugPrint(state.myPlan.toString());
            myplan = state.myPlan;
          }

          return DefaultTabController(
            length: months.length,
            initialIndex: 0,
            child: Scaffold(
              backgroundColor: const Color(0xffFAFAFA),
              appBar: AppBar(
                title: const Text(
                  myPlan,
                  style: TextStyle(
                    color: MColor.backButton,
                  ),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: MColor.backButton,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 13, 17, 14),
                    child: pjpButton
                        ? ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(MColor.colorSecondary),
                            ),
                            onPressed: () async {
                              DateTime dateTime = await NTP.now();
                              DateTime next = DateTime(dateTime.year, dateTime.month + 1);
                              debugPrint("next-->$next");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPlanScreen(month: next),
                                ),
                              );
                            },
                            child: const Text(
                              addCaps,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
                bottom: PreferredSize(
                  child: Container(
                    color: const Color(0xFFEDEDED),
                    child: TabBar(
                      indicatorWeight: 3,
                      isScrollable: true,
                      indicatorColor: MColor.tabIndicatorColor,
                      unselectedLabelColor: MColor.backButton,
                      labelColor: MColor.backButton,
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        letterSpacing: 0.67,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: List.generate(months.length, (index) {
                        return Tab(
                          text: DateFormat("MMMM").format(months[index]).toString(),
                        );
                      }),
                    ),
                  ),
                  preferredSize: const Size.fromHeight(50),
                ),
              ),
              body: TabBarView(
                children: List.generate(months.length, (index) {
                  return MyPlanTabScreen(
                    plans: myplan,
                    dateTime: months[index],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyPlanBottomSheet extends StatefulWidget {
  final PlanDataModel planModel;

  const MyPlanBottomSheet({Key? key, required this.planModel}) : super(key: key);

  @override
  _MyPlanBottomSheetState createState() => _MyPlanBottomSheetState();
}

class _MyPlanBottomSheetState extends State<MyPlanBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Info",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.planModel.primaryTag,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  letterSpacing: 0.67,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MColor.backButton,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.planModel.secondaryTag,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  letterSpacing: 0.67,
                  overflow: TextOverflow.ellipsis,
                  color: Color(0xff555555),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.planModel.remark,
                style: const TextStyle(
                  letterSpacing: 0.67,
                  color: Color(0xff555555),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
