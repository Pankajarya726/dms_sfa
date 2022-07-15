import 'package:dms/main.dart';
import 'package:dms/ui/team_performance/bloc/team_performance_event.dart';
import 'package:dms/ui/team_performance/bloc/team_performance_state.dart';
import 'package:dms/ui/team_performance/model/get_team_performance_response.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/constants.dart';

class TeamPerformanceBloc extends Bloc<TeamPerformanceEvent, TeamPerformanceState> {
  TeamPerformanceBloc() : super(TeamPerformanceInitState());

  @override
  Stream<TeamPerformanceState> mapEventToState(TeamPerformanceEvent event) async* {
    if (event is GetPerformanceEvent) {
      yield TeamPerformanceLoadingState();

      yield* getTeamPerformance(event);
    }
  }

  Stream<TeamPerformanceState> getTeamPerformance(GetPerformanceEvent event) async* {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = {};
      input["type"] = event.type;
      input["date"] = event.date;
      input["user_id"] = event.userId;

      GetTeamPerformanceResponse response = await repository.getTeamPerformance(input);
      if (response.success) {
        yield GetTeamPerformanceState(performance: response.data!);
      } else {
        yield GetTeamPerformanceFailureState(msg: response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
