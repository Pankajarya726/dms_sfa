import 'dart:async';
import 'dart:collection';

import 'package:dms/listeners/select_category_listener.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/filter_order_booking_bottom_sheet.dart';
import 'package:dms/ui/order_booking/order_booking_list/bloc/order_book_list_bloc.dart';
import 'package:dms/ui/order_booking/order_booking_list/bloc/order_book_list_events.dart';
import 'package:dms/ui/order_booking/order_booking_list/bloc/order_book_list_states.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_brand_category_resonse.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_filter_mrp_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/products_tab.dart';
import 'package:dms/ui/order_booking/order_confirmation/order_confirmation_screen.dart';
import 'package:dms/ui/order_booking/search_products/search_product_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBookingListScreen extends StatefulWidget {
  final String retailerId;
  final String beatId;

  const OrderBookingListScreen({
    Key? key,
    required this.retailerId,
    required this.beatId,
  }) : super(key: key);

  @override
  _OrderBookingListScreenState createState() => _OrderBookingListScreenState();
}

class _OrderBookingListScreenState extends State<OrderBookingListScreen> with TickerProviderStateMixin {
  TabController? tabController;
  FilterMrpModal? filterMrpModal;
  List<Category> tags = [];
  Category? category;
  List<BrandAndCategoryModel> tabList = [];
  BrandAndCategoryModel? brandAndCategoryModel;
  SelectCategoryListener? selectCategoryListener;
  StreamController<int> tabStreamController = StreamController();
  int tabIndex = 0;
  String moqQty = "";
  String packQty = "";

  @override
  void dispose() {
    if (tabController != null) {
      tabController!.dispose();
    }
    tabStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBookListBloc(),
      child: BlocListener<OrderBookListBloc, OrderBookListStates>(
        listener: (context, state) {
          if (state is GetBrandAndCatgState) {
            tabList.add(BrandAndCategoryModel(id: "", name: "Suggested", category: []));
            tabList.add(BrandAndCategoryModel(id: "", name: "Scheme", category: []));
            tabList.addAll(state.brandAndCategoryModal);
            tabController = TabController(length: tabList.length, vsync: this, initialIndex: 0);
            // BlocProvider.of<OrderBookListBloc>(context).add(ChangeTabEvent(index: 0));
          }
          if (state is GetBrandsFailureState) {
            tabList.add(BrandAndCategoryModel(id: "", name: "Suggested", category: []));
            tabList.add(BrandAndCategoryModel(id: "", name: "Scheme", category: []));
            tabController = TabController(length: tabList.length, vsync: this, initialIndex: 0);
            // BlocProvider.of<OrderBookListBloc>(context).add(ChangeTabEvent(index: 0));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              StringConst.orderBooking,
              style: TextStyle(
                color: MColor.backButton,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leadingWidth: 90,
            leading: Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.only(left: 15),
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: MColor.backButton,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      builder: (context) => FilterOrderBookingBottomSheet(
                        beatId: widget.beatId,
                        onMrpSelected: (mrp) {
                          filterMrpModal = mrp;
                        },
                        filterMrpModal: filterMrpModal,
                      ),
                    );
                  },
                  icon: const Image(
                    fit: BoxFit.cover,
                    width: 30,
                    image: AssetImage("assets/filter.png"),
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: MaterialButton(
                  height: 30,
                  minWidth: 0,
                  padding: const EdgeInsets.fromLTRB(5, 5, 3, 5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderConfirmationScreen(
                          beatId: widget.beatId,
                          retailerId: widget.retailerId,
                        ),
                      ),
                    );
                  },
                  color: MColor.colorSecondary,
                  child: Row(
                    children: const [
                      Text(
                        StringConst.confirmSmall,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.67,
                        ),
                      ),
                      Image(
                        width: 20,
                        image: AssetImage("assets/arrow.png"),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(110),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 16),
                      readOnly: true,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SearchProductScreen(beatId: widget.beatId, retailerId: widget.retailerId)));
                      },
                      decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: const TextStyle(fontSize: 16),
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              gapPadding: 2,
                              borderSide: const BorderSide(width: 1, color: Color(0xffC5C5C5))),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              gapPadding: 2,
                              borderSide: const BorderSide(width: 1, color: Color(0xffC5C5C5))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              gapPadding: 2,
                              borderSide: const BorderSide(width: 1, color: Color(0xffC5C5C5))),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xff555555),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: BlocBuilder<OrderBookListBloc, OrderBookListStates>(
                      builder: (context, state) {
                        if (state is OrderBookListInitialState) {
                          Map<String, dynamic> input = HashMap<String, dynamic>();
                          input["beat_id"] = "27";
                          BlocProvider.of<OrderBookListBloc>(context).add(GetBrandAndCatgEvent(input: input));
                          return Container();
                        }
                        if (tabController == null) {
                          return Container();
                        }

                        return Container(
                          height: 50,
                          color: const Color(0xffEDEDED),
                          child: TabBar(
                            onTap: (value) {
                              // BlocProvider.of<OrderBookListBloc>(context)
                              //     .add(ChangeTabEvent(index: value));
                            },
                            isScrollable: true,
                            controller: tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 4,
                            indicatorColor: MColor.colorPrimary,
                            labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                            indicatorPadding: const EdgeInsets.symmetric(horizontal: 5),
                            tabs: List.generate(tabList.length, (index) {
                              return Tab(
                                child: Text(
                                  tabList[index].name,
                                  style: Theme.of(context).textTheme.bodyText1!.merge(
                                        TextStyle(
                                          color: const Color(0xff303030).withOpacity(0.85),
                                          letterSpacing: 0.67,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: BlocBuilder<OrderBookListBloc, OrderBookListStates>(
            builder: (context, state) {
              debugPrint("state-->$state");
              if (state is OrderBookListInitialState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (tabController == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return TabBarView(
                controller: tabController,
                children: List.generate(tabList.length, (index) {
                  return ProductTabs(
                    index: index,
                    brands: tabList[index],
                    retailerId: widget.retailerId,
                    beatId: widget.beatId,
                  );
                }),
              );
              // debugPrint("tabIndex-->$tabIndex");
              // if (tabIndex > 1) {
              //   List<Category> categoryList = [];
              //   categoryList.add(Category(id: "", categoryName: "All"));
              //   categoryList.addAll(tabList[tabIndex].category);
              //   return Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       BeatsWidget(
              //         tags: categoryList,
              //         // tags: tags,
              //         onSelect: (Category tag) {
              //           debugPrint("onBeatSelect-->${tag.categoryName}");
              //           category = tag;
              //           if (selectCategoryListener != null) {
              //             selectCategoryListener!.onCategorySelect(brandAndCategoryModel!, category!);
              //           }
              //         },
              //       ),
              //       Expanded(
              //         child: OrderBookingTab(
              //           index: tabIndex,
              //           retailerId: widget.retailerId,
              //           beatId: widget.beatId,
              //           category: category == null ? Category(id: "", categoryName: "") : category!,
              //           brandAndCategoryModel: brandAndCategoryModel == null
              //               ? BrandAndCategoryModel(id: "", name: "", category: [])
              //               : tabList[tabIndex],
              //           onInit: (SelectCategoryListener listener) {
              //             selectCategoryListener = listener;
              //           },
              //           onBrandSelect: (brand) {
              //             if (brand != null) {
              //               brandAndCategoryModel = brand;
              //             }
              //           },
              //         ),
              //       ),
              //     ],
              //   );
              // } else {
              //   return OrderBookingTab(
              //     index: tabIndex,
              //     retailerId: widget.retailerId,
              //     beatId: widget.beatId,
              //     category: category == null ? Category(id: "", categoryName: "") : category!,
              //     brandAndCategoryModel:
              //         brandAndCategoryModel == null ? BrandAndCategoryModel(id: "", name: "", category: []) : tabList[tabIndex],
              //     onInit: (SelectCategoryListener listener) {
              //       selectCategoryListener = listener;
              //     },
              //     onBrandSelect: (brand) {
              //       if (brand != null) {
              //         brandAndCategoryModel = brand;
              //       }
              //     },
              //   );
              // }
            },
          ),
        ),
      ),
    );
  }
}

class OrderBookingModal {
  OrderBookingModal({
    required this.brandName,
    required this.categories,
  });

  String brandName;
  List<Categories> categories;
}

class Categories {
  Categories({
    required this.categoryName,
    required this.products,
  });

  String categoryName;
  List<Products> products;
}

class Products {
  Products({
    required this.id,
    required this.productName,
    required this.mrp,
    required this.ptr,
    required this.image,
    required this.skuRatePerPkg,
    required this.skuRatePerMoq,
    required this.skuRatePerPiece,
    required this.moqName,
    required this.packagingName,
    required this.skuCode,
    required this.weight,
    required this.variantName,
    required this.longDescription,
    required this.pcsPerMoq,
    required this.pcsPerPackaging,
    required this.priceAfterDiscount,
    required this.pkgQty,
    required this.moqQty,
    required this.schemes,
  });

  String id;
  String productName;
  String mrp;
  String ptr;
  String image;
  String skuRatePerPkg;
  String skuRatePerMoq;
  String skuRatePerPiece;
  String moqName;
  String packagingName;
  String skuCode;
  String weight;
  String variantName;
  String longDescription;
  String pcsPerMoq;
  String pcsPerPackaging;
  String priceAfterDiscount;
  String pkgQty;
  String moqQty;
  List<Scheme>? schemes;
}
