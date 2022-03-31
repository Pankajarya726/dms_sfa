import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/order_booking_list_item.dart';
import 'package:dms/ui/order_booking/order_confirmation/bloc%20/order_book_list_bloc.dart';
import 'package:dms/ui/order_booking/order_confirmation/bloc%20/order_book_list_events.dart';
import 'package:dms/ui/order_booking/order_confirmation/bloc%20/order_book_list_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class FocusSkyTab extends StatefulWidget {
  final Function() onConfirm;
  const FocusSkyTab({Key? key, required this.onConfirm}) : super(key: key);

  @override
  _FocusSkyTabState createState() => _FocusSkyTabState();
}

class _FocusSkyTabState extends State<FocusSkyTab> {
  List<Flavours> flavours = [];
  List<ProductsModal> focusSkuList = [];

  @override
  void initState() {
    getFlavours();
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
                "retailer_id": "17",
              };
              BlocProvider.of<OrderConfirmationBloc>(context)
                  .add(GetFocusSkuEvent(input: input));
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
                return OrderBookingListItems(
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
          children: [
            const Text(
              "GO TO SUMMARY",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 0.67,
              ),
            ),
            SizedBox(
              width: 20,
              height: 15,
              child: SvgPicture.asset(
                "assets/arrow_right.svg",
                height: 20,
                fit: BoxFit.contain,
                width: 15,
                allowDrawingOutsideViewBox: false,
                matchTextDirection: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getFlavours() async {
    flavours.add(Flavours(
      flavourName: "Glow Pop Red Rose",
      mrp: "MRP: 5₹",
      ptr: "PTR: ₹12.5",
      image:
          "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
    ));
    flavours.add(Flavours(
      flavourName: "Trumpet Pop Strawberry",
      mrp: "MRP: 15₹",
      ptr: "PTR: ₹15.67",
      image:
          "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
    ));
    flavours.add(Flavours(
      flavourName: "Lollipop Mango Strawberry",
      mrp: "MRP: 25₹",
      ptr: "PTR: ₹27.09",
      image:
          "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
    ));
    flavours.add(Flavours(
      flavourName: "Surprise Egg Dexter's",
      mrp: "MRP: 50₹",
      ptr: "PTR: ₹17.23",
      image:
          "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
    ));
    flavours.add(Flavours(
      flavourName: "Jelly Mix Fruits",
      mrp: "MRP: 100₹",
      ptr: "PTR: ₹24.01",
      image:
          "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
    ));
    flavours.add(Flavours(
      flavourName: "Mix Shake",
      mrp: "MRP: 150₹",
      ptr: "PTR: ₹56.08",
      image:
          "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg",
    ));
    setState(() {});
  }
}
