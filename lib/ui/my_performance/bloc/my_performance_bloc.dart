import 'package:dms/main.dart';
import 'package:dms/ui/my_performance/bloc/my_performance_event.dart';
import 'package:dms/ui/my_performance/bloc/my_performance_state.dart';
import 'package:dms/ui/my_performance/model/get_my_performance_response.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/constants.dart';

class MyPerformanceBloc extends Bloc<MyPerformanceEvent, MyPerformanceState> {
  MyPerformanceBloc() : super(MyPerformanceInitState());

  @override
  Stream<MyPerformanceState> mapEventToState(MyPerformanceEvent event) async* {
    if (event is GetPerformanceEvent) {
      yield PerformanceLoadingState();

      yield* getMyPerformance(event);
    }

    if (event is MyPerformanceTabChangeEvent) {
      yield MyPerformanceLoadingState();
      yield MyPerformanceTabChangeState(index: event.index);
    }
  }

  Stream<MyPerformanceState> getMyPerformance(GetPerformanceEvent event) async* {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = {};
      input["type"] = event.type;
      input["date"] = event.date;

      GetMyPerformanceResponse response = await repository.getMyPerformance(input);
      if (response.success) {
        yield GetMyPerformanceState(performance: response.data!);
      } else {
        yield GetMyPerformanceFailureState(msg: response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
