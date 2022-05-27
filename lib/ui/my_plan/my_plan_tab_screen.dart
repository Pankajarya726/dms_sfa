import 'dart:async';

import 'package:dms/main.dart';
import 'package:dms/model/get_plan_response.dart';
import 'package:dms/ui/my_plan/my_plan.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:intl/intl.dart';

class MyPlanTabScreen extends StatefulWidget {
  final List<PlanDataModel> plans;
  final DateTime dateTime;

  const MyPlanTabScreen({Key? key, required this.plans, required this.dateTime})
      : super(key: key);

  @override
  _MyPlanTabScreenState createState() => _MyPlanTabScreenState();
}

class _MyPlanTabScreenState extends State<MyPlanTabScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<MyPlanTabScreen> {
  List<String> week = [];
  List<WeeklyPlanModel> weeklyPlan = [];
  TabController? tabController;

  StreamController<List<PlanDataModel>> planStreamController =
      StreamController.broadcast();

  @override
  void initState() {
    debugPrint("MyPlanTabScreen--->");
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return FutureBuilder<List<WeeklyPlanModel>>(
        future: getPlans(),
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<WeeklyPlanModel> weeklyPlan = snapshot.data!;
            return Column(
              children: [
                WeekTabWidget(
                    weeks: weeklyPlan,
                    onSelect: (planModel) {
                      planStreamController.add(planModel.planList);
                    }),
                Expanded(
                  child: StreamBuilder<List<PlanDataModel>>(
                      stream: planStreamController.stream,
                      initialData: weeklyPlan.first.planList,
                      builder: (builder, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          snapshot.data!.sort(
                              (a, b) => a.addPlanDate.compareTo(b.addPlanDate));

                          return PlanListWidget(
                            planList: snapshot.data!,
                          );
                        }
                        return const Center(child: Text("Data not found"));
                      }),
                ),
              ],
            );
          }
          return const Center(
            child: Text("Record not found"),
          );
        });
  }

  Future<List<WeeklyPlanModel>> getPlans() async {
    if (await Network.isConnected()) {
      // planStreamController.close();
      String userId =
          await SharedPreference.getStringPreference(SharedPreference.userId);
      GetPlanResponse response = await repository.getPlanByMonth(
          userId, DateFormat("yyyy-MM").format(widget.dateTime));

      if (response.success) {
        week.clear();
        for (var element in response.data) {
          if (!week.contains(element.week)) {
            week.add(element.week);
          }
        }
        debugPrint("weeks in data $week");
        weeklyPlan.clear();
        for (var w in week) {
          List<PlanDataModel> pm =
              response.data.where((element) => element.week == w).toList();
          weeklyPlan.add(WeeklyPlanModel(week: w, planList: pm));
        }
        weeklyPlan.sort((a, b) => a.week.compareTo(b.week));

        tabController = TabController(length: weeklyPlan.length, vsync: this);
        return weeklyPlan;
      } else {
        return [];
      }
    } else {
      Utility.showToast("Please check your internet connection!");
      return [];
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class WeekTabWidget extends StatefulWidget {
  final List<WeeklyPlanModel> weeks;
  final Function(WeeklyPlanModel week) onSelect;

  const WeekTabWidget({Key? key, required this.weeks, required this.onSelect})
      : super(key: key);

  @override
  _WeekTabWidgetState createState() => _WeekTabWidgetState();
}

class _WeekTabWidgetState extends State<WeekTabWidget> {
  String week = "Week 1";

  @override
  void initState() {
    week = widget.weeks.first.week;
    widget.onSelect(widget.weeks.first);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Tags(
        direction: Axis.horizontal,
        itemCount: widget.weeks.length,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        horizontalScroll: true,
        itemBuilder: (index) {
          return ItemTags(
            alignment: MainAxisAlignment.start,
            index: index,
            onPressed: (item) {
              week = item.customData.week;
              widget.onSelect(item.customData);
              setState(() {});
            },
            active: widget.weeks[index].week == week,
            customData: widget.weeks[index],
            textActiveColor: Colors.black,
            textColor: const Color(0xff555555),
            elevation: 0,
            textStyle: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            // textStyle: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            border: Border.all(
              color: widget.weeks[index].week == week
                  ? MColor.colorPrimary
                  : const Color(0xffC5C5C5),
            ),
            singleItem: true,
            activeColor: widget.weeks[index].week == week
                ? const Color(0xffFFC9CC)
                : const Color(0xffFAFAFA),
            color: widget.weeks[index].week == week
                ? const Color(0xffFFC9CC)
                : const Color(0xffFAFAFA),
            title: "Week " + widget.weeks[index].week,
          );
        },
      ),
    );
  }
}

class PlanListWidget extends StatefulWidget {
  final List<PlanDataModel> planList;

  const PlanListWidget({Key? key, required this.planList}) : super(key: key);

  @override
  _PlanListWidgetState createState() => _PlanListWidgetState();
}

class _PlanListWidgetState extends State<PlanListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(15),
      itemCount: widget.planList.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 10,
        );
      },
      itemBuilder: (context, index) {
        PlanDataModel model = widget.planList[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  context: context,
                  builder: (context) {
                    return MyPlanBottomSheet(planModel: model);
                  },
                );
              },
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: MColor.dateBoxColor,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            DateFormat('MMM').format(model.addPlanDate),
                            style: const TextStyle(
                              letterSpacing: 0.67,
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('dd').format(model.addPlanDate),
                            style: const TextStyle(
                              letterSpacing: 0.67,
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            DateFormat('E').format(model.addPlanDate),
                            style: const TextStyle(
                              letterSpacing: 0.67,
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      height: 100,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.primaryTag,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                letterSpacing: 0.67,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: MColor.backButton,
                              ),
                            ),
                            Text(
                              model.secondaryTag,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                letterSpacing: 0.67,
                                overflow: TextOverflow.ellipsis,
                                color: Color(0xff555555),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              model.remark,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                letterSpacing: 0.67,
                                overflow: TextOverflow.ellipsis,
                                color: Color(0xff555555),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class WeeklyPlanModel {
  String week;
  List<PlanDataModel> planList;

  WeeklyPlanModel({required this.week, required this.planList});
}
