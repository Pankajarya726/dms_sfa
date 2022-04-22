import 'dart:async';

import 'package:dms/main.dart';
import 'package:dms/model/retaileres_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailer_list_item.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:flutter/material.dart';

class SearchRetailerScreen extends StatefulWidget {
  final String day;
  const SearchRetailerScreen({
    required this.day,
    Key? key,
  }) : super(key: key);

  @override
  _SearchRetailerScreenState createState() => _SearchRetailerScreenState();
}

class _SearchRetailerScreenState extends State<SearchRetailerScreen> {
  TextEditingController edtSearch = TextEditingController();
  List<RetailersModal> retailers = [];
  StreamController<List<RetailersModal>> searchStream = StreamController();

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
                  retailers.clear();
                  searchStream.addError(
                      "Enter Name or mobile number to search retailer");
                } else {
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
                        retailers.clear();
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
        // initialData: retailers,
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }

          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("Retailers not found"),
              );
            }

            return ListView.separated(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.all(15),
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  return RetailerListItems(
                    index: 0,
                    retailer: snapshot.data![index],
                    orderStatus: 2,
                    beatId: "15",
                  );
                });
          }
          if (snapshot.hasError) {
            if (snapshot.error.toString() == "loading") {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Center(
              child: Text("${snapshot.error}"),
            );
          }

          return Container();
        },
      ),
    );
  }

  void searchApi(String text) async {
    if (await Network.isConnected()) {
      Map input = {"search": text, "day": widget.day};
      searchStream.addError("loading");
      RetailersResponse response = await repository.searchRetailer(input);
      if (response.success) {
        searchStream.add(response.data!);
      } else {
        searchStream.addError(response.message);
      }
    } else {
      searchStream.addError(Constants.internetAlert);
    }
  }
}
