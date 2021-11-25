import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sfa/listeners/pjp_data_changed_listener.dart';
import 'package:sfa/ui/pjp_screen/pjp_bloc/pjp_bloc.dart';
import 'package:sfa/ui/pjp_screen/pjp_bloc/pjp_event.dart';
import 'package:sfa/ui/pjp_screen/pjp_bloc/pjp_state.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class PJPScreen extends StatefulWidget {
  final Function(PjpDataChangeListener isPageLoad) pageLoad;
  const PJPScreen({Key? key, required this.pageLoad}) : super(key: key);

  @override
  _PJPScreenState createState() => _PJPScreenState();
}

class _PJPScreenState extends State<PJPScreen>
    implements PjpDataChangeListener {
  PjpBloc pjpBloc = PjpBloc();
  TextEditingController controller = TextEditingController();
  DateTime dateTime = DateTime.now();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  initState() {
    widget.pageLoad(this);
    super.initState();
    getPjp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PjpBloc>(
      create: (context) => pjpBloc,
      child: BlocListener<PjpBloc, PjpState>(
        listener: (context, state) {
          if (state is UpdateFailureState) {
            Fluttertoast.showToast(msg: state.message);
          }
          if (state is UpdateSuccessState) {
            Fluttertoast.showToast(msg: state.response.message);
          }
          if (state is DateSelectState) {
            dateTime = state.dateTime;
            getPjp();
          }
          if (state is DateIncrementState) {
            dateTime = state.dateTime;
            getPjp();
          }
          if (state is DateDecrementState) {
            dateTime = state.dateTime;
            getPjp();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SmartRefresher(
            primary: false,
            controller: refreshController,
            onRefresh: onRefresh,
            enablePullDown: true,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              datePicker();
                            },
                            child: SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/calendar.png",
                                    width: 22,
                                    height: 22,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  BlocBuilder<PjpBloc, PjpState>(
                                      builder: (context, state) {
                                    return Text(
                                      DateFormat("MMM yyyy").format(dateTime),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.18,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    dateTime = DateTime(dateTime.year,
                                        dateTime.month - 1, dateTime.day);
                                    pjpBloc.add(
                                        DateDecrementEvent(dateTime: dateTime));
                                  },
                                  child: Image.asset(
                                    "assets/2x/icon_previous.png",
                                    width: 25,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (DateTime.now().month ==
                                            dateTime.month &&
                                        DateTime.now().year == dateTime.year) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "You can't select month before today");
                                    } else {
                                      dateTime = DateTime(dateTime.year,
                                          dateTime.month + 1, dateTime.day);
                                      pjpBloc.add(DateIncrementEvent(
                                          dateTime: dateTime));
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/2x/icon_next.png",
                                    width: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: reportBG,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: BlocBuilder<PjpBloc, PjpState>(
                          builder: (context, state) {
                            if (state is PjpLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (state is PjpSuccessState) {
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Column(
                                    children: List.generate(
                                      state.response.length,
                                      (index) {
                                        return Stack(
                                          children: [
                                            Container(
                                              height: 85,
                                              margin: const EdgeInsets.fromLTRB(
                                                  10, 15, 10, 0),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      12, 12, 0, 12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: -8,
                                                    blurRadius: 7,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: ListTile(
                                                dense: true,
                                                horizontalTitleGap: 0,
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 48),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        DateFormat('EEE')
                                                            .format(state
                                                                .response[index]
                                                                .pjpDate!),
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        state.response[index]
                                                            .pjpDescription,
                                                        style: const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color:
                                                              Color(0xff303030),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                trailing: InkWell(
                                                  onTap: () {
                                                    showPJP(
                                                        state.response[index]
                                                            .pjpDescription,
                                                        state.response[index]
                                                            .pjpDate!,
                                                        state.response[index].id
                                                            .toString());
                                                  },
                                                  child: Container(
                                                    width: 20,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.more_vert,
                                                        color: Colors.black,
                                                        size: 27,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 10,
                                              top: 15,
                                              child: Container(
                                                height: 85,
                                                width: 65,
                                                decoration: const BoxDecoration(
                                                  color: colorCalenderDateBG,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      DateFormat('MMM').format(
                                                          state.response[index]
                                                              .pjpDate!),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      DateFormat('dd').format(
                                                          state.response[index]
                                                              .pjpDate!),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (state is PjpFailureState) {
                              return Center(
                                child: Text(state.message),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showPJP(String pjpDescription, DateTime pjpDate, String pjpId) async {
    var status =
        await SharedPrefrence.getStringPreference(SharedPrefrence.isEnable);
    controller.text = pjpDescription;
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
              child: status == "show" && pjpDate.isAfter(dateTime)
                  ? Container(
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
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                DateFormat('EEE dd MMM').format(pjpDate),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: colorPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                "PJP",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                            child: TextFormField(
                              controller: controller,
                              maxLines: 4,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                color: Color(0xff303030),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colorPrimary),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff555555),
                                  ),
                                ),
                              ),
                              onSaved: (value) {
                                controller.text = value!;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
                            child: InkWell(
                              onTap: () {
                                if (controller.text.isNotEmpty) {
                                  pjpBloc.add(UpdatePjpEvent(
                                      id: pjpId, description: controller.text));
                                  controller.clear();

                                  getPjp();
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Field can't be empty");
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: colorGreen,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Update",
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
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.40,
                      decoration: const BoxDecoration(
                        color: reportBG,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 14, 0, 0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                DateFormat('EEE dd MMM').format(pjpDate),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: colorPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                "PJP",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 10, 14, 14),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      pjpDescription,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 17),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  getPjp() async {
    var id = await SharedPrefrence.getStringPreference(SharedPrefrence.id);
    pjpBloc.add(PjpEvent(id: id, month: DateFormat("MM").format(dateTime)));
  }

  datePicker() {
    showMonthPicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: dateTime,
      locale: const Locale("en"),
    ).then((date) {
      dateTime = date!;
      pjpBloc.add(DateSelectEvent(dateTime: date));
    });
  }

  @override
  void onPageLoad(bool pageLoad) {
    if (pageLoad) {
      getPjp();
    }
  }

  onRefresh() {
    getPjp();
    refreshController.refreshCompleted();
  }
}
