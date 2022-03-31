import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/product_list_item.dart';
import 'package:dms/ui/order_booking/order_confirmation/bloc%20/order_book_list_bloc.dart';
import 'package:dms/ui/order_booking/order_confirmation/bloc%20/order_book_list_events.dart';
import 'package:dms/ui/order_booking/order_confirmation/bloc%20/order_book_list_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FocusSkyTab extends StatefulWidget {
  final Function() onConfirm;

  const FocusSkyTab({Key? key, required this.onConfirm}) : super(key: key);

  @override
  _FocusSkyTabState createState() => _FocusSkyTabState();
}

class _FocusSkyTabState extends State<FocusSkyTab> {
  List<ProductsModal> focusSkuList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      body: BlocProvider(
        create: (context) => OrderConfirmationBloc(),
        child: BlocBuilder<OrderConfirmationBloc, OrderConfirmationStates>(
          builder: (context, state) {
            if (state is OrderConfirmationInitialState) {
              Map<String, dynamic> input = {
                "beat_id": "27",
                "brand_id": "1",
                "category_id": "",
                "retailer_id": "17",
              };
              BlocProvider.of<OrderConfirmationBloc>(context).add(GetFocusSkuEvent(input: input));
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
              return Center(
                child: Text(state.msg),
              );
            }
            return ListView.separated(
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
          children: const [
            Text(
              "GO TO SUMMARY",
              style: TextStyle(color: Colors.white),
            ),
            Icon(
              Icons.forward,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
