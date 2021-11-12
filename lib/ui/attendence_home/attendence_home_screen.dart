import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sfa/ui/absent/absent_screen.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_screen.dart';
import 'package:sfa/ui/attendence_clock_in_out/attendence_clock_in_out.dart';
import 'package:sfa/ui/attendence_home/filter_bloc/filter_bloc.dart';
import 'package:sfa/ui/attendence_home/filter_bloc/filter_state.dart';
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
  TextEditingController filterName = TextEditingController();
  String locationType = "";
  String locationName = "";
  FilterChangeListener? filterChangeListener;

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

                      if (status == "show") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddPjpScreen()));
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
                  ? const PJPScreen()
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

  void showFilters() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return BlocProvider<FilterBloc>(
          create: (context) => FilterBloc(),
          child: BlocListener<FilterBloc, FilterState>(
            listener: (context, state) {
              if (state is FilterSuccessState) {}
              if (state is FilterFailureState) {}
            },
            child: SingleChildScrollView(
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorGrayLite,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: DropdownButtonFormField(
                              dropdownColor: reportBG,
                              hint: const Text(
                                "Select Location Type",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: colorGray),
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent, width: 2.0),
                                ),
                              ),
                              items: <String>['City', 'State', 'District']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: colorGrayDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  value = value;
                                  locationType = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorGrayLite,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: DropdownButtonFormField(
                              dropdownColor: reportBG,
                              hint: const Text(
                                "Select Location",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: colorGray),
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent, width: 2.0),
                                ),
                              ),
                              items: <String>['City', 'State', 'District']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: colorGrayDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  value = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 14),
                          child: InkWell(
                            onTap: () {
                              filterChangeListener!.onFilterChange(
                                  filterName.text, locationType, locationName);

                              // BlocProvider.of<FilterBloc>(context)
                              //     .add(FilterEvent(locationType: typeValue!));
                              // Navigator.pop(context);
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

  getUserDetails() async {
    var leader =
        await SharedPrefrence.getBooleanPreference(SharedPrefrence.isLeader);
    setState(() {
      isLeader = leader;
    });
  }
}

abstract class FilterChangeListener {
  void onFilterChange(String name, String type, String location);
}
