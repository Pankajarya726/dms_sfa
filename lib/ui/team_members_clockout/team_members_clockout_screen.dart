import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sfa/ui/bottom_sheet/filter_model/filter_model.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_bloc.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_event.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_state.dart';
import 'package:sfa/ui/team_members/team_members_screen.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_bloc.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_events.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_states.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class TeamMembersClockoutScreen extends StatefulWidget {
  final Function(DateChangeListener dateChangeListener) onListenerInitialize;
  const TeamMembersClockoutScreen(
      {required this.onListenerInitialize, Key? key})
      : super(key: key);

  @override
  _TeamMembersClockoutScreenState createState() =>
      _TeamMembersClockoutScreenState();
}

class _TeamMembersClockoutScreenState extends State<TeamMembersClockoutScreen>
    implements DateChangeListener {
  bool clockInOut = false;
  GetClockInDataBloc getClockInDataBloc = GetClockInDataBloc();
  var format = DateFormat("yyyy-MM-dd");
  DateTime? dateTime = DateTime.now();
  String date = "";

  @override
  void initState() {
    widget.onListenerInitialize(this);
    super.initState();
    date = format.format(dateTime!);
    addClockInData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getClockInDataBloc,
      child: BlocConsumer<GetClockInDataBloc, GetClockInDataStates>(
        listener: (context, state) {
          if (state is ClockInApproveRejectSuccessState) {
            Fluttertoast.showToast(msg: state.res.message);
            addClockInData();
          }
          if (state is ClockInApproveRejectFailureState) {
            Fluttertoast.showToast(msg: state.message);
            addClockInData();
          }
        },
        builder: (context, state) {
          if (state is GetClockInDataLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetClockInDataSuccessState) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: state.getClockInDataResponse.data!.length,
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
                    onTap: () {},
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.getClockInDataResponse.data![index].name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          state.getClockInDataResponse.data![index].clockInTime,
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
                          buttonsApprove(
                              state.getClockInDataResponse.data![index].id,
                              state.getClockInDataResponse.data![index].userId,
                              colorGreen,
                              "Approve"),
                          const SizedBox(
                            width: 10,
                          ),
                          buttonsReject(
                              state.getClockInDataResponse.data![index].id,
                              state.getClockInDataResponse.data![index].userId,
                              colorRed,
                              "Reject"),
                          SizedBox(
                            width: 40,
                            child: IconButton(
                              onPressed: () {
                                showClockOutBottomSheet(
                                    state.getClockInDataResponse.data![index]
                                        .name,
                                    state
                                        .getClockInDataResponse.data![index].id,
                                    state.getClockInDataResponse.data![index]
                                        .userId,
                                    state.getClockInDataResponse.data![index]
                                        .inOutDate!);
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

          if (state is GetClockInDataFailureState) {
            return Center(
              child: Text(state.failureMessage),
            );
          }
          return Container();
        },
      ),
    );
  }

  showClockOutBottomSheet(
      String name, int id, int userId, DateTime date) async {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      builder: (context) {
        return StatusBottomSheet(
          name: name,
          id: id,
          userId: userId,
          date: date,
        );
      },
    ).then((value) => addClockInData());
  }

  Widget buttonsApprove(int id, int userId, color, text) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size.fromWidth(65),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
          BorderSide(color: color),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size.fromRadius(0),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        ),
      ),
      onPressed: () async {
        var approvedBy =
            await SharedPrefrence.getStringPreference(SharedPrefrence.id);
        getClockInDataBloc.add(ClockInApproveRejectEvent(
            id: id.toString(), status: "2", approvedBy: approvedBy.toString()));
      },
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }

  Widget buttonsReject(int id, int userId, color, text) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size.fromWidth(65),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
          BorderSide(color: color),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size.fromRadius(0),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        ),
      ),
      onPressed: () async {
        var approvedBy =
            await SharedPrefrence.getStringPreference(SharedPrefrence.id);
        getClockInDataBloc.add(ClockInApproveRejectEvent(
            id: id.toString(), status: "3", approvedBy: approvedBy.toString()));
      },
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }

  addClockInData() {
    // String date = format.format(dateTime!);
    getClockInDataBloc.add(
        GetClockInDataSuccessEvent(dateAdded: date, filterName: "Himanshu"));
  }

  @override
  void onDateChange(String date) {
    this.date = date;
    getClockInDataBloc.add(GetClockInDataSuccessEvent(dateAdded: date));
  }

  @override
  void onFilterSelect(FilterData location, String name, String locationType) {}
}

class StatusBottomSheet extends StatefulWidget {
  final String name;
  final int id;
  final int userId;
  final DateTime date;
  const StatusBottomSheet(
      {required this.name,
      required this.id,
      required this.userId,
      required this.date,
      Key? key})
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
                date: DateFormat("yyyy-MM-dd").format(widget.date),
                userId: widget.userId.toString()));
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
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: roundedButton(
                                      colorGreen, "Approve", widget.id, "2"),
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: roundedButton(
                                      colorPrimary, "Reject", widget.id, "3"),
                                ),
                              ],
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

  Widget roundedButton(buttonColor, buttonText, id, status) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          var approvedBy =
              await SharedPrefrence.getStringPreference(SharedPrefrence.id);

          getClockInDataBloc.add(ClockInApproveRejectEvent(
              id: id.toString(), status: status, approvedBy: approvedBy));
          Navigator.pop(context, true);
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width, 50)),
          backgroundColor: MaterialStateProperty.all(buttonColor),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
