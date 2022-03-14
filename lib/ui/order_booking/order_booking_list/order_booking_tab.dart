import 'dart:async';
import 'dart:collection';
import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
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
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BeatsWidget(
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

  getProducts() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["beat_id"] = "27";
    input["brand_id"] = "1";
    input["category_id"] = "";
    input["retailer_id"] = "27";
    GetProductsResponse response = await repository.getProducts(input);
    if (response.success) {
      print("response ${response.message}");
    } else {
      print("response ${response.message}");
    }
  }

  void getFlavours() async {
    flavours.add(Flavours(
      flavourName: "Glow Pop Red Rose",
      mrp: "MRP: 5₹",
      ptr: "PTR: ₹12.5",
      image:
          "https://d29qfl7sjqf9f5.cloudfront.net/uploads/image/image/503094/photo.jpg",
    ));
    flavours.add(Flavours(
      flavourName: "Trumpet Pop Strawberry",
      mrp: "MRP: 15₹",
      ptr: "PTR: ₹15.67",
      image:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Chocolate_%28blue_background%29.jpg/640px-Chocolate_%28blue_background%29.jpg",
    ));
    flavours.add(Flavours(
      flavourName: "Lollipop Mango Strawberry",
      mrp: "MRP: 25₹",
      ptr: "PTR: ₹27.09",
      image:
          "https://i.pinimg.com/736x/4c/f7/b8/4cf7b8fa13224525d7a0a5480c4cb56d.jpg",
    ));
    flavours.add(Flavours(
      flavourName: "Surprise Egg Dexter's",
      mrp: "MRP: 50₹",
      ptr: "PTR: ₹17.23",
      image:
          "https://thefirstyearblog.com/wp-content/uploads/2015/11/Chocolate-Chocolate-Cake-8.jpg",
    ));
    flavours.add(Flavours(
      flavourName: "Jelly Mix Fruits",
      mrp: "MRP: 100₹",
      ptr: "PTR: ₹24.01",
      image:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Schokolade-schwarz.jpg/1200px-Schokolade-schwarz.jpg",
    ));
    flavours.add(Flavours(
      flavourName: "Mix Shake",
      mrp: "MRP: 150₹",
      ptr: "PTR: ₹56.08",
      image:
          "https://images.newscientist.com/wp-content/uploads/2021/04/08150421/efr8nf_web.jpg",
    ));
    flavourstreamController.add(flavours);
  }
}

class BeatsWidget extends StatefulWidget {
  final List<String> tags;
  final Function(String tag) onSelect;

  const BeatsWidget({Key? key, required this.tags, required this.onSelect})
      : super(key: key);

  @override
  _BeatsWidgetState createState() => _BeatsWidgetState();
}

class _BeatsWidgetState extends State<BeatsWidget> {
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
