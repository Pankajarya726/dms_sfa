import 'package:dms/ui/my_performance/perfromance_tab.dart';
import 'package:dms/ui/team_performance/bloc/team_performance_event.dart';
import 'package:dms/ui/team_performance/model/get_team_performance_response.dart';
import 'package:dms/ui/team_performance/team_performance_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'bloc/team_performance_bloc.dart';
import 'bloc/team_performance_state.dart';

class TeamPerformanceTab extends StatefulWidget {
  final int index;
  final String type;
  final TeamPerformanceBloc bloc;
  final String title;
  final String userId;
  final DateTime dateTime;
  final Function(OnDateChangeListener listener) init;
  const TeamPerformanceTab(
      {Key? key,
      required this.index,
      required this.bloc,
      required this.type,
      required this.userId,
      this.title = "Team Report",
      required this.init,
      required this.dateTime})
      : super(key: key);

  @override
  State<TeamPerformanceTab> createState() => _TeamPerformanceTabState();
}

class _TeamPerformanceTabState extends State<TeamPerformanceTab> with OnDateChangeListener {
  DateTime dateTime = DateTime.now();
  TeamPerformance? performance;

  @override
  void initState() {
    widget.init(this);
    dateTime = widget.dateTime;
    widget.bloc.add(GetPerformanceEvent(date: DateFormat("yyyy-MM-dd").format(dateTime), type: widget.type, userId: widget.userId));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TeamPerformanceTab oldWidget) {
    debugPrint("didUpdateWidget--->$dateTime");
    debugPrint("didUpdateWidget--->${widget.index}");
    debugPrint("didUpdateWidget--->${oldWidget.index}");
    dateTime = widget.dateTime;
    widget.bloc.add(GetPerformanceEvent(date: DateFormat("yyyy-MM-dd").format(dateTime), type: widget.type, userId: widget.userId));
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamPerformanceBloc, TeamPerformanceState>(
      bloc: widget.bloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TeamPerformanceLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetTeamPerformanceState) {
          performance = state.performance;
        }
        if (performance == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetTeamPerformanceFailureState) {
          return Center(
            child: Text(state.msg),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Co-Workers:  ",
                        style: GoogleFonts.roboto(color: MColor.inactiveTextColor, fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      TextSpan(
                        text: performance!.coWorker,
                        style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                      )
                    ]),
                  ),
                  widget.index == 0
                      ? Row(
                          children: [
                            const Image(
                              image: AssetImage("assets/date.png"),
                              width: 20,
                              height: 20,
                            ),
                            Text(
                              DateFormat("dd-MM-yyyy").format(dateTime),
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    height: MediaQuery.of(context).size.width / 2 - 15,
                    child: CircularPercentIndicator(
                      circularStrokeCap: CircularStrokeCap.butt,
                      radius: (MediaQuery.of(context).size.width / 2 - 30) / 2,
                      lineWidth: 18.0,
                      percent: double.parse(performance!.conversion) / 100,
                      backgroundColor: Colors.grey.shade200,
                      backgroundWidth: 16,

                      center: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: "${performance!.conversion}%\n",
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25)),
                            const TextSpan(
                                text: "Conversion",
                                style: TextStyle(color: Color(0xff555555), fontWeight: FontWeight.w500, fontSize: 18))
                          ])),
                      // progressColor: MColor.colorPrimary,
                    ),
                  ),
                  SizedBox(
                    // width: MediaQuery.of(context).size.width / 2 - 15,
                    height: MediaQuery.of(context).size.width / 2 - 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff4E54EE),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  const TextSpan(
                                      text: "TC: ",
                                      style: TextStyle(color: Color(0xff555555), fontWeight: FontWeight.w500, fontSize: 15)),
                                  TextSpan(
                                      text: performance!.totalCall,
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15))
                                ]))
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff42DA48),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  const TextSpan(
                                      text: "PC: ",
                                      style: TextStyle(color: Color(0xff555555), fontWeight: FontWeight.w500, fontSize: 15)),
                                  TextSpan(
                                      text: performance!.totalProductive,
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15))
                                ]))
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffBE55E3),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 30,
                              child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(children: [
                                    const TextSpan(
                                        text: "Total Sale: ",
                                        style: TextStyle(color: Color(0xff555555), fontWeight: FontWeight.w500, fontSize: 15)),
                                    TextSpan(
                                        text: performance!.totalSale,
                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15))
                                  ])),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffFB8F53),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 30,
                              child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(children: [
                                    const TextSpan(
                                        text: "Avg Value: ",
                                        style: TextStyle(color: Color(0xff555555), fontWeight: FontWeight.w500, fontSize: 15)),
                                    TextSpan(
                                        text: performance!.averageValue,
                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15))
                                  ])),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2)]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.index == 0 ? "Present Day" : "Present Days",
                          style: const TextStyle(color: MColor.inactiveTextColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.index == 0 ? performance!.presentDays : performance!.presentDays + "%",
                          style: const TextStyle(color: MColor.colorSecondary, fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2)]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Enrollment",
                          style: TextStyle(color: MColor.inactiveTextColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          performance!.totalEnrollment,
                          style: const TextStyle(color: MColor.textColor, fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2)]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Pending Task",
                          style: TextStyle(color: MColor.inactiveTextColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          performance!.pendingTask,
                          style: const TextStyle(color: MColor.textColor, fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2)]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Completed Task",
                          style: TextStyle(color: MColor.inactiveTextColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          performance!.completedTask,
                          style: const TextStyle(color: MColor.textColor, fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Team List",
                style: GoogleFonts.roboto(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TeamPerformanceScreen(title: widget.title, userId: performance!.teamMember[index].userId)));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2)]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            performance!.teamMember[index].name,
                            style: GoogleFonts.roboto(color: const Color(0xff303030), fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            performance!.teamMember[index].designation,
                            style: GoogleFonts.roboto(color: MColor.textColor, fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: performance!.teamMember.length,
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void onDateSelect(DateTime date) {
    dateTime = date;
    widget.bloc.add(GetPerformanceEvent(date: DateFormat("yyyy-MM-dd").format(dateTime), type: widget.type, userId: widget.userId));
  }
}
