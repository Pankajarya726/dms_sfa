import 'package:dms/main.dart';
import 'package:dms/ui/my_plan/model/get_plan_response.dart';
import 'package:dms/ui/my_plan/my_plan.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class MyPlanTabScreen extends StatefulWidget {
  final List<MyPlanModel> plans;
  final DateTime dateTime;

  const MyPlanTabScreen({Key? key, required this.plans, required this.dateTime}) : super(key: key);

  @override
  _MyPlanTabScreenState createState() => _MyPlanTabScreenState();
}

class _MyPlanTabScreenState extends State<MyPlanTabScreen> with TickerProviderStateMixin {
  List<int> week = [];
  List<MyPlanModel> myPlan = [];
  TabController? tabController;

  Map<String, List<MyPlanModel>> myPlanMap = {};

  @override
  void initState() {
    getPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return tabController == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              TabBar(
                controller: tabController,
                isScrollable: true,
                unselectedLabelColor: Colors.black54,
                onTap: (index) {
                  tabController!.index = index;
                  setState(() {});
                },
                indicatorSize: TabBarIndicatorSize.label,
                tabs: List.generate(
                    week.length,
                    (i) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: tabController!.index == i ? const Color(0xffFFC9CC) : const Color(0xffFAFAFA),
                              border: Border.all(
                                  width: 1, color: tabController!.index == i ? const Color(0xffF3505A) : const Color(0xffC5C5C5))),
                          alignment: Alignment.center,
                          child: Text(
                            "Week ${week[i]}",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        )),
              ),
              Expanded(
                  child: ListView.separated(
                padding: const EdgeInsets.all(15),
                itemCount: myPlanMap["${week[tabController!.index]}"]!.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  MyPlanModel model = myPlanMap["${week[tabController!.index]}"]![index];

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
                              return const MyPlanBottomSheet();
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
                                      DateFormat('MMM').format(widget.dateTime),
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
              ))
            ],
          );
  }

  void getWeek() {
    List<Map<String, dynamic>> plans = [];
    for (MyPlanModel plan in widget.plans) {
      plans.add(plan.toMap());
    }
    List res = plans
        .fold({}, (previousValue, element) {
          Map val = previousValue as Map;
          String date = element['week'];
          if (!val.containsKey(date)) {
            val[date] = [];
          }
          element.remove('week');
          val[date]?.add(element);
          return val;
        })
        .entries
        .map((e) => {e.key: e.value})
        .toList();

    print("res");
    print(res);
  }

  void getPlans() async {
    if (await Network.isConnected()) {
      String userId = await SharedPreference.getStringPreference(SharedPreference.userId);
      GetPlanResponse response = await repository.getPlanByMonth(userId, DateFormat("yyyy-MM").format(widget.dateTime));

      if (response.success) {
        myPlan = response.data;

        for (var element in myPlan) {
          if (!week.contains(element.week)) {
            week.add(element.week);
          }
        }

        debugPrint("weeks in data $week");

        for (var w in week) {
          List<MyPlanModel> pm = myPlan.where((element) => element.week == w).toList();
          myPlanMap.addAll({"$w": pm});
        }

        tabController = TabController(length: week.length, vsync: this);
        setState(() {});

        debugPrint("myPlanMap$myPlanMap");
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    } else {
      Fluttertoast.showToast(msg: "Please check your internet connection!");
    }
  }
}
