import 'dart:async';
import 'dart:collection';

import 'package:dms/ui/custom_widget/no_internet.dart';
import 'package:dms/ui/custom_widget/search_not_found.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/product_list_item.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../main.dart';

class SearchProductScreen extends StatefulWidget {
  final String retailerId;
  final String beatId;

  const SearchProductScreen({
    Key? key,
    required this.retailerId,
    required this.beatId,
  }) : super(key: key);

  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  TextEditingController edtSearch = TextEditingController();
  List<ProductsModal> productsList = [];
  final subject = BehaviorSubject<String>();

  StreamController<List<ProductsModal>> searchStream = StreamController();

  @override
  void initState() {
    subject.stream.debounce((event) => TimerStream(event, const Duration(milliseconds: 1000))).listen((query) {
      debugPrint("query--->$query");
      productsList.clear();
      searchApi(query);
    });
    // subject.debounce((event) => TimerStream(event, const Duration(milliseconds: 600)).listen((event) { }));
    // .switchMap((query) async* {
    //
    //   debugPrint("query--->$query");
    //   productsList.clear();
    //   searchApi(query);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              autofocus: true,
              controller: edtSearch,
              onChanged: (text) {
                if (text.isEmpty) {
                  productsList.clear();
                  searchStream.addError("Enter product name to search products");
                } else if (text.trim().length >= 3) {
                  productsList.clear();
                  subject.add(text);
                }
              },
              decoration: InputDecoration(
                  hintText: StringConst.search,
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
                  suffixIcon: IconButton(
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.cancel,
                      color: Color(0xff555555),
                    ),
                    onPressed: () {
                      if (edtSearch.text.trim().isNotEmpty) {
                        edtSearch.clear();
                        productsList.clear();
                        searchStream.addError("Enter product name to search products");
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  )),
            ),
          ),
        ),
        actions: const [
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: StreamBuilder<List<ProductsModal>>(
        stream: searchStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: SearchNotFound(
                  onRefresh: () {
                    searchApi(edtSearch.text);
                  },
                ),
              );
            }
          }

          if (snapshot.hasData) {
            return ListView.separated(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.all(15),
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  return ProductListItem(
                    products: snapshot.data![index],
                  );
                });
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
                    searchApi(edtSearch.text);
                  },
                ),
              );
            }
          }

          return Container();
        },
      ),
    );
  }

  void searchApi(String text) async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      // input["beat_id"] = "27";
      // input["retailer_id"] = "27";
      input["beat_id"] = widget.beatId;
      input["retailer_id"] = widget.retailerId;
      input["search"] = text;
      searchStream.addError("loading");
      GetProductsResponse response = await repository.searchProduct(input);
      if (response.success) {
        productsList = response.data!;
        searchStream.add(response.data!);
      } else {
        searchStream.add(productsList);
      }
    } else {
      searchStream.addError(Constants.internetAlert);
    }
  }
}
