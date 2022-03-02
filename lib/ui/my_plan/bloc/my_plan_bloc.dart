import 'package:dms/main.dart';
import 'package:dms/model/get_plan_response.dart';
import 'package:dms/ui/my_plan/bloc/my_plan_events.dart';
import 'package:dms/ui/my_plan/bloc/my_plan_states.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class MyPlanBloc extends Bloc<MyPlanEvents, MyPlanStates> {
  MyPlanBloc() : super(MyPlanInitialState());

  @override
  Stream<MyPlanStates> mapEventToState(MyPlanEvents event) async* {
    if (event is GetMyPlansEvent) {
      yield MyPlanLoadingState();
      yield* myPlanGetData(event);
    }

    if (event is GetMonthsEvent) {
      yield* getMonths();
    }
  }

  Stream<MyPlanStates> myPlanGetData(GetMyPlansEvent event) async* {
    if (await Network.isConnected()) {
      String userId = await SharedPreference.getStringPreference(SharedPreference.userId);
      GetPlanResponse response = await repository.getPlanByMonth(userId, event.date);

      if (response.success) {
        yield GetPlanSuccessState(myPlan: response.data);
      } else {
        yield MyPlanFailureState(failureMessage: response.message);
      }
    } else {
      yield MyPlanFailureState(failureMessage: "Please check your internet connection!");
    }
  }

  Stream<MyPlanStates> getMonths() async* {
    bool pjpButton = await SharedPreference.getBooleanPreference(SharedPreference.showAddPlanButton);
    List<DateTime> months = [];
    debugPrint((DateFormat("MMMM").format(DateTime(DateTime.now().year, DateTime.now().month - 6, DateTime.now().day))).toString());

    DateTime now = DateTime.now();
    if (await Network.isConnected()) {
      now = await NTP.now();
    }

    // DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    //
    // debugPrint("${lastDayOfMonth.month}/${lastDayOfMonth.day}");

    months.add(DateTime(
      now.year,
      now.month - 6,
    ));
    months.add(DateTime(
      now.year,
      now.month - 5,
    ));
    months.add(DateTime(
      now.year,
      now.month - 4,
    ));
    months.add(DateTime(
      now.year,
      now.month - 3,
    ));
    months.add(DateTime(
      now.year,
      now.month - 2,
    ));
    months.add(DateTime(
      now.year,
      now.month - 1,
    ));
    months.add(DateTime(
      now.year,
      now.month,
    ));
    months.add(DateTime(
      now.year,
      now.month + 1,
    ));

    debugPrint("months -> $months");
    yield GetMonthState(months: months, pjpButton: pjpButton);
  }
}
