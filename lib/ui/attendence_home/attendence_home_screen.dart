import 'package:flutter/material.dart';
import 'package:sfa/ui/absent/absent_screen.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_screen.dart';
import 'package:sfa/ui/attendence_clock_in_out/attendence_clock_in_out.dart';
import 'package:sfa/ui/pjp_screen/pjp_screen.dart';
import 'package:sfa/ui/team_members/team_members_screen.dart';
import 'package:sfa/utility/colors.dart';

class AttendenceHomeScreen extends StatefulWidget {
  const AttendenceHomeScreen({Key? key}) : super(key: key);

  @override
  _AttendenceHomeScreenState createState() => _AttendenceHomeScreenState();
}

class _AttendenceHomeScreenState extends State<AttendenceHomeScreen> {
  int currentBottomTabIndex = 0;
  List<Widget> navigationScreens = [
    const AttendenceClockInOut(),
    const AbsentScreen(),
    const TeamMembersScreen(),
    const PJPScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: colorPrimary,
        title: currentBottomTabIndex == 0
            ? const Text("Attendence")
            : currentBottomTabIndex == 1
                ? const Text("Absent")
                : currentBottomTabIndex == 3
                    ? const Text("PJP")
                    : const Text("Team Members"),
        centerTitle: true,
        actions: [
          currentBottomTabIndex == 2
              ? IconButton(
                  onPressed: () {
                    showFilters();
                  },
                  icon: const Image(
                    fit: BoxFit.contain,
                    width: 23,
                    image: AssetImage("assets/filter.png"),
                  ),
                )
              : Container(),
          currentBottomTabIndex == 3
              ? Container()
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Image(
                    fit: BoxFit.contain,
                    width: 23,
                    image: AssetImage("assets/home.png"),
                  ),
                ),
          currentBottomTabIndex == 3
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: MaterialButton(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    color: Colors.white70,
                    elevation: 0,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/report.png",
                          width: 15,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Add PJP",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddPjpScreen()));
                    },
                  ),
                )
              : Container(),
        ],
      ),
      body: navigationScreens[currentBottomTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 15,
        unselectedFontSize: 15,
        selectedItemColor: colorPrimary,
        showUnselectedLabels: true,
        unselectedItemColor: colorGrayDark,
        currentIndex: currentBottomTabIndex,
        type: BottomNavigationBarType.fixed,
        onTap: ontemTaped,
        elevation: 20,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              // width: 26,
              // height: 30,
              child: currentBottomTabIndex == 0
                  ? Image.asset(
                      "assets/f1-a.png",
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      "assets/f1.png",
                      fit: BoxFit.contain,
                    ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              // width: 26,
              child: currentBottomTabIndex == 1
                  ? Image.asset(
                      "assets/f2-a.png",
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      "assets/f2.png",
                      fit: BoxFit.contain,
                    ),
            ),
            label: "Absent",
          ),
          BottomNavigationBarItem(
            icon: Container(
              // width: 26,
              // height: 30,
              child: currentBottomTabIndex == 2
                  ? Image.asset(
                      "assets/f3-a.png",
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      "assets/f3.png",
                      fit: BoxFit.contain,
                    ),
            ),
            label: "Team",
          ),
          BottomNavigationBarItem(
            icon: Container(
              // width: 26,
              // height: 30,
              child: currentBottomTabIndex == 3
                  ? Image.asset(
                      "assets/f4-a.png",
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      "assets/f4.png",
                      fit: BoxFit.contain,
                    ),
            ),
            label: "PJP",
          ),
        ],
      ),
    );
  }

  void showFilters() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: reportBG,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Filter",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: colorGrayDark,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                      child: TextFormField(
                        style: const TextStyle(
                            color: colorGrayDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                        autocorrect: true,
                        enableSuggestions: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: colorGrayLite,
                          hintText: "Name",
                          prefixText: "   ",
                          hintStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: colorGray),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: TextFormField(
                        style: const TextStyle(
                            color: colorGrayDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                        autocorrect: true,
                        enableSuggestions: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: colorGrayLite,
                          hintText: "Designation",
                          prefixText: "   ",
                          hintStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: colorGray),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: TextFormField(
                        style: const TextStyle(
                            color: colorGrayDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                        autocorrect: true,
                        enableSuggestions: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: colorGrayLite,
                          hintText: "Location",
                          prefixText: "   ",
                          hintStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: colorGray),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 14),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 180,
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void ontemTaped(int index) {
    setState(() {
      currentBottomTabIndex = index;
    });
  }
}
