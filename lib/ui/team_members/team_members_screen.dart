import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sfa/listeners/date_change_listener.dart';
import 'package:sfa/ui/bottom_sheet/filter_model/filter_model.dart';

import 'package:sfa/ui/report_screen/report_screen.dart';
import 'package:sfa/ui/team%20members_status/team_members_status_screen.dart';
import 'package:sfa/ui/team_members/bloc/team_member_events.dart';
import 'package:sfa/ui/team_members/bloc/team_member_states.dart';
import 'package:sfa/ui/team_members/bloc/team_members_bloc.dart';
import 'package:sfa/ui/team_members_absent/team_members_absent_screen.dart';
import 'package:sfa/ui/team_members_clockout/team_members_clockout_screen.dart';
import 'package:sfa/utility/colors.dart';

class TeamMembersScreen extends StatefulWidget {
  final Function(DateChangeListener dateChangeListener)
      onFilterListenerInitialize;
  const TeamMembersScreen({required this.onFilterListenerInitialize, Key? key})
      : super(key: key);

  @override
  _TeamMembersScreenState createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  var initialFormat = DateFormat("dd MMM yyyy");
  var changeFormat = DateFormat("yyyy-MM-dd");
  DateTime? dateTime = DateTime.now();
  String initialDate = "";
  String changeDate = "";
  DateChangeListener? dateListener;
  TeamMembersBloc teamMembersBloc = TeamMembersBloc();
  String? locationType;
  String? locationName;
  String? filterName;

  @override
  void initState() {
    super.initState();
    changeDate = changeFormat.format(dateTime!);
  }

  @override
  Widget build(BuildContext context) {
    initialDate = initialFormat.format(dateTime!);
    final TabBar _tabBar = TabBar(
      labelColor: Colors.white,
      indicatorColor: colorPrimary,
      unselectedLabelColor: colorPrimary,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: colorPrimary,
      ),
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      tabs: const [
        Tab(
          text: "Status",
        ),
        Tab(
          text: "Clock-in",
        ),
        Tab(
          text: "Absent",
        ),
      ],
    );

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        backgroundColor: reportBG,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: colorPrimary,
          title: const Text("Team Members"),
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocProvider(
                  create: (context) => teamMembersBloc,
                  child: BlocBuilder<TeamMembersBloc, TeamMemberStates>(
                    builder: (context, state) {
                      if (state is TeamMembersInitialState) {
                        teamMembersBloc.add(TeamMemberInitialSuccessEvent());
                      }
                      if (state is TeamMembersInitialSuccessState) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now());
                                initialDate = initialFormat.format(dateTime!);
                                changeDate = changeFormat.format(dateTime!);
                                if (dateListener != null) {
                                  dateListener!.onDateChange(changeDate);
                                }
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  const Image(
                                    fit: BoxFit.contain,
                                    width: 20,
                                    height: 20,
                                    image: AssetImage(
                                      "assets/calendar.png",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    initialDate,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                dateTime = DateTime(dateTime!.year,
                                    dateTime!.month, dateTime!.day - 1);
                                initialDate = initialFormat.format(dateTime!);
                                changeDate = changeFormat.format(dateTime!);
                                if (dateListener != null) {
                                  dateListener!.onDateChange(changeDate);
                                }
                                setState(() {});
                              },
                              child: Image.asset(
                                "assets/3x/icon_previous.png",
                                width: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                if (DateTime.now().day == dateTime!.day &&
                                    DateTime.now().month == dateTime!.month &&
                                    DateTime.now().year == dateTime!.year) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "You can't select date before today");
                                } else {
                                  dateTime = DateTime(dateTime!.year,
                                      dateTime!.month, dateTime!.day + 1);
                                  initialDate = initialFormat.format(dateTime!);
                                  changeDate = changeFormat.format(dateTime!);
                                }

                                if (dateListener != null) {
                                  dateListener!.onDateChange(changeDate);
                                }
                                setState(() {});
                              },
                              child: Image.asset(
                                "assets/3x/icon_next.png",
                                width: 25,
                              ),
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                MaterialButton(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
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
                        "Report",
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
                        builder: (context) => const ReportScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            // preferredSize: _tabBar.preferredSize,
            preferredSize: const Size.fromHeight(62),
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xfff7f7f7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Material(
                color: colorTabBG,
                child: _tabBar,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            TeamMembersStatusScreen(
              passedDate: changeDate,
              onDateListenerInitialize: (dateChangeListener) {
                dateListener = dateChangeListener;
                widget.onFilterListenerInitialize(dateListener!);
              },
            ),
            TeamMembersClockoutScreen(
              passedDate: changeDate,
              onListenerInitialize: (dateChangeListener) {
                dateListener = dateChangeListener;
                widget.onFilterListenerInitialize(dateListener!);
              },
            ),
            TeamMembersAbsentScreen(
              passedDate: changeDate,
              onListenerInitialize: (dateChangeListener) {
                dateListener = dateChangeListener;
                widget.onFilterListenerInitialize(dateListener!);
              },
            )
          ],
        ),
      ),
    );
  }
}
