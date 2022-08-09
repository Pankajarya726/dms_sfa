import 'dart:async';
import 'dart:collection';

import 'package:dms/main.dart';
import 'package:dms/ui/custom_widget/no_internet.dart';
import 'package:dms/ui/custom_widget/search_not_found.dart';
import 'package:dms/ui/task/task/model/get_retailers_task_response.dart';
import 'package:dms/ui/task/task/task_list_item.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:rxdart/rxdart.dart';

class SearchTaskScreen extends StatefulWidget {
  final String day;

  const SearchTaskScreen({
    Key? key,
    required this.day,
  }) : super(key: key);

  @override
  _SearchTaskScreenState createState() => _SearchTaskScreenState();
}

class _SearchTaskScreenState extends State<SearchTaskScreen> {
  TextEditingController edtSearch = TextEditingController();
  List<RetailersTaskModal> retailersList = [];
  StreamController<List<RetailersTaskModal>> searchStream = StreamController();
  DateTime? currentDate;
  String day = "";
  final subject = BehaviorSubject<String>();

  @override
  void initState() {
    subject.stream.debounce((event) => TimerStream(event, const Duration(milliseconds: 1000))).listen((query) {
      debugPrint("query--->$query");
      retailersList.clear();
      searchApi(query);
    });
    day = widget.day;
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
                  searchStream.addError("Enter Name or mobile number to search retailer");
                } else if (text.trim().length >= 3) {
                  retailersList.clear();
                  subject.add(text);
                }
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
                        searchStream.addError("Enter Name or mobile number to search retailer");
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
      body: StreamBuilder<List<RetailersTaskModal>>(
        stream: searchStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: SearchNotFound(
                onRefresh: () {
                  searchApi(edtSearch.text);
                },
              ),
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
                  // calculate months from enrolled date to current date
                  if (snapshot.data![index].enrollmentDate.isNotEmpty) {
                    int monthCounts = 0;
                    DateTime enrolledDate = DateTime.parse(snapshot.data![index].enrollmentDate);
                    if (enrolledDate.year == currentDate!.year) {
                      monthCounts = currentDate!.month - enrolledDate.month;
                      if (monthCounts < 2) {
                        snapshot.data![index].totalMonths = monthCounts.toString() + " month ago";
                      } else {
                        snapshot.data![index].totalMonths = monthCounts.toString() + " months ago";
                      }
                    } else {
                      monthCounts = 12 - enrolledDate.month;
                      monthCounts = monthCounts + currentDate!.month;
                      int count = 0;
                      for (int i = enrolledDate.year + 1; i <= currentDate!.year - 1; i++) {
                        count++;
                      }
                      monthCounts = monthCounts + (count * 12);
                      if (monthCounts < 2) {
                        snapshot.data![index].totalMonths = monthCounts.toString() + " month ago";
                      } else {
                        snapshot.data![index].totalMonths = monthCounts.toString() + " months ago";
                      }
                    }
                  }

                  return TaskListItems(
                    index: 0,
                    retailer: retailersList[index],
                    orderStatus: 2,
                    beatId: retailersList[index].beatId,
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
      if (day.isEmpty) {
        DateTime dateTime = await NTP.now().timeout(const Duration(seconds: 5), onTimeout: () {
          return DateTime.now();
        });
        day = DateFormat("EEEE").format(dateTime);
      }

      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["search"] = text;
      input["day"] = day;
      searchStream.addError("loading");
      GetRetailersTaskResponse response = await repository.searchTaskRetailers(input);
      if (response.success) {
        currentDate = await NTP.now().timeout(const Duration(seconds: 5), onTimeout: () {
          return DateTime.now();
        });
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
