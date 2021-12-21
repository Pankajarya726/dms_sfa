import 'package:dms/ui/my_plan/model/get_plan_response.dart';
import 'package:dms/ui/my_plan/my_plan.dart';
import 'package:flutter/material.dart';

class MyPlanTabScreen extends StatefulWidget {
  final List<MyPlanModel> plans;

  const MyPlanTabScreen({Key? key, required this.plans}) : super(key: key);

  @override
  _MyPlanTabScreenState createState() => _MyPlanTabScreenState();
}

class _MyPlanTabScreenState extends State<MyPlanTabScreen> {
  List<String> weeks = ["week1", "week2", "week3"];
  List<MyPlan> myPlan = [];

  Map<String, List<MyPlan>> myPlanMap = {};

  @override
  void initState() {
    getWeek();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        // children: [List.generate(length, (index) => null)],
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
}
