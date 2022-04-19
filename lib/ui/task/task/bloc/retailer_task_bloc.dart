import 'dart:collection';
import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/task/task/bloc/retailers_task_event.dart';
import 'package:dms/ui/task/task/bloc/retailers_task_state.dart';
import 'package:dms/ui/task/task/model/get_retailers_task_response.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class RetailersTaskBloc extends Bloc<RetailerTaskEvent, RetailerTaskState> {
  RetailersTaskBloc() : super(RetailerTaskInitState());

  @override
  Stream<RetailerTaskState> mapEventToState(RetailerTaskEvent event) async* {
    if (event is GetBeatEvent) {
      yield* getBeats(event);
    }
    if (event is GetRetailerTaskEvent) {
      yield* getRetailers(event);
    }
  }

  Stream<RetailerTaskState> getBeats(GetBeatEvent event) async* {
    yield BeatLoadingState();
    if (await Network.isConnected()) {
      DateTime dateTime =
          await NTP.now().timeout(const Duration(seconds: 15), onTimeout: () {
        return DateTime.now();
      });
      Map<String, dynamic> input = {"day": DateFormat("EEEE").format(dateTime)};
      GetAllBeatsResponse response =
          await repository.getBeatByOrderBookingDay(input);
      if (response.success) {
        List<BeatsModal> beats = [];
        beats.add(BeatsModal(id: "", name: "All"));
        beats.addAll(response.data!);
        yield GetBeatState(beats: beats);
      } else {
        Utility.showToast(response.message);
        yield RetailerTaskFailureState(msg: response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
      yield RetailerTaskFailureState(msg: Constants.internetAlert);
    }
  }

  Stream<RetailerTaskState> getRetailers(GetRetailerTaskEvent event) async* {
    yield RetailerTaskLoadingState();
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["task_status"] = event.status;
      input["beat_id"] = event.beatId;
      // input["day"] = event.day;
      DateTime currentDate =
          await NTP.now().timeout(const Duration(seconds: 5), onTimeout: () {
        return DateTime.now();
      });
      GetRetailersTaskResponse response =
          await repository.getRetailersTaskWise(input);
      if (response.success) {
        yield GetRetailersTaskState(
            retailers: response.data!, currentDate: currentDate);
      } else {
        yield RetailerTaskFailureState(msg: response.message);
      }
    } else {
      yield RetailerTaskFailureState(msg: StringConst.internetCheck);
      Utility.showToast(Constants.internetAlert);
    }
  }
}
