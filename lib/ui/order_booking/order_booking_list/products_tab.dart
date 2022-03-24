import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_brand_category_resonse.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/order_booking_list_item.dart';
import 'package:dms/ui/order_booking/order_booking_list/order_booking_tab.dart';
import 'package:flutter/material.dart';

class ProductTabs extends StatefulWidget {
  final int index;
  final String beatId;
  final String retailerId;

  final BrandAndCategoryModel brands;

  const ProductTabs({Key? key, required this.index, required this.brands, required this.beatId, required this.retailerId})
      : super(key: key);

  @override
  _ProductTabsState createState() => _ProductTabsState();
}

class _ProductTabsState extends State<ProductTabs> {
  List<ProductsModal> productList = [];
  StreamController<List<ProductsModal>> productStream = StreamController();
  List<Category> categoryList = [];
  late Category category;

  @override
  void initState() {
    debugPrint("ProductTabs---initState-->${widget.brands.toString()}");
    if (widget.index > 1) {
      if (widget.brands.category.isNotEmpty) {
        if (widget.brands.category.length > 1) {
          categoryList.add(Category(id: "", categoryName: "All"));
        }
        categoryList.addAll(widget.brands.category);
        category = categoryList.first;
        getProduct(widget.brands.id, category.id);
      } else {
        getProduct(widget.brands.id, '');
      }
    } else {
      if (widget.index == 0) {
        getSuggestedProduct();
      } else {
        getSchemeProduct();
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index > 1 && widget.brands.category.isNotEmpty
            ? BeatsWidget(
                tags: categoryList,
                // tags: tags,
                onSelect: (Category tag) {
                  debugPrint("onBeatSelect-->${tag.categoryName}");
                  category = tag;
                  getProduct(widget.brands.id, category.id);
                },
              )
            : Container(),
        Expanded(
          child: StreamBuilder<List<ProductsModal>>(
              stream: productStream.stream,
              builder: (context, snapshot) {
                log("snapshot-->$snapshot");

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text(
                    "Product not found",
                  ));
                }
                if (snapshot.hasData) {
                  List<ProductsModal> products = snapshot.data!;
                  return ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: products.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemBuilder: (context, index) {
                      return OrderBookingListItems(
                        products: products[index],
                      );
                    },
                  );
                }

                return Container();
              }),
        )
      ],
    );
  }

  void getProduct(
    String brandId,
    String categoryId,
  ) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();

    input["brand_id"] = brandId;
    input["category_id"] = categoryId;
    input["beat_id"] = widget.beatId;
    input["retailer_id"] = widget.retailerId;
    GetProductsResponse response = await repository.getProducts(input);
    if (response.success) {
      productList = response.data!;
      productStream.add(productList);
    } else {
      productStream.addError(response.message);
    }
  }

  void getSuggestedProduct() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();

    input["beat_id"] = widget.beatId;
    input["retailer_id"] = widget.retailerId;
    GetProductsResponse response = await repository.getProducts(input);
    if (response.success) {
      productList = response.data!;
      productStream.add(productList);
    } else {
      productStream.addError(response.message);
    }
  }

  void getSchemeProduct() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();

    input["beat_id"] = widget.beatId;
    input["retailer_id"] = widget.retailerId;
    GetProductsResponse response = await repository.getSchemeProducts(input);
    if (response.success) {
      productList = response.data!;
      productStream.add(productList);
    } else {
      productStream.addError(response.message);
    }
  }
}
