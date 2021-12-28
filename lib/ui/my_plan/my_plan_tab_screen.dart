import 'package:dms/main.dart';
import 'package:dms/model/get_plan_response.dart';
import 'package:dms/ui/my_plan/my_plan.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class MyPlanTabScreen extends StatefulWidget {
  final List<PlanDataModel> plans;
  final DateTime dateTime;

  const MyPlanTabScreen({Key? key, required this.plans, required this.dateTime}) : super(key: key);

  @override
  _MyPlanTabScreenState createState() => _MyPlanTabScreenState();
}

class _MyPlanTabScreenState extends State<MyPlanTabScreen> with TickerProviderStateMixin {
  List<int> week = [];
  List<WeeklyPlanModel> weeklyPlan = [];
  TabController? tabController;

  @override
  void initState() {
    print("MyPlanTabScreen--->");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WeeklyPlanModel>>(
        future: getPlans(),
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<WeeklyPlanModel> weeklyPlan = snapshot.data!;
            return DefaultTabController(
                length: weeklyPlan.length,
                child: Column(
                  children: [
                    TabBar(
                      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                      controller: tabController,
                      isScrollable: true,
                      unselectedLabelColor: Colors.black54,
                      // indicatorWeight: 40,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xffFFC9CC),
                          border: Border.all(width: 1, color: const Color(0xffF3505A))),

                      onTap: (index) {
                        tabController!.index = index;
                      },

                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      indicatorPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                      labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: List.generate(
                          weeklyPlan.length,
                          (i) => Tab(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Week ${weeklyPlan[i].week}",
                                    style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                    ),
                    Expanded(
                        child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: tabController,
                            children: List.generate(weeklyPlan.length, (index) {
                              weeklyPlan[index].planList.sort((a, b) => a.addPlanDate.compareTo(b.addPlanDate));

                              return PlanListWidget(
                                planList: weeklyPlan[index].planList,
                              );
                            })))
                  ],
                ));
          }
          return const Center(
            child: Text("Record not found"),
          );
        });
  }

  Future<List<WeeklyPlanModel>> getPlans() async {
    if (await Network.isConnected()) {
      String userId = await SharedPreference.getStringPreference(SharedPreference.userId);
      GetPlanResponse response = await repository.getPlanByMonth(userId, DateFormat("yyyy-MM").format(widget.dateTime));

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
          List<PlanDataModel> pm = response.data.where((element) => element.week == w).toList();
          weeklyPlan.add(WeeklyPlanModel(week: w, planList: pm));
        }
        weeklyPlan.sort((a, b) => a.week.compareTo(b.week));

        tabController = TabController(length: weeklyPlan.length, vsync: this);
        return weeklyPlan;
      } else {
        return [];
      }
    } else {
      Fluttertoast.showToast(msg: "Please check your internet connection!");
      return [];
    }
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
  int week;
  List<PlanDataModel> planList;

  WeeklyPlanModel({required this.week, required this.planList});
}
