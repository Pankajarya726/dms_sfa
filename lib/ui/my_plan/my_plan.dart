import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:intl/intl.dart';

class MyPlan extends StatefulWidget {
  const MyPlan({Key? key}) : super(key: key);

  @override
  _MyPlanState createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlan> {
  List<String> montsName = [
    january,
    february,
    march,
    april,
    may,
    june,
    july,
    august,
    september,
    october,
    november,
    december
  ];
  String selectedPrimaryTag = "week 1";
  String selectedSecondaryTag = "";
  List<String> primaryTags = [
    "week 1",
    "week 2",
    "week 3",
    "week 4",
    "week 2",
    "week 3",
    "week 4",
  ];
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var _tabBar = const TabBar(
      indicatorWeight: 4,
      isScrollable: true,
      indicatorColor: MColor.tabIndicatorColor,
      unselectedLabelColor: MColor.backButton,
      labelColor: MColor.backButton,
      labelStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      tabs: [
        Tab(
          text: january,
        ),
        Tab(
          text: february,
        ),
        Tab(
          text: march,
        ),
        Tab(
          text: april,
        ),
        Tab(
          text: may,
        ),
        Tab(
          text: june,
        ),
        Tab(
          text: july,
        ),
        Tab(
          text: august,
        ),
      ],
    );
    return DefaultTabController(
      length: 8,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            myPlan,
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
              Icons.arrow_back_ios_new,
              color: MColor.backButton,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(MColor.colorSecondary),
                ),
                onPressed: () {},
                child: const Text(
                  addCaps,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            child: Container(
              color: const Color(0xFFEDEDED),
              child: _tabBar,
            ),
            preferredSize: const Size.fromHeight(50),
          ),
        ),
        body: TabBarView(
          children: [
            tabsLayout(),
            tabsLayout(),
            tabsLayout(),
            tabsLayout(),
            tabsLayout(),
            tabsLayout(),
            tabsLayout(),
            tabsLayout(),
          ],
        ),
      ),
    );
  }

  Widget tabsLayout() {
    return Column(
      children: [
        Tags(
          itemCount: 7,
          alignment: WrapAlignment.spaceBetween,
          horizontalScroll: true,
          itemBuilder: (index) {
            return ItemTags(
              singleItem: true,
              onPressed: (item) {
                selectedPrimaryTag = item.title!;
                setState(() {});
              },
              active: selectedPrimaryTag == primaryTags[index] ? true : false,
              title: primaryTags[index],
              textActiveColor: Colors.black,
              textColor: const Color(0xff555555),
              elevation: 0,
              textStyle: const TextStyle(fontSize: 16),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              index: index,
              border: Border.all(
                  color: selectedPrimaryTag == primaryTags[index]
                      ? MColor.colorPrimary
                      : Colors.grey),
              colorShowDuplicate: Colors.grey,
              activeColor: const Color(0xFFFFC9CC),
              color: const Color(0xffFAFAFA),
            );
          },
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: MColor.dateBoxColor,
                              height: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    DateFormat('MMM').format(DateTime.now()),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd').format(DateTime.now()),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('E').format(DateTime.now()),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              height: 100,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Retailing",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Vijay nagar",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Color(0xff303030),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Loream ipsum sample text to show",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Color(0xff303030),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
