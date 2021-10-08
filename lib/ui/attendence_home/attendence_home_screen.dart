import 'package:flutter/material.dart';
import 'package:sfa/ui/absent/absent_screen.dart';
import 'package:sfa/ui/attendence_clock_in_out/attendence_clock_in_out.dart';
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
    const TeamMembersScreen()
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
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Image(
              fit: BoxFit.contain,
              width: 23,
              image: AssetImage("assets/home.png"),
            ),
          )
        ],
      ),
      body: navigationScreens[currentBottomTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBottomTabIndex,
        onTap: ontemTaped,
        elevation: 20,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: "Absent",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Team",
          )
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
