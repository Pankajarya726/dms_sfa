import 'package:dms/ui/my_performance/bloc/my_performance_bloc.dart';
import 'package:dms/ui/my_performance/bloc/my_performance_event.dart';
import 'package:dms/ui/my_performance/bloc/my_performance_state.dart';
import 'package:dms/ui/my_performance/model/get_my_performance_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PerformanceTab extends StatefulWidget {
  final int index;
  final String type;
  final MyPerformanceBloc bloc;

  const PerformanceTab({Key? key, required this.index, required this.bloc, required this.type}) : super(key: key);

  @override
  State<PerformanceTab> createState() => _PerformanceTabState();
}

class _PerformanceTabState extends State<PerformanceTab> with AutomaticKeepAliveClientMixin {
  DateTime dateTime = DateTime.now();
  MyPerformance? performance;

  @override
  void initState() {
    widget.bloc.add(GetPerformanceEvent(date: DateFormat("yyyy-MM-dd").format(dateTime), type: widget.type));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MyPerformanceBloc, MyPerformanceState>(
      bloc: widget.bloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MyPerformanceLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetMyPerformanceState) {
          performance = state.performance;
        }
        if (performance == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetMyPerformanceFailureState) {
          return Center(
            child: Text(state.msg),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              widget.index == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Image(
                              image: AssetImage("assets/date.png"),
                              width: 20,
                              height: 20,
                            ),
                            Text(
                              "Date",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                            )
                          ],
                        ),
                        Text(
                          DateFormat("dd-MM-yyyy").format(dateTime),
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                        )
                      ],
                    )
                  : Container(),
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
                        const Text(
                          "Present Days",
                          style: TextStyle(color: MColor.inactiveTextColor, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          performance!.presentDays,
                          style: const TextStyle(color: MColor.colorSecondary, fontSize: 20, fontWeight: FontWeight.bold),
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
                          style: TextStyle(color: MColor.inactiveTextColor, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          performance!.totalEnrollment,
                          style: const TextStyle(color: MColor.textColor, fontSize: 20, fontWeight: FontWeight.bold),
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
                          style: TextStyle(color: MColor.inactiveTextColor, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          performance!.pendingTask,
                          style: const TextStyle(color: MColor.textColor, fontSize: 20, fontWeight: FontWeight.bold),
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
                          style: TextStyle(color: MColor.inactiveTextColor, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          performance!.completedTask,
                          style: const TextStyle(color: MColor.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}
