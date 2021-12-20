import 'package:dms/ui/add_plan/add_plan_screen.dart';
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
  List<DateTime> months = [];
  String selectedWeek = "week 1";
  List<String> weeks = [
    "week 1",
    "week 2",
    "week 3",
    "week 4",
    "week 5",
    "week 6",
  ];
  DateTime? dateTime;
  String shortMonth = "";
  String date = "";
  String day = "";
  String week = "";

  @override
  void initState() {
    super.initState();
    getTabs();
  }

  @override
  Widget build(BuildContext context) {
    var _tabBar = TabBar(
      indicatorWeight: 3,
      isScrollable: true,
      indicatorColor: MColor.tabIndicatorColor,
      unselectedLabelColor: MColor.backButton,
      labelColor: MColor.backButton,
      labelStyle: const TextStyle(
        fontSize: 18,
        letterSpacing: 0.67,
        fontWeight: FontWeight.w500,
      ),
      tabs: List.generate(months.length, (index) {
        return Tab(
          text: DateFormat("MMMM").format(months[index]).toString(),
        );
      }),
    );
    return DefaultTabController(
      length: months.length,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: const Color(0xffFAFAFA),
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
              Icons.arrow_back_ios,
              color: MColor.backButton,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 13, 17, 14),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(MColor.colorSecondary),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPlanScreen(),
                    ),
                  );
                },
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
          children: List.generate(months.length, (index) {
            return tabsLayout();
          }),
        ),
      ),
    );
  }

  Widget tabsLayout() {
    return Column(
      children: [
        Container(
          color: const Color(0xffFAFAFA),
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: SizedBox(
            height: 35,
            width: MediaQuery.of(context).size.width,
            child: Tags(
              spacing: 0,
              itemCount: weeks.length,
              alignment: WrapAlignment.spaceBetween,
              horizontalScroll: true,
              itemBuilder: (index) {
                return Padding(
                  padding: index == 0
                      ? const EdgeInsets.fromLTRB(17, 0, 6, 0)
                      : weeks.last == weeks[index]
                          ? const EdgeInsets.fromLTRB(6, 0, 17, 0)
                          : const EdgeInsets.fromLTRB(6, 0, 6, 0),
                  child: ItemTags(
                    singleItem: true,
                    onPressed: (item) {
                      selectedWeek = item.title!;
                      setState(() {});
                    },
                    active: selectedWeek == weeks[index] ? true : false,
                    title: weeks[index],
                    textActiveColor: Colors.black,
                    textColor: const Color(0xff555555),
                    elevation: 0,
                    textStyle: const TextStyle(fontSize: 16),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    index: index,
                    border: Border.all(
                        color: selectedWeek == weeks[index]
                            ? MColor.colorPrimary
                            : Colors.grey),
                    colorShowDuplicate: Colors.grey,
                    activeColor: const Color(0xFFFFC9CC),
                    color: const Color(0xffFAFAFA),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(17, 6, 17, 15),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 15,
                );
              },
              itemCount: 7,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          context: context,
                          builder: (context) {
                            return const MyPlanBottomSheet();
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
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
                                      letterSpacing: 0.67,
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd').format(DateTime.now()),
                                    style: const TextStyle(
                                      letterSpacing: 0.67,
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('E').format(DateTime.now()),
                                    style: const TextStyle(
                                      letterSpacing: 0.67,
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(
                              height: 100,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Retailing",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        letterSpacing: 0.67,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: MColor.backButton,
                                      ),
                                    ),
                                    Text(
                                      "Vijay nagar",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        letterSpacing: 0.67,
                                        overflow: TextOverflow.ellipsis,
                                        color: Color(0xff555555),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      loremIpsum,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        letterSpacing: 0.67,
                                        overflow: TextOverflow.ellipsis,
                                        color: Color(0xff555555),
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

  void getTabs() {
    debugPrint((DateFormat("MMMM").format(DateTime(
            DateTime.now().year, DateTime.now().month - 6, DateTime.now().day)))
        .toString());
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    debugPrint("${lastDayOfMonth.month}/${lastDayOfMonth.day}");

    months.add(DateTime(now.year, now.month - 6, now.day));
    months.add(DateTime(now.year, now.month - 5, now.day));
    months.add(DateTime(now.year, now.month - 4, now.day));
    months.add(DateTime(now.year, now.month - 3, now.day));
    months.add(DateTime(now.year, now.month - 2, now.day));
    months.add(DateTime(now.year, now.month - 1, now.day));
    months.add(DateTime(now.year, now.month, now.day));
    months.add(DateTime(now.year, now.month + 1, now.day));
    setState(() {});

    debugPrint("months -> $months");
  }

// void getDateAndTime() {
//   // (DateTime(dateTime!.year, dateTime!.month, dateTime!.day - 1))
//   int currentMonth = int.parse(DateFormat("M").format(DateTime.now()));
//   List<String> month = ["", "", "", "", "", "", "", ""];
//   for (int i = currentMonth - 1; i <= currentMonth; i++) {
//     month[i] = (DateFormat("M").format(DateTime.now())).toString();
//     print("months = $currentMonth");
//   }
// }
}

class MyPlanBottomSheet extends StatefulWidget {
  const MyPlanBottomSheet({Key? key}) : super(key: key);

  @override
  _MyPlanBottomSheetState createState() => _MyPlanBottomSheetState();
}

class _MyPlanBottomSheetState extends State<MyPlanBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                height: 10,
              ),
              Text(
                "Info",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Retailing",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  letterSpacing: 0.67,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MColor.backButton,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Vijay nagar",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  letterSpacing: 0.67,
                  overflow: TextOverflow.ellipsis,
                  color: Color(0xff555555),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                loremIpsum,
                style: TextStyle(
                  letterSpacing: 0.67,
                  color: Color(0xff555555),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
