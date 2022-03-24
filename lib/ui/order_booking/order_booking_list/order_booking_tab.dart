import 'dart:async';
import 'dart:collection';

import 'package:dms/listeners/select_category_listener.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_brand_category_resonse.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/order_booking_list_item.dart';
import 'package:dms/ui/order_booking/order_booking_list/scheme_product_list.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class OrderBookingTab extends StatefulWidget {
  final int index;
  final String beatId;
  final String retailerId;
  final BrandAndCategoryModel brandAndCategoryModel;
  final Category category;
  final Function(
    BrandAndCategoryModel? brandAndCategoryModel,
  ) onBrandSelect;
  final Function(SelectCategoryListener listener) onInit;
  const OrderBookingTab({
    Key? key,
    required this.index,
    required this.beatId,
    required this.retailerId,
    required this.brandAndCategoryModel,
    required this.category,
    required this.onInit,
    required this.onBrandSelect,
  }) : super(key: key);

  @override
  _OrderBookingTabState createState() => _OrderBookingTabState();
}

class _OrderBookingTabState extends State<OrderBookingTab> implements SelectCategoryListener {
  List<ProductsModal> productList = [];
  List<ProductsModal> schemesList = [];
  StreamController<List<ProductsModal>> productsStreamController = StreamController();
  StreamController<List<ProductsModal>> schemesStreamController = StreamController();
  BrandAndCategoryModel? brandAndCategoryModel;
  Category? category;
  List<Category> categoryList = [];

  @override
  void initState() {
    debugPrint("initstate---> called");
    brandAndCategoryModel ??= widget.brandAndCategoryModel;
    category = widget.category;
    widget.onInit(this);
    widget.onBrandSelect(brandAndCategoryModel!);
    if (widget.index == 0) {
      debugPrint("api nh bani abhi");
    } else if (widget.index == 1) {
      getSchemeProducts();
    } else {
      getProducts();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index == 0
            ? Container()
            : widget.index == 1
                ? Expanded(
                    child: StreamBuilder<List<ProductsModal>>(
                      stream: schemesStreamController.stream,
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

                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 15,
                            );
                          },
                          itemBuilder: (context, index) {
                            return SchemeProductListItems(
                              index: widget.index,
                              schemes: snapshot.data![index],
                            );
                          },
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: StreamBuilder<List<ProductsModal>>(
                      stream: productsStreamController.stream,
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
                              products: snapshot.data![index],
                            );
                          },
                        );
                      },
                    ),
                  )
      ],
    );
  }

  getProducts() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    // input["beat_id"] = "27";
    // input["brand_id"] = "1";
    // input["category_id"] = "";
    // input["retailer_id"] = "27";

    input["beat_id"] = widget.beatId;
    input["retailer_id"] = widget.retailerId;
    input["brand_id"] = brandAndCategoryModel!.id;
    input["category_id"] = category!.id;

    GetProductsResponse response = await repository.getProducts(input);
    if (response.success) {
      productList = response.data!;
      productsStreamController.add(productList);
    } else {
      productsStreamController.addError(response.message);
    }
  }

  getSchemeProducts() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();

    input["beat_id"] = "27";
    input["retailer_id"] = "41";
    // input["beat_id"] = widget.beatId;
    // input["retailer_id"] = widget.retailerId;
    GetProductsResponse response = await repository.getSchemeProducts(input);
    if (response.success) {
      schemesList = response.data!;
      schemesStreamController.add(schemesList);
    } else {
      schemesStreamController.addError(response.message);
    }
  }

  @override
  void onCategorySelect(BrandAndCategoryModel brandAndCategoryModel, Category category) {
    this.brandAndCategoryModel = brandAndCategoryModel;
    this.category = category;
    getProducts();
  }

  // void getFlavours() async {
  //   flavours.add(Flavours(
  //     flavourName: "Glow Pop Red Rose",
  //     mrp: "MRP: 5₹",
  //     ptr: "PTR: ₹12.5",
  //     image:
  //         "https://d29qfl7sjqf9f5.cloudfront.net/uploads/image/image/503094/photo.jpg",
  //   ));
  //   flavours.add(Flavours(
  //     flavourName: "Trumpet Pop Strawberry",
  //     mrp: "MRP: 15₹",
  //     ptr: "PTR: ₹15.67",
  //     image:
  //         "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Chocolate_%28blue_background%29.jpg/640px-Chocolate_%28blue_background%29.jpg",
  //   ));
  //   flavours.add(Flavours(
  //     flavourName: "Lollipop Mango Strawberry",
  //     mrp: "MRP: 25₹",
  //     ptr: "PTR: ₹27.09",
  //     image:
  //         "https://i.pinimg.com/736x/4c/f7/b8/4cf7b8fa13224525d7a0a5480c4cb56d.jpg",
  //   ));
  //   flavours.add(Flavours(
  //     flavourName: "Surprise Egg Dexter's",
  //     mrp: "MRP: 50₹",
  //     ptr: "PTR: ₹17.23",
  //     image:
  //         "https://thefirstyearblog.com/wp-content/uploads/2015/11/Chocolate-Chocolate-Cake-8.jpg",
  //   ));
  //   flavours.add(Flavours(
  //     flavourName: "Jelly Mix Fruits",
  //     mrp: "MRP: 100₹",
  //     ptr: "PTR: ₹24.01",
  //     image:
  //         "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Schokolade-schwarz.jpg/1200px-Schokolade-schwarz.jpg",
  //   ));
  //   flavours.add(Flavours(
  //     flavourName: "Mix Shake",
  //     mrp: "MRP: 150₹",
  //     ptr: "PTR: ₹56.08",
  //     image:
  //         "https://images.newscientist.com/wp-content/uploads/2021/04/08150421/efr8nf_web.jpg",
  //   ));
  //   productsStreamController.add(flavours);
  // }
}

class BeatsWidget extends StatefulWidget {
  final List<Category> tags;
  final Function(Category tag) onSelect;

  const BeatsWidget({Key? key, required this.tags, required this.onSelect}) : super(key: key);

  @override
  _BeatsWidgetState createState() => _BeatsWidgetState();
}

class _BeatsWidgetState extends State<BeatsWidget> {
  Category tag = Category(id: "", categoryName: "All");

  @override
  void initState() {
    widget.onSelect(tag);
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
              active: widget.tags[index].categoryName == tag.categoryName,
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
                color: widget.tags[index].categoryName == tag.categoryName ? MColor.colorPrimary : const Color(0xffC5C5C5),
              ),
              singleItem: true,
              activeColor: widget.tags[index].categoryName == tag.categoryName ? const Color(0xffFFC9CC) : const Color(0xffFAFAFA),
              color: widget.tags[index].categoryName == tag.categoryName ? const Color(0xffFFC9CC) : const Color(0xffFAFAFA),
              title: widget.tags[index].categoryName,
            ),
          );
        },
      ),
    );
  }
}
