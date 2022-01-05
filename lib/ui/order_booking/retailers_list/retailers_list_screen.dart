import 'package:dms/ui/order_booking/edit_store/edit_store_screen.dart';
import 'package:dms/ui/order_booking/retailers_list/retailers_tab.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class RetailerListScreen extends StatefulWidget {
  const RetailerListScreen({Key? key}) : super(key: key);

  @override
  _RetailerListScreenState createState() => _RetailerListScreenState();
}

class _RetailerListScreenState extends State<RetailerListScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            retailers,
            style: TextStyle(
              color: MColor.backButton,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: MColor.backButton,
            ),
          ),
          actions: [
            Center(
              child: MaterialButton(
                height: 30,
                minWidth: 50,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditStoreScreen(),
                    ),
                  );
                },
                color: MColor.colorSecondary,
                child: const Text(
                  addCaps,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Image(
                width: 30,
                image: AssetImage("assets/filter.png"),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 16),
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
                Container(
                  height: 50,
                  color: const Color(0xffEDEDED),
                  child: TabBar(
                      controller: tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 3,
                      indicatorColor: MColor.colorPrimary,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                      indicatorPadding: const EdgeInsets.symmetric(horizontal: 5),
                      tabs: const [
                        Tab(
                          child: Text(
                            "Not Connected",
                            style: TextStyle(color: Color(0xff303030)),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "No Order",
                            style: TextStyle(color: Color(0xff303030)),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Order",
                            style: TextStyle(color: Color(0xff303030)),
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
          children: const [RetailerTab(index: 0), RetailerTab(index: 1), RetailerTab(index: 2)],
        ),
      ),
    );
  }
}
