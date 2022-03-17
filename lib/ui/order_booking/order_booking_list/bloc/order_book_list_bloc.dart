import 'package:dms/ui/order_booking/order_booking_list/bloc/order_book_list_events.dart';
import 'package:dms/ui/order_booking/order_booking_list/bloc/order_book_list_states.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_brand_&_category_resonse.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../main.dart';

class OrderBookListBloc extends Bloc<OrderBookListEvents, OrderBookListStates> {
  OrderBookListBloc() : super(OrderBookListInitialState());

  @override
  Stream<OrderBookListStates> mapEventToState(
      OrderBookListEvents event) async* {
    if (event is GetBrandAndCatgEvent) {
      yield OrderBookListLoadingState();
      yield* getBrandAndCategory(event);
    }
  }

  Stream<OrderBookListStates> getBrandAndCategory(
      GetBrandAndCatgEvent event) async* {
    if (await Network.isConnected()) {
      GetBrandCategoryResponse response =
          await repository.getBrandAndCategory(event.input);
      if (response.success) {
        yield GetBrandAndCatgState(brandAndCategoryModal: response.data!);
      } else {
        Utility.showToast(response.message);
        yield OrderBookListFailureState(failureMessage: response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
      yield OrderBookListFailureState(failureMessage: Constants.internetAlert);
    }
  }
}
