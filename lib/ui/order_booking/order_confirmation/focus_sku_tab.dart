import 'package:dms/ui/custom_widget/no_internet.dart';
import 'package:dms/ui/custom_widget/retailer_not_found.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/product_list_item.dart';
import 'package:dms/ui/order_booking/order_confirmation/bloc%20/order_book_list_bloc.dart';
import 'package:dms/ui/order_booking/order_confirmation/bloc%20/order_book_list_events.dart';
import 'package:dms/ui/order_booking/order_confirmation/bloc%20/order_book_list_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FocusSkyTab extends StatefulWidget {
  final Function() onConfirm;
  final String beatId;
  final String retailerId;
  const FocusSkyTab({
    Key? key,
    required this.onConfirm,
    required this.beatId,
    required this.retailerId,
  }) : super(key: key);

  @override
  _FocusSkyTabState createState() => _FocusSkyTabState();
}

class _FocusSkyTabState extends State<FocusSkyTab> {
  List<ProductsModal> focusSkuList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  OrderConfirmationBloc orderConfirmationBloc = OrderConfirmationBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      body: BlocProvider(
        create: (context) => orderConfirmationBloc,
        child: BlocBuilder<OrderConfirmationBloc, OrderConfirmationStates>(
          builder: (context, state) {
            if (state is OrderConfirmationInitialState) {
              Map<String, dynamic> input = {
                "beat_id": widget.beatId,
                "retailer_id": widget.retailerId,
              };
              orderConfirmationBloc.add(GetFocusSkuEvent(input: input));
            }
            if (state is OrderConfirmationLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetFocusSkuState) {
              focusSkuList = state.prouductsModal;
            }
            if (state is OrderConfirmationFailureState) {
              if (state.msg == Constants.internetAlert) {
                return Center(
                  child: NoInternetConnection(
                    onRefresh: () {
                      Map<String, dynamic> input = {
                        "beat_id": widget.beatId,
                        "retailer_id": widget.retailerId,
                      };
                      orderConfirmationBloc.add(GetFocusSkuEvent(input: input));
                    },
                  ),
                );
              }
            }

            if (focusSkuList.isEmpty) {
              return Center(
                child: ProductNotFound(
                  onRefresh: () {
                    Map<String, dynamic> input = {
                      "beat_id": widget.beatId,
                      "retailer_id": widget.retailerId,
                    };
                    orderConfirmationBloc.add(GetFocusSkuEvent(input: input));
                  },
                ),
              );
            }

            return SmartRefresher(
              primary: false,
              controller: refreshController,
              onRefresh: onRefresh,
              enablePullDown: true,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                itemCount: focusSkuList.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 15,
                  );
                },
                itemBuilder: (context, index) {
                  return ProductListItem(
                    products: focusSkuList[index],
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: MaterialButton(
        onPressed: () {
          widget.onConfirm();
        },
        color: MColor.colorSecondary,
        height: 50,
        minWidth: MediaQuery.of(context).size.width,
        shape: const RoundedRectangleBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "GO TO SUMMARY",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Image.asset(
              "assets/arrow.png",
              height: 27,
            )
          ],
        ),
      ),
    );
  }

  void onRefresh() async {
    focusSkuList.clear();
    Map<String, dynamic> input = {
      "beat_id": widget.beatId,
      "retailer_id": widget.retailerId,
    };
    orderConfirmationBloc.add(GetFocusSkuEvent(input: input));
    refreshController.refreshCompleted();
  }
}
