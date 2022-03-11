import 'dart:collection';
import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailers_event.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailers_state.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RetailersBloc extends Bloc<RetailerEvent, RetailerState> {
  RetailersBloc() : super(RetailerInitState());

  @override
  Stream<RetailerState> mapEventToState(RetailerEvent event) async* {
    if (event is GetBeatEvent) {
      yield* getBeats(event);
    }
    if (event is GetRetailerEvent) {
      yield* getRetailers(event);
    }
  }

  Stream<RetailerState> getBeats(GetBeatEvent event) async* {
    yield BeatLoadingState();
    if (await Network.isConnected()) {
      GetAllBeatsResponse response =
          await repository.getBeatByOrderBookingDay();
      if (response.success) {
        List<BeatsModal> beats = [];
        beats.add(BeatsModal(id: "", name: "All"));
        beats.addAll(response.data!);
        yield GetBeatState(beats: beats);
      } else {
        Utility.showToast(response.message);
        yield RetailerFailureState(msg: response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
      yield RetailerFailureState(msg: Constants.internetAlert);
    }
  }

  Stream<RetailerState> getRetailers(GetRetailerEvent event) async* {
    yield RetailerLoadingState();
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["order_status"] = event.status;
      input["beat_id"] = event.beatId;
      input["day"] = event.day;
      input["retailer_type"] = event.retailerType;
      GetRetailersResponse response =
          await repository.getRetailersOrderWise(input);
      if (response.success) {
        yield GetRetailersState(retailers: response.data!);
      } else {
        yield RetailerFailureState(msg: response.message);
      }
    } else {
      yield RetailerFailureState(msg: StringConst.internetCheck);
      Utility.showToast(Constants.internetAlert);
    }
  }
}
