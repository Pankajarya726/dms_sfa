import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sfa/listeners/date_change_listener.dart';
import 'package:sfa/ui/bottom_sheet/filter_model/filter_model.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_bloc.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_event.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_state.dart';
import 'package:sfa/ui/team%20members_status/bloc/get_all_users_status_bloc.dart';
import 'package:sfa/ui/team%20members_status/bloc/get_all_users_status_events.dart';
import 'package:sfa/ui/team%20members_status/bloc/get_all_users_status_states.dart';
import 'package:sfa/ui/team_member_details/team_members_details.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_bloc.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/constants.dart';
import 'model/get_all_users_status.dart';

class TeamMembersStatusScreen extends StatefulWidget {
  final Function(DateChangeListener dateChangeListener)
      onDateListenerInitialize;

  const TeamMembersStatusScreen(
      {required this.onDateListenerInitialize, Key? key})
      : super(key: key);

  @override
  _TeamMembersStatusScreenState createState() =>
      _TeamMembersStatusScreenState();
}

class _TeamMembersStatusScreenState extends State<TeamMembersStatusScreen>
    implements DateChangeListener {
  GetAllUserStatusBloc getAllUserStatusBloc = GetAllUserStatusBloc();
  List<AttendanceStatusModel> statusList = [];
  var format = DateFormat("yyyy-MM-dd");
  DateTime? dateTime = DateTime.now();
  String date = "";
  String? locationType;
  String? locationName;
  String? filterName;

  @override
  void initState() {
    widget.onDateListenerInitialize(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getAllUserStatusBloc,
      child: BlocBuilder<GetAllUserStatusBloc, GetAllUserStatusStates>(
        builder: (context, state) {
          if (state is GetAllUserStatusInitialState) {
            date = format.format(dateTime!);
            getAllUserStatusBloc
                .add(GetAllUserStatusInitialEvent(statusDate: date));
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetAllUserStatusLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetAllUserStatusInitialSuccessState) {
            statusList = state.statusList;
          }
          if (state is GetAllUserStatusFailureState) {
            return Center(
              child: Text(state.failureMessage),
            );
          }
          if (statusList.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: statusList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.fromLTRB(15, 12, 0, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: -8,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    dense: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamMembersDetails(
                            userId: statusList[index].userId.toString(),
                            name: statusList[index].userName,
                          ),
                        ),
                      );
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusList[index].userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          statusList[index].status,
                          style: const TextStyle(
                            color: Color(0xff303030),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: IntrinsicWidth(
                      child: Row(
                        children: [
                          statusList[index].approveStatus == 1
                              ? statusAccepted()
                              : statusRejected(),
                          SizedBox(
                            width: 40,
                            child: IconButton(
                              onPressed: () {
                                showTeamMemberStatusSheet(
                                    statusList[index].userName,
                                    statusList[index].userId,
                                    date);
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.black,
                                size: 27,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if (statusList.isEmpty) {
            return const Center(
              child: Text("Data not found"),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget commonTextField(headingText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headingText,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        TextFormField(
          readOnly: true,
          maxLines: 3,
          initialValue: LOREUMIPSUM,
          keyboardType: TextInputType.text,
          style: const TextStyle(
            color: Color(0xff303030),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff555555)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Color(0xff555555),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget statusAccepted() {
    return SizedBox(
      width: 20,
      child: Image.asset(
        "assets/accept.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget statusRejected() {
    return SizedBox(
      width: 20,
      child: Image.asset(
        "assets/reject.png",
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  void onDateChange(String date) {
    this.date = date;
    getAllUserStatusBloc.add(GetAllUserStatusInitialEvent(statusDate: date));
  }

  showTeamMemberStatusSheet(String name, int userId, String date) async {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      builder: (context) {
        return StatusBottomSheet(
          name: name,
          userId: userId,
          date: date,
        );
      },
    );
  }

  @override
  void onFilterSelect(location, name, type) {
    filterName = name;
    locationType = type;
    if (location != null) {
      locationName = location.name;
    }

    getAllUserStatusBloc.add(GetAllUserStatusInitialEvent(
        statusDate: date,
        filterName: filterName,
        location: locationName,
        locationType: locationType));
  }
}

class StatusBottomSheet extends StatefulWidget {
  final String name;
  final int userId;
  final String date;
  const StatusBottomSheet(
      {required this.name, required this.userId, required this.date, Key? key})
      : super(key: key);

  @override
  _StatusBottomSheetState createState() => _StatusBottomSheetState();
}

class _StatusBottomSheetState extends State<StatusBottomSheet> {
  PjpByDateBloc pjpByDateBloc = PjpByDateBloc();
  GetClockInDataBloc getClockInDataBloc = GetClockInDataBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PjpByDateBloc>(
      create: (context) => pjpByDateBloc,
      child: BlocBuilder<PjpByDateBloc, PjpByDateState>(
        builder: (context, state) {
          if (state is PjpByDateInitialState) {
            pjpByDateBloc.add(PjpByDateEvent(
                date: widget.date, userId: widget.userId.toString()));
          }
          if (state is PjpByDateFailureState) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is PjpByDateLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is PjpByDateSuccessState) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                widget.name,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: colorPrimary,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 10.0, // soften the shadow
                                    spreadRadius: -1.5, //extend the shadow
                                    offset: Offset(
                                      0, // Move to right 10  horizontally
                                      0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                                gradient: state.response.data![0].clockOutTime
                                        .isNotEmpty
                                    ? const LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          colorPrimary,
                                          colorLightPrimary
                                        ],
                                      )
                                    : const LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [colorGreen, colorLightGreen],
                                      ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Log in: " +
                                            state.response.data![0].clockInTime
                                                .toString() +
                                            (state.response.data![0]
                                                    .clockOutTime.isNotEmpty
                                                ? " - Log out: " +
                                                    state.response.data![0]
                                                        .clockOutTime
                                                        .toString()
                                                : ""),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Text(
                                      "08:08:35",
                                      style: TextStyle(
                                        fontSize: 45.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                            width: 15,
                                            child: Image.asset(
                                                "assets/zone-clock.png"),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Flexible(
                                          flex: 20,
                                          child: Text(
                                            "Time zone in Indore, Madhya Pradesh, India (GMT+5:30)",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            commonTextField(
                                "PJP", state.response.data![0].pjpDescription),
                            const SizedBox(
                              height: 20,
                            ),
                            commonTextField("Working plan",
                                state.response.data![0].workingPlan),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget commonTextField(headingText, description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headingText,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        TextFormField(
          readOnly: true,
          maxLines: 3,
          initialValue: description,
          keyboardType: TextInputType.text,
          style: const TextStyle(
            color: Color(0xff303030),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff555555)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Color(0xff555555),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
