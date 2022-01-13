import 'package:dms/ui/order_booking/order_booking_list/order_booking_list_item.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

class FocusSkyTab extends StatefulWidget {
  final Function() onConfirm;
  const FocusSkyTab({Key? key, required this.onConfirm}) : super(key: key);

  @override
  _FocusSkyTabState createState() => _FocusSkyTabState();
}

class _FocusSkyTabState extends State<FocusSkyTab> {
  List<Flavours> flavours = [];

  @override
  void initState() {
    getFlavours();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        itemCount: flavours.length,
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 15,
          );
        },
        itemBuilder: (context, index) {
          return OrderBookingListItems(
            index: 1,
            flavours: flavours[index],
          );
        },
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
