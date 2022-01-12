import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/filter_order_booking_bottom_sheet.dart';
import 'package:dms/ui/order_booking/order_booking_list/order_booking_tab.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class OrderBookingListScreen extends StatefulWidget {
  const OrderBookingListScreen({Key? key}) : super(key: key);

  @override
  _OrderBookingListScreenState createState() => _OrderBookingListScreenState();
}

class _OrderBookingListScreenState extends State<OrderBookingListScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  String selectedPrice = "";

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          orderBooking,
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
                    onPriceSelect: (price) {
                      selectedPrice = price;
                    },
                    selectedPrice: selectedPrice,
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const EditStoreScreen(),
                //   ),
                // );
              },
              color: MColor.colorSecondary,
              child: Row(
                children: const [
                  Text(
                    confirmSmall,
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
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: TextFormField(
                  style: const TextStyle(fontSize: 16),
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
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                color: const Color(0xffEDEDED),
                child: TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 4,
                  indicatorColor: MColor.colorPrimary,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 5),
                  tabs: [
                    Tab(
                      child: Text(
                        "Suggested",
                        style: Theme.of(context).textTheme.bodyText1!.merge(
                              TextStyle(
                                color:
                                    const Color(0xff303030).withOpacity(0.85),
                                letterSpacing: 0.67,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Scheme 1",
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                              TextStyle(
                                color:
                                    const Color(0xff303030).withOpacity(0.85),
                                letterSpacing: 0.67,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Tiny Tush",
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                              TextStyle(
                                color:
                                    const Color(0xff303030).withOpacity(0.85),
                                letterSpacing: 0.67,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          OrderBookingTab(index: 0),
          OrderBookingTab(index: 1),
          OrderBookingTab(index: 2)
        ],
      ),
    );
  }
}
