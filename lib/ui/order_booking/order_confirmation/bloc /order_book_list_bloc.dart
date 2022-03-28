import 'package:dms/ui/order_booking/order_booking_list/bloc/order_book_list_events.dart';
import 'package:dms/ui/order_booking/order_booking_list/bloc/order_book_list_states.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_brand_category_resonse.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/ui/order_booking/order_confirmation/bloc%20/order_book_list_events.dart';
import 'package:dms/ui/order_booking/order_confirmation/bloc%20/order_book_list_states.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../main.dart';

class OrderConfirmationBloc
    extends Bloc<OrderConfirmationEvents, OrderConfirmationStates> {
  OrderConfirmationBloc() : super(OrderConfirmationInitialState());

  @override
  Stream<OrderConfirmationStates> mapEventToState(
      OrderConfirmationEvents event) async* {
    if (event is GetFocusSkuEvent) {
      yield OrderConfirmationLoadingState();
      yield* getFocusSku(event);
    }
  }

  Stream<OrderConfirmationStates> getFocusSku(GetFocusSkuEvent event) async* {
    if (await Network.isConnected()) {
      GetProductsResponse response = await repository.getProducts(event.input);
      if (response.success) {
        yield GetFocusSkuState(prouductsModal: response.data!);
      } else {
        Utility.showToast(response.message);
        yield OrderConfirmationFailureState(msg: response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
      yield OrderConfirmationFailureState(msg: Constants.internetAlert);
    }
  }
}
