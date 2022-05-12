import 'dart:async';

import 'package:dms/main.dart';
import 'package:dms/model/retaileres_response.dart';
import 'package:dms/ui/custom_widget/no_internet.dart';
import 'package:dms/ui/custom_widget/search_not_found.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailer_list_item.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class SearchRetailerScreen extends StatefulWidget {
  final String day;
  final int index;
  final BeatsModal? beatsModal;
  final String retailerType;
  const SearchRetailerScreen({
    required this.day,
    required this.index,
    required this.beatsModal,
    required this.retailerType,
    Key? key,
  }) : super(key: key);

  @override
  _SearchRetailerScreenState createState() => _SearchRetailerScreenState();
}

class _SearchRetailerScreenState extends State<SearchRetailerScreen> {
  TextEditingController edtSearch = TextEditingController();
  List<RetailersModal> retailersList = [];
  StreamController<List<RetailersModal>> searchStream = StreamController();
  String retailerType = "";

  @override
  void initState() {
    if (widget.retailerType == StringConst.retailer) {
      retailerType = "1";
    } else if (widget.retailerType == StringConst.teleRetailer) {
      retailerType = "2";
    } else {
      retailerType = "";
    }
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
                if (text.trim().isEmpty) {
                  retailersList.clear();
                  searchStream.addError(
                      "Enter Name or mobile number to search retailer");
                } else {
                  retailersList.clear();
                  searchApi(text);
                }
              },
              decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: const TextStyle(fontSize: 16),
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      gapPadding: 2,
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xffC5C5C5))),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      gapPadding: 2,
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xffC5C5C5))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      gapPadding: 2,
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xffC5C5C5))),
                  suffixIcon: IconButton(
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.cancel,
                      color: Color(0xff555555),
                    ),
                    onPressed: () {
                      if (edtSearch.text.trim().isNotEmpty) {
                        edtSearch.clear();
                        retailersList.clear();
                        searchStream.addError(
                            "Enter Name or mobile number to search retailer");
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
      body: StreamBuilder<List<RetailersModal>>(
        stream: searchStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: SearchNotFound(onRefresh: () {
                searchApi(edtSearch.text);
              }),
            );
          }

          if (snapshot.hasData) {
            return ListView.separated(
                itemCount: retailersList.length,
                padding: const EdgeInsets.all(15),
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  return RetailerListItems(
                    index: widget.index,
                    retailer: retailersList[index],
                    orderStatus: 0,
                    beatId: snapshot.data![index].beatId,
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
      Map input = {
        "search": text,
        "day": widget.day,
        "beat_id": widget.beatsModal != null ? widget.beatsModal!.id : "",
        "order_status": widget.index,
        "retailer_type": retailerType,
      };
      searchStream.addError("loading");
      RetailersResponse response = await repository.searchRetailer(input);
      if (response.success) {
        retailersList = response.data!;
        searchStream.add(response.data!);
      } else {
        searchStream.add(retailersList);
      }
    } else {
      searchStream.addError(Constants.internetAlert);
    }
  }
}
