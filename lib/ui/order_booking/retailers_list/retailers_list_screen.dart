import 'dart:collection';

import 'package:dms/main.dart';
import 'package:dms/ui/add_store/outlet_information/outlet_information.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/filter_retailer_bottom_sheet.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailers_tab.dart';
import 'package:dms/ui/order_booking/search_retailers/search_retailier_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class RetailerListScreen extends StatefulWidget {
  const RetailerListScreen({Key? key}) : super(key: key);

  @override
  _RetailerListScreenState createState() => _RetailerListScreenState();
}

class _RetailerListScreenState extends State<RetailerListScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
    getAllBeats();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      builder: (context) {
                        return const FilterRetailerBottomSheet();
                      });
                },
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Image(
                    width: 25,
                    height: 25,
                    image: AssetImage("assets/sorting.png"),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      builder: (context) {
                        return const FilterRetailerBottomSheet();
                      });
                },
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Image(
                    width: 25,
                    height: 25,
                    image: AssetImage("assets/route.png"),
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    StringConst.retailers,
                    style: TextStyle(
                      color: MColor.backButton,
                    ),
                  ),
                ),
              ),
              Center(
                child: MaterialButton(
                  height: 30,
                  minWidth: 50,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OutletInformation(),
                      ),
                    );
                  },
                  color: MColor.colorSecondary,
                  child: const Text(
                    StringConst.addCaps,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      builder: (context) {
                        return const FilterRetailerBottomSheet();
                      });
                },
                icon: const Image(
                  width: 30,
                  image: AssetImage("assets/filter.png"),
                ),
              )
            ],
          ),
          leadingWidth: 45,
          leading: IconButton(
            splashRadius: 20,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Image(
              image: AssetImage("assets/back.png"),
              color: Colors.black,
            ),
          ),
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 16),
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SearchRetailerScreen()));
                    },
                    decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            gapPadding: 2,
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xffC5C5C5))),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            gapPadding: 2,
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xffC5C5C5))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            gapPadding: 2,
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xffC5C5C5))),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xff555555),
                        )),
                  ),
                ),
                Container(
                  height: 50,
                  color: const Color(0xffEDEDED),
                  child: TabBar(
                      controller: tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 3,
                      indicatorColor: MColor.colorPrimary,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                      indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: 5),
                      tabs: [
                        Tab(
                          child: Text(
                            "Not Connected",
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                TextStyle(
                                    color: const Color(0xff303030)
                                        .withOpacity(0.85),
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "No Order",
                            style: Theme.of(context).textTheme.bodyText2!.merge(
                                TextStyle(
                                    color: const Color(0xff303030)
                                        .withOpacity(0.85),
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Order",
                            style: Theme.of(context).textTheme.bodyText2!.merge(
                                TextStyle(
                                    color: const Color(0xff303030)
                                        .withOpacity(0.85),
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ]),
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            RetailerTab(index: 0),
            RetailerTab(index: 1),
            RetailerTab(index: 2)
          ],
        ),
      ),
    );
  }

  void getAllBeats() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["user_id"] = await SharedPreference.getStringPreference(
        SharedPreference.userId); //login user id
    input["date"] = "2022-02-22";
    GetAllBeatsResponse response = await repository.getAllBeats(input);
    if (response.success) {
      debugPrint("response = ${response.message}");
    } else {
      debugPrint("response = ${response.message}");
    }
  }
}

class DmsAppBar extends AppBar {
  DmsAppBar({Key? key});

  @override
  Widget? get leading => IconButton(
        onPressed: () {},
        icon: const Image(
          image: AssetImage("assets/calendar_icon.png"),
        ),
      );
}
