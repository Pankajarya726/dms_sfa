import 'dart:async';
import 'package:dms/ui/order_booking/order_booking_list/order_booking_list_item.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class OrderBookingTab extends StatefulWidget {
  final int index;

  const OrderBookingTab({Key? key, required this.index}) : super(key: key);

  @override
  _OrderBookingTabState createState() => _OrderBookingTabState();
}

class _OrderBookingTabState extends State<OrderBookingTab> {
  List<Flavours> flavours = [];
  List<String> tags = [
    "All",
    "Choco Sticks",
    "Choco Vanilla",
    "Choco bite",
  ];
  String tag = "All";
  StreamController<List<Flavours>> flavourstreamController = StreamController();

  @override
  void initState() {
    getFlavours();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BeatWidget(
            tags: tags,
            onSelect: (String tag) {
              if (tag == "All") {
                flavourstreamController.add(flavours);
              } else {
                List<Flavours> filterList =
                    flavours.where((element) => element.mrp == tag).toList();
                flavourstreamController.add(filterList);
              }
            }),
        Expanded(
          child: StreamBuilder<List<Flavours>>(
            stream: flavourstreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("flavours not found"),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 15,
                  );
                },
                itemBuilder: (context, index) {
                  return OrderBookingListItems(
                    index: widget.index,
                    flavours: snapshot.data![index],
                  );
                },
              );
            },
          ),
        ),
      ],
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
    flavourstreamController.add(flavours);
  }
}

class BeatWidget extends StatefulWidget {
  final List<String> tags;
  final Function(String tag) onSelect;

  const BeatWidget({Key? key, required this.tags, required this.onSelect})
      : super(key: key);

  @override
  _BeatWidgetState createState() => _BeatWidgetState();
}

class _BeatWidgetState extends State<BeatWidget> {
  String tag = "All";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Tags(
        direction: Axis.horizontal,
        itemCount: widget.tags.length,
        horizontalScroll: true,
        itemBuilder: (index) {
          return Padding(
            padding: index == 0
                ? const EdgeInsets.only(left: 10)
                : widget.tags[index] == widget.tags.last
                    ? const EdgeInsets.only(right: 10)
                    : const EdgeInsets.all(0),
            child: ItemTags(
              index: index,
              onPressed: (item) {
                tag = item.customData;
                widget.onSelect(item.customData);
                setState(() {});
              },
              active: widget.tags[index] == tag,
              customData: widget.tags[index],
              textActiveColor: Colors.black,
              textColor: const Color(0xff555555),
              elevation: 0,
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.67,
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              border: Border.all(
                color: widget.tags[index] == tag
                    ? MColor.colorPrimary
                    : const Color(0xffC5C5C5),
              ),
              singleItem: true,
              activeColor: widget.tags[index] == tag
                  ? const Color(0xffFFC9CC)
                  : const Color(0xffFAFAFA),
              color: widget.tags[index] == tag
                  ? const Color(0xffFFC9CC)
                  : const Color(0xffFAFAFA),
              title: widget.tags[index],
            ),
          );
        },
      ),
    );
  }
}
