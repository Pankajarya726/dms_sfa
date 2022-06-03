import 'package:dms/main.dart';
import 'package:dms/ui/order_summery/bloc/order_summery_event.dart';
import 'package:dms/ui/order_summery/bloc/order_summery_state.dart';
import 'package:dms/ui/order_summery/model/get_order_summery_response.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderSummeryBloc extends Bloc<OrderSummeryEvent, OrderSummeryState> {
  OrderSummeryBloc() : super(GetOrderInitialState());

  @override
  Stream<OrderSummeryState> mapEventToState(OrderSummeryEvent event) async* {
    if (event is GetOrderSummeryEvent) {
      yield GetOrderLoadingState();
      yield* getOrderSummery(event);
    }

    if (event is ApplyFilterEvent) {
      yield GetOrderLoadingState();
      yield ApplyFilterState();
    }
  }

  Stream<OrderSummeryState> getOrderSummery(GetOrderSummeryEvent event) async* {
    if (await Network.isConnected()) {
      // Map<String, dynamic> input = {};
      // input["from_date"] = DateFormat("yyyy-MM-dd").format(fromDate);
      // input["to_date"] = DateFormat("yyyy-MM-dd").format(toDate);
      // input["location_type"] = locationType;
      // input["location_id"] = location != null ? location!.id : "";
      // input["customer_id"] = customer != null ? customer!.id : "";

      GetOrderSummeryResponse response = await repository.getOrderSummery(event.input);
      if (response.success) {
        List<OrderSummery> summeryList = response.data;
        summeryList.sort((a, b) => a.date.compareTo(b.date));
        yield GetOrderSummeryState(orderSummery: summeryList);
      } else {
        yield GetOrderSummeryFailureState(message: response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
