import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sfa/listeners/date_change_listener.dart';
import 'package:sfa/listeners/pjp_data_changed_listener.dart';
import 'package:sfa/ui/absent/absent_screen.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_screen.dart';
import 'package:sfa/ui/attendence_clock_in_out/attendence_clock_in_out.dart';
import 'package:sfa/ui/bottom_sheet/filter_bottom_sheet.dart';
import 'package:sfa/ui/bottom_sheet/filter_model/filter_model.dart';
import 'package:sfa/ui/my_profile/my_profile_home.dart';
import 'package:sfa/ui/pjp_screen/pjp_screen.dart';
import 'package:sfa/ui/team_members/team_members_screen.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class AttendenceHomeScreen extends StatefulWidget {
  const AttendenceHomeScreen({Key? key}) : super(key: key);

  @override
  _AttendenceHomeScreenState createState() => _AttendenceHomeScreenState();
}

class _AttendenceHomeScreenState extends State<AttendenceHomeScreen> {
  int currentBottomTabIndex = 0;
  bool isLeader = false;
  String? filterName;
  String? locationType;
  FilterData? location;
  DateChangeListener? filterChangeListener;
  PjpDataChangeListener? pageLoadListener;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

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
                    onPressed: () async {
                      var status = await SharedPrefrence.getStringPreference(
                          SharedPrefrence.isEnable);

                      if (status != "show") {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddPjpScreen()))
                            .then((value) {
                          if (pageLoadListener != null) {
                            pageLoadListener!.onPageLoad(true);
                          }
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Add PJP is not available");
                      }
                    },
                  ),
                )
              : Container(),
        ],
      ),
      body: currentBottomTabIndex == 0
          ? const AttendenceClockInOut()
          : currentBottomTabIndex == 1
              ? const AbsentScreen()
              : currentBottomTabIndex == 3
                  ? PJPScreen(
                      pageLoad: (listener) {
                        pageLoadListener = listener;
                      },
                    )
                  : currentBottomTabIndex == 2
                      ? (isLeader == true
                          ? TeamMembersScreen(
                              onFilterListenerInitialize: (filterListener) {
                                filterChangeListener = filterListener;
                              },
                            )
                          : const MyProfileHome())
                      : Container(),
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
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: currentBottomTabIndex == 0
                  ? Image.asset(
                      "assets/f1-a.png",
                      fit: BoxFit.contain,
                      width: 22,
                    )
                  : Image.asset(
                      "assets/f1.png",
                      fit: BoxFit.contain,
                      width: 22,
                    ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: currentBottomTabIndex == 1
                  ? Image.asset(
                      "assets/f2-a.png",
                      fit: BoxFit.contain,
                      width: 22,
                    )
                  : Image.asset(
                      "assets/f2.png",
                      fit: BoxFit.contain,
                      width: 22,
                    ),
            ),
            label: "Absent",
          ),
          isLeader == true
              ? BottomNavigationBarItem(
                  icon: SizedBox(
                    width: 35,
                    height: 35,
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
                )
              : BottomNavigationBarItem(
                  icon: SizedBox(
                    width: 35,
                    height: 35,
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
                  label: "Profile",
                ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: currentBottomTabIndex == 3
                  ? Image.asset(
                      "assets/f4-a.png",
                      fit: BoxFit.contain,
                      width: 22,
                    )
                  : Image.asset(
                      "assets/f4.png",
                      fit: BoxFit.contain,
                      width: 22,
                    ),
            ),
            label: "PJP",
          ),
        ],
      ),
    );
  }

  showFilters() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return FilterBottomSheet(
          onSelect: (location, name, type) {
            if (filterChangeListener != null) {
              filterChangeListener!.onFilterSelect(location, name, type);
            }
          },
        );
      },
    );
  }

  void ontemTaped(int index) {
    setState(() {
      currentBottomTabIndex = index;
    });
  }

  getUserDetails() async {
    var leader =
        await SharedPrefrence.getBooleanPreference(SharedPrefrence.isLeader);
    setState(() {
      isLeader = leader;
    });
  }
}
