import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sfa/listeners/date_change_listener.dart';
import 'package:sfa/ui/team_members_absent/bloc/team_members_absent_bloc.dart';
import 'package:sfa/ui/team_members_absent/bloc/team_members_absent_events.dart';
import 'package:sfa/ui/team_members_absent/bloc/team_members_absent_states.dart';
import 'package:sfa/utility/colors.dart';

class TeamMembersAbsentScreen extends StatefulWidget {
  final Function(DateChangeListener dateChangeListener) onListenerInitialize;
  final String passedDate;
  const TeamMembersAbsentScreen(
      {required this.passedDate, required this.onListenerInitialize, Key? key})
      : super(key: key);
  @override
  _TeamMembersAbsentScreenState createState() =>
      _TeamMembersAbsentScreenState();
}

class _TeamMembersAbsentScreenState extends State<TeamMembersAbsentScreen>
    implements DateChangeListener {
  TeamMembersAbsentBloc teamMembersAbsentBloc = TeamMembersAbsentBloc();
  String date = "";
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    widget.onListenerInitialize(this);
    date = widget.passedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => teamMembersAbsentBloc,
      child: Scaffold(
        body: SmartRefresher(
          primary: false,
          controller: refreshController,
          onRefresh: onRefresh,
          enablePullDown: true,
          child: BlocConsumer<TeamMembersAbsentBloc, TeamMembersAbsentStates>(
            listener: (context, state) {
              if (state is AbsentApproveSuccessState) {
                Fluttertoast.showToast(msg: state.successMessage);
                teamMembersAbsentBloc
                    .add(TeamMembersAbsentSuccessEvent(currentDate: date));
              }
            },
            builder: (context, state) {
              if (state is TeamMembersAbsentInitialState) {
                teamMembersAbsentBloc
                    .add(TeamMembersAbsentSuccessEvent(currentDate: date));

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is TeamMembersAbsentLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is TeamMembersAbsentSuccessState) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: state.getAbsentDataResponse.data!.length,
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
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
                              state.getAbsentDataResponse.data![index].name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              state.getAbsentDataResponse.data![index]
                                  .absentReason,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: colorLightBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        trailing: IntrinsicWidth(
                          child: Row(
                            children: [
                              buttonApprove(
                                state.getAbsentDataResponse.data![index].userId
                                    .toString(),
                                state.getAbsentDataResponse.data![index].id
                                    .toString(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              buttonReject(
                                state.getAbsentDataResponse.data![index].userId
                                    .toString(),
                                state.getAbsentDataResponse.data![index].id
                                    .toString(),
                              ),
                              SizedBox(
                                width: 40,
                                child: IconButton(
                                  onPressed: () {
                                    showAbsentBottomSheet(
                                      state.getAbsentDataResponse.data![index]
                                          .name,
                                      state.getAbsentDataResponse.data![index]
                                          .absentReason,
                                      state.getAbsentDataResponse.data![index]
                                          .userId
                                          .toString(),
                                      state
                                          .getAbsentDataResponse.data![index].id
                                          .toString(),
                                    );
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
              if (state is TeamMembersAbsentFailureState) {
                return Center(
                  child: Text(state.failureMessage),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void showAbsentBottomSheet(
      name, absentReason, userId, userAttendenceId) async {
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          name,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: colorPrimary,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Reason",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        absentReason,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff303030),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:
                                roundedApproveButton(userId, userAttendenceId),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child:
                                roundedRejectButton(userId, userAttendenceId),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget roundedApproveButton(userId, userAttendenceId) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          teamMembersAbsentBloc.add(
            AbsentApproveRejectEvent(
              userId: userId,
              absentStatus: "2",
              userAttendenceId: userAttendenceId,
            ),
          );
          Navigator.pop(context);
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width, 50)),
          backgroundColor: MaterialStateProperty.all(colorGreen),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: const Text(
          "Approve",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget roundedRejectButton(userId, userAttendenceId) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          teamMembersAbsentBloc.add(
            AbsentApproveRejectEvent(
              userId: userId,
              absentStatus: "3",
              userAttendenceId: userAttendenceId,
            ),
          );
          Navigator.pop(context);
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width, 50)),
          backgroundColor: MaterialStateProperty.all(colorRed),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: const Text(
          "Reject",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget buttonApprove(userId, userAttendenceId) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size.fromWidth(65),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
          const BorderSide(color: colorGreen),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size.fromRadius(0),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        ),
      ),
      onPressed: () {
        teamMembersAbsentBloc.add(
          AbsentApproveRejectEvent(
            userId: userId,
            absentStatus: "2",
            userAttendenceId: userAttendenceId,
          ),
        );
        // Navigator.pop(context);
      },
      child: const Text(
        "Approve",
        style: TextStyle(
          color: colorGreen,
        ),
      ),
    );
  }

  Widget buttonReject(userId, userAttendenceId) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size.fromWidth(65),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
          const BorderSide(color: colorRed),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size.fromRadius(0),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        ),
      ),
      onPressed: () {
        teamMembersAbsentBloc.add(
          AbsentApproveRejectEvent(
            userId: userId,
            absentStatus: "3",
            userAttendenceId: userAttendenceId,
          ),
        );
        // Navigator.pop(context);
      },
      child: const Text(
        "Reject",
        style: TextStyle(
          color: colorRed,
        ),
      ),
    );
  }

  @override
  void onDateChange(String date) {
    this.date = date;
    teamMembersAbsentBloc.add(TeamMembersAbsentSuccessEvent(currentDate: date));
  }

  @override
  void onFilterSelect(location, name, type) {
    teamMembersAbsentBloc.add(TeamMembersAbsentSuccessEvent(
        currentDate: date,
        filterName: name,
        locationType: type,
        location: location != null ? location.id : null));
  }

  void onRefresh() {
    teamMembersAbsentBloc.add(TeamMembersAbsentSuccessEvent(currentDate: date));
    refreshController.refreshCompleted();
  }
}
