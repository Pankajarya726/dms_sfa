import 'package:dms/main.dart';
import 'package:dms/ui/my_plan/bloc/my_plan_events.dart';
import 'package:dms/ui/my_plan/bloc/my_plan_states.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyPlanBloc extends Bloc<MyPlanEvents, MyPlanStates> {
  MyPlanBloc() : super(MyPlanInitialState());

  @override
  Stream<MyPlanStates> mapEventToState(MyPlanEvents event) async* {
    if (event is MyPlanGetDataEvent) {
      yield MyPlanLoadingState();
      yield* myPlanGetData(event);
    }
  }

  Stream<MyPlanStates> myPlanGetData(MyPlanGetDataEvent event) async* {
    // if (await Network.isConnected()) {
    //   String userId = await SharedPreference.getStringPreference("id");
    //   MyPlanResponse response = repository.myPlanData(userId, event.date);

    //   if (response.success) {
    //     yield MyPlanGetDataState(myPlanResponse: response);
    //   } else {
    //     yield MyPlanFailureState(failureMessage: response.message);
    //   }
    // } else {
    //   yield MyPlanFailureState(
    //       failureMessage: "Please check your internet connection!");
    // }
  }
}
