import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sfa/ui/absent/bloc/absent_bloc.dart';
import 'package:sfa/ui/absent/bloc/absent_events.dart';
import 'package:sfa/ui/absent/bloc/absent_states.dart';
import 'package:sfa/utility/colors.dart';

class AbsentScreen extends StatefulWidget {
  const AbsentScreen({Key? key}) : super(key: key);

  @override
  State<AbsentScreen> createState() => _AbsentScreenState();
}

class _AbsentScreenState extends State<AbsentScreen> {
  TextEditingController absentReason = TextEditingController();
  AbsentBloc absentBloc = AbsentBloc();
  bool clockInOutData = false;
  int clockInStatus = 0;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      primary: false,
      controller: refreshController,
      onRefresh: onRefresh,
      enablePullDown: true,
      child: BlocProvider<AbsentBloc>(
        create: (context) => absentBloc,
        child: BlocListener<AbsentBloc, AbsentStates>(
          listener: (context, state) {
            if (state is AbsentSuccessState) {
              Fluttertoast.showToast(
                  msg: state.markAbsentByUserResponse.message);
              absentBloc.add(AbsentInitialEvent());
            }
            if (state is AbsentFailureState) {
              Fluttertoast.showToast(msg: state.failureMessage);
            }
          },
          child: BlocBuilder<AbsentBloc, AbsentStates>(
            builder: (context, state) {
              if (state is AbsentLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is AbsentNetworkFailureState) {
                return Center(
                  child: Text(state.failureMessage),
                );
              }
              if (state is AbsentInitialState) {
                absentBloc.add(AbsentInitialEvent());
              }
              if (state is AbsentInitialSuccessState) {
                if (state.userData.data!.clockInOutData.isNotEmpty) {
                  clockInOutData = true;
                  clockInStatus =
                      state.userData.data!.clockInOutData.first.inOutStatus;
                  if (state.userData.data!.clockInOutData.first.absentReason
                      .isNotEmpty) {
                    absentReason = TextEditingController(
                        text: state
                            .userData.data!.clockInOutData.first.absentReason);
                  }
                } else {
                  clockInOutData = false;
                }
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Reason",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    TextFormField(
                      onTap: () {
                        if (clockInStatus == 3) {
                          Fluttertoast.showToast(msg: "Already marked absent");
                        } else if (clockInStatus == 2) {
                          Fluttertoast.showToast(msg: "Already clocked out");
                        } else if (clockInStatus == 1) {
                          Fluttertoast.showToast(msg: "Already clock in");
                        }
                      },
                      maxLines: 4,
                      readOnly: clockInOutData ? true : false,
                      enableInteractiveSelection: clockInOutData ? false : true,
                      controller: absentReason,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        color: Color(0xff303030),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: clockInOutData == false
                            ? const UnderlineInputBorder(
                                borderSide: BorderSide(color: colorPrimary),
                              )
                            : const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xff555555),
                                ),
                              ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xff555555),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (clockInOutData) {
                            if (clockInStatus == 3) {
                              Fluttertoast.showToast(
                                  msg: "Already marked absent");
                            } else if (clockInStatus == 2) {
                              Fluttertoast.showToast(
                                  msg: "Already clocked out");
                            } else if (clockInStatus == 1) {
                              Fluttertoast.showToast(msg: "Already clock in");
                            }
                          } else {
                            absentBloc.add(AbsentSuccessEvent(
                                absentReason: absentReason.text));
                          }
                        },
                        style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(const Size(180, 50)),
                          backgroundColor:
                              MaterialStateProperty.all(colorPrimary),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void onRefresh() {
    absentBloc.add(AbsentInitialEvent());
    refreshController.refreshCompleted();
  }
}
