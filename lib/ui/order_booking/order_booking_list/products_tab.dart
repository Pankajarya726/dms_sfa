import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:dms/listeners/mrp_filter_listener.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/custom_widget/no_internet.dart';
import 'package:dms/ui/custom_widget/retailer_not_found.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_brand_category_resonse.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_filter_mrp_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/product_list_item.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductTabs extends StatefulWidget {
  final int index;
  final String beatId;
  final String retailerId;
  final BrandAndCategoryModel brands;
  final Function(MrpFilterListener listener) onInit;
  final String mrpFilter;
  final String orderId;
  const ProductTabs(
      {Key? key,
      required this.index,
      required this.brands,
      required this.beatId,
      required this.retailerId,
      required this.onInit,
      required this.mrpFilter,
      required this.orderId})
      : super(key: key);

  @override
  _ProductTabsState createState() => _ProductTabsState();
}

class _ProductTabsState extends State<ProductTabs> implements MrpFilterListener {
  List<ProductsModal> productList = [];
  StreamController<List<ProductsModal>> productStream = StreamController();
  List<Category> categoryList = [];
  Category? category;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  String filterMrp = "";

  @override
  void initState() {
    debugPrint("ProductTabs---initState-->${widget.brands.toString()}");
    widget.onInit(this);

    if (widget.mrpFilter.isNotEmpty) {
      filterMrp = widget.mrpFilter;
    }

    if (widget.index > 1) {
      if (widget.brands.category.isNotEmpty) {
        if (widget.brands.category.length > 1) {
          categoryList.add(Category(id: "", categoryName: "All"));
        }
        categoryList.addAll(widget.brands.category);
        category = categoryList.first;
        getProduct(widget.brands.id, category!.id);
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
  void didUpdateWidget(covariant ProductTabs oldWidget) {
    categoryList.clear();
    if (widget.mrpFilter.isNotEmpty) {
      filterMrp = widget.mrpFilter;
    }

    if (widget.index > 1) {
      if (widget.brands.category.isNotEmpty) {
        if (widget.brands.category.length > 1) {
          categoryList.add(Category(id: "", categoryName: "All"));
        }
        categoryList.addAll(widget.brands.category);
        category = categoryList.first;
        getProduct(widget.brands.id, category!.id);
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
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.index > 1 && widget.brands.category.isNotEmpty
            ? BeatsWidget(
                category: category != null ? category! : Category(id: "", categoryName: ""),
                tags: categoryList,
                onSelect: (Category tag) {
                  debugPrint("onBeatSelect-->${tag.categoryName}");
                  if (category!.id != tag.id) {
                    category = tag;
                    getProduct(widget.brands.id, category!.id);
                  }
                },
              )
            : Container(),
        Expanded(
          child: StreamBuilder<List<ProductsModal>>(
              stream: productStream.stream,
              builder: (context, snapshot) {
                log("snapshot-->$snapshot");

                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(
                    child: ProductNotFound(
                      onRefresh: () {
                        productList.clear();
                        if (widget.index == 0) {
                          getSuggestedProduct();
                        } else if (widget.index == 1) {
                          getSchemeProduct();
                        } else {
                          getProduct(widget.brands.id, category == null ? "" : category!.id);
                        }
                      },
                    ),
                  );
                }

                if (snapshot.hasData) {
                  // List<ProductsModal> products = snapshot.data!;

                  return SmartRefresher(
                    primary: false,
                    controller: refreshController,
                    onRefresh: onRefresh,
                    enablePullDown: true,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(10),
                      itemCount: productList.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        return ProductListItem(
                          products: productList[index],
                        );
                      },
                    ),
                  );
                }

                if (snapshot.hasError) {
                  if (snapshot.error.toString() == "loading") {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.error.toString() == Constants.internetAlert) {
                    return Center(
                      child: NoInternetConnection(
                        onRefresh: () {
                          productList.clear();
                          if (widget.index == 0) {
                            getSuggestedProduct();
                          } else if (widget.index == 1) {
                            getSchemeProduct();
                          } else {
                            getProduct(widget.brands.id, category == null ? "" : category!.id);
                          }
                        },
                      ),
                    );
                  }
                }

                return Container();
              }),
        )
      ],
    );
  }

  void getProduct(String brandId, String categoryId) async {
    if (await Network.isConnected()) {
      productStream.addError("loading");
      Map<String, dynamic> input = HashMap<String, dynamic>();

      input["brand_id"] = brandId;
      input["category_id"] = categoryId;
      input["beat_id"] = widget.beatId;
      input["retailer_id"] = widget.retailerId;
      input["mrp"] = filterMrp;

      GetProductsResponse response = await repository.getProducts(input);
      if (response.success) {
        productList = response.data!;
        productStream.add(productList);
      } else {
        productStream.add([]);
      }
    } else {
      productStream.addError(Constants.internetAlert);
    }
  }

  void getSuggestedProduct() async {
    if (await Network.isConnected()) {
      productStream.addError("loading");
      Map<String, dynamic> input = HashMap<String, dynamic>();

      input["beat_id"] = widget.beatId;
      input["retailer_id"] = widget.retailerId;

      GetProductsResponse response = await repository.getSuggestedProduct(input);
      if (response.success) {
        if (filterMrp.isNotEmpty) {
          productList.clear();
          for (int i = 0; i < response.data!.length; i++) {
            if (int.parse(response.data![i].mrp) == int.parse(filterMrp)) {
              productList.add(response.data![i]);
            }
          }
        } else {
          productList = response.data!;
        }
        productStream.add(productList);
      } else {
        productStream.add([]);
      }
    } else {
      productStream.addError(Constants.internetAlert);
    }
  }

  void getSchemeProduct() async {
    if (await Network.isConnected()) {
      productStream.addError("loading");
      Map<String, dynamic> input = HashMap<String, dynamic>();

      input["beat_id"] = widget.beatId;
      input["retailer_id"] = widget.retailerId;

      GetProductsResponse response = await repository.getSchemeProducts(input);
      if (response.success) {
        if (filterMrp.isNotEmpty) {
          productList.clear();
          for (int i = 0; i < response.data!.length; i++) {
            if (int.parse(response.data![i].mrp) == int.parse(filterMrp)) {
              productList.add(response.data![i]);
            }
          }
        } else {
          productList = response.data!;
        }
        productStream.add(productList);
      } else {
        productStream.add([]);
      }
    } else {
      productStream.addError(Constants.internetAlert);
    }
  }

  void onRefresh() async {
    productList.clear();
    if (widget.index == 0) {
      getSuggestedProduct();
    } else if (widget.index == 1) {
      getSchemeProduct();
    } else {
      getProduct(widget.brands.id, category == null ? "" : category!.id);
    }
    refreshController.refreshCompleted();
  }

  @override
  void onMrpSelected(FilterMrpModal mrp) {
    filterMrp = mrp.mrp;
    if (filterMrp.isNotEmpty) {
      if (widget.index == 0) {
        getSuggestedProduct();
      } else if (widget.index == 1) {
        getSchemeProduct();
      } else {
        getProduct(widget.brands.id, category == null ? "" : category!.id);
      }
    }
  }
}

class BeatsWidget extends StatefulWidget {
  final List<Category> tags;
  final Function(Category tag) onSelect;
  final Category? category;

  const BeatsWidget({
    Key? key,
    required this.tags,
    required this.onSelect,
    required this.category,
  }) : super(key: key);

  @override
  _BeatsWidgetState createState() => _BeatsWidgetState();
}

class _BeatsWidgetState extends State<BeatsWidget> {
  Category tag = Category(id: "", categoryName: "All");

  @override
  void initState() {
    if (widget.tags.length > 1) {
      if (widget.category == null) {
        widget.onSelect(tag);
      } else {
        tag = widget.category!;
        widget.onSelect(tag);
      }
    } else {
      if (widget.tags.isEmpty) {
        tag = Category(categoryName: "", id: "");
        widget.onSelect(tag);
      } else {
        tag = widget.category!;
        widget.onSelect(tag);
      }
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BeatsWidget oldWidget) {
    if (widget.category != null) {
      tag = widget.category!;
    }
    super.didUpdateWidget(oldWidget);
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
              textActiveColor: widget.tags[index].categoryName == tag.categoryName ? Colors.black : const Color(0xff555555),
              textColor: widget.tags[index].categoryName == tag.categoryName ? Colors.black : const Color(0xff555555),
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
