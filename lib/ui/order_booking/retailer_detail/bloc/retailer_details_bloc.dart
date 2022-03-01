import 'dart:collection';
import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/retailer_detail/bloc/retailer_details_events.dart';
import 'package:dms/ui/order_booking/retailer_detail/bloc/retailer_details_states.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RetailerDetailsBloc
    extends Bloc<RetailerDetailEvents, RetailerDetailStates> {
  RetailerDetailsBloc() : super(RetailerDetailInitialState());

  @override
  Stream<RetailerDetailStates> mapEventToState(
      RetailerDetailEvents event) async* {
    if (event is GetRetailerDetailsEvent) {
      yield RetailerDetailLodingState();
      yield* getRetailerDetails(event);
    }
  }

  Stream<RetailerDetailStates> getRetailerDetails(
      GetRetailerDetailsEvent event) async* {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["user_id"] = event.storeId;
      RetailersDetailsResponse response =
          await repository.getRetailerInfo(input);
      if (response.success) {
        yield GetRetailerDetailState(retailer: response.data!.first);
      } else {
        yield RetailerDetailFailureState(failureMessage: response.message);
      }
    } else {
      yield RetailerDetailFailureState(
          failureMessage: StringConst.internetCheck);
    }
  }
}
