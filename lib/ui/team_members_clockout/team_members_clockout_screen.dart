import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_bloc.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_events.dart';
import 'package:sfa/ui/team_members_clockout/bloc/get_clock_in_data_states.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/constants.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class TeamMembersClockoutScreen extends StatefulWidget {
  const TeamMembersClockoutScreen({Key? key}) : super(key: key);

  @override
  _TeamMembersClockoutScreenState createState() =>
      _TeamMembersClockoutScreenState();
}

class _TeamMembersClockoutScreenState extends State<TeamMembersClockoutScreen> {
  bool clockInOut = false;
  GetClockInDataBloc getClockInDataBloc = GetClockInDataBloc();
  @override
  void initState() {
    super.initState();
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
                          state.getClockInDataResponse.data![index].inOutTime,
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
                              colorGreen,
                              "Approve"),
                          const SizedBox(
                            width: 10,
                          ),
                          buttonsReject(
                              state.getClockInDataResponse.data![index].id,
                              colorRed,
                              "Reject"),
                          SizedBox(
                            width: 40,
                            child: IconButton(
                              onPressed: () {
                                showClockOutBottomSheet();
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

  void showClockOutBottomSheet() async {
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Oliver",
                          textAlign: TextAlign.left,
                          style: TextStyle(
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
                          gradient: clockInOut == true
                              ? const LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [colorPrimary, colorLightPrimary],
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
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Log in: 10:00 AM - Log out: 6:00 PM",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
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
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                      child:
                                          Image.asset("assets/zone-clock.png"),
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
                      commonTextField("PJP"),
                      const SizedBox(
                        height: 20,
                      ),
                      commonTextField("Working plan"),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: roundedButton(colorGreen, "Approve"),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            flex: 3,
                            child: roundedButton(colorPrimary, "Reject"),
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

  Widget roundedButton(buttonColor, buttonText) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
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

  Widget buttonsApprove(int id, color, text) {
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

  Widget buttonsReject(int id, color, text) {
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
    getClockInDataBloc.add(GetClockInDataSuccessEvent(dateAdded: "2021-10-21"));
  }
}
