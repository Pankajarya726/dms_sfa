import 'package:dms/model/get_plan_response.dart';
import 'package:dms/model/primary_tag_response.dart';
import 'package:dms/model/secondary_tag_response.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_bloc.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_events.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_states.dart';
import 'package:dms/ui/custom_widget/primary_tag_widget.dart';
import 'package:dms/ui/custom_widget/secondary_tag_widget.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddPlanScreen extends StatefulWidget {
  final DateTime month;

  const AddPlanScreen({
    Key? key,
    required this.month,
  }) : super(key: key);

  @override
  _AddPlanScreenState createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  int week = 1;

  AddPlanBloc addPlanBloc = AddPlanBloc();

  TextEditingController txtRemarkController = TextEditingController();
  TextEditingController txtBeatController = TextEditingController();
  DateRangePickerController dateRangePickerController = DateRangePickerController();
  final formKey = GlobalKey<FormState>();

  DateTime? dateTime;
  bool planAlreadyExists = false;
  int updateAddPlanId = 0;

  PrimaryTag? primaryTag;
  SecondaryTag? secondaryTag;
  PrimaryTagListener? primaryTagListener;
  SecondaryTagListener? secondaryTagListener;
  PlanDataModel? planDateModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddPlanBloc>(
      create: (context) => addPlanBloc,
      child: BlocListener<AddPlanBloc, AddPlanStates>(
        bloc: addPlanBloc,
        listener: (context, state) {
          if (state is GetSavedPlanState) {
            planDateModel = state.planDateModel;
            planAlreadyExists = true;
            txtRemarkController.text = state.planDateModel.remark;
            primaryTag = PrimaryTag(id: state.planDateModel.primaryTagId, name: state.planDateModel.primaryTag);
            secondaryTag = SecondaryTag(id: state.planDateModel.secondaryTagId, name: state.planDateModel.secondaryTag);

            if (primaryTagListener != null) {
              primaryTagListener!.onPrimaryTagSelect(primaryTag!);
            }
            if (secondaryTagListener != null) {
              secondaryTagListener!.onPrimaryTagChange(primaryTag!, secondaryTag!);
              secondaryTagListener!.onSecondaryTagSelect(secondaryTag!);
            }
          }
          if (state is GetAddPlanFailureState) {
            planDateModel = null;
            planAlreadyExists = false;
          }
          if (state is SelectPrimaryState) {
            // secondaryTagListener!.onPrimaryTagChange(primaryTag!, secondaryTag!);
            // secondaryTagListener!.onSecondaryTagSelect(secondaryTag!);
          }
          if (state is AddPlanSuccessState) {
            planAlreadyExists = true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            title: const Text(addPlan),
            elevation: 1,
            actions: [
              Center(
                child: Text(
                  DateFormat("MMM yyyy").format(widget.month) + "\t\t",
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.75,
                  child: SfDateRangePicker(
                    viewSpacing: 50,
                    controller: dateRangePickerController,
                    allowViewNavigation: false,
                    enableMultiView: false,
                    enablePastDates: false,
                    showActionButtons: false,
                    showNavigationArrow: false,
                    toggleDaySelection: false,
                    headerHeight: 0,
                    showTodayButton: false,
                    onSelectionChanged: (selectedDate) {
                      dateTime = selectedDate.value;

                      int w = dateTime!.day;

                      week = (w / 7).toInt() + 1;

                      addPlanBloc.add(
                        GetSavedPlanEvent(selectedDate: DateFormat("yyyy-MM-dd").format(dateTime!)),
                      );
                    },
                    // cellBuilder: (context, detail) {
                    //   return Container(
                    //     height: 20,
                    //
                    //     child: Text(detail.date.day.toString()),
                    //   );
                    // },
                    minDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
                    initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
                    selectionMode: DateRangePickerSelectionMode.single,
                    navigationMode: DateRangePickerNavigationMode.none,
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                      leadingDatesTextStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                      trailingDatesTextStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      showTrailingAndLeadingDates: true,
                      viewHeaderHeight: 50,
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        textStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Primary Tag",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      BlocBuilder<AddPlanBloc, AddPlanStates>(
                        builder: (context, state) {
                          if (state is AddPlanInitialState) {
                            getInitialDate();
                          }
                          return PrimaryTagWidget(
                            onSelect: (tag) {
                              primaryTag = tag;

                              addPlanBloc.add(SelectPrimaryEvent(primaryTag: primaryTag!));

                              if (secondaryTagListener != null && primaryTag != null) {
                                secondaryTagListener!.onPrimaryTagChange(primaryTag!, secondaryTag);
                              }
                            },
                            onInit: (PrimaryTagListener listener) {
                              primaryTagListener = listener;
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      BlocBuilder<AddPlanBloc, AddPlanStates>(
                        builder: (context, state) {
                          if (state is AddPlanInitialState) {
                            return Container();
                          }
                          if (primaryTag == null) {
                            return Container();
                          }
                          return SecondaryTagWidget(
                            onSelect: (tag) {
                              secondaryTag = tag;
                            },
                            onInit: (SecondaryTagListener listener) {
                              secondaryTagListener = listener;
                            },
                            primaryTag: primaryTag,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        remark,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        minLines: 3,
                        maxLines: 5,
                        controller: txtRemarkController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffF2F2F2),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: BlocProvider(
            create: (context) => addPlanBloc,
            child: BlocListener<AddPlanBloc, AddPlanStates>(
              listener: (context, state) {
                if (state is AddPlanSuccessState) {
                  Fluttertoast.showToast(msg: state.successMessage);
                }
                if (state is AddPlanFailureState) {
                  Fluttertoast.showToast(msg: state.failureMessage);
                }
              },
              child: MaterialButton(
                height: 50,
                minWidth: MediaQuery.of(context).size.width,
                color: MColor.colorSecondary,
                textColor: Colors.white,
                onPressed: () async {
                  Map<String, dynamic> input = {
                    "user_id": await SharedPreference.getStringPreference(SharedPreference.userId),
                    "add_plan_date": dateTime == null ? "" : DateFormat("yyyy-MM-dd").format(dateTime!),
                    "primary_tag": primaryTag!.name,
                    "primary_tag_id": primaryTag!.id,
                    "secondary_tag": secondaryTag!.name,
                    "secondary_tag_id": secondaryTag!.id,
                    "remark": txtRemarkController.text.trim(),
                    "week": week,
                  };
                  if (planAlreadyExists) {
                    input["id"] = planDateModel!.id;
                    addPlanBloc.add(
                      UpdatePlanEvent(input: input),
                    );
                  } else {
                    addPlanBloc.add(
                      AddPlanEvent(input: input),
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      confirm,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      width: 20,
                      height: 15,
                      child: SvgPicture.asset(
                        "assets/arrow_right.svg",
                        height: 20,
                        fit: BoxFit.contain,
                        width: 15,
                        allowDrawingOutsideViewBox: false,
                        matchTextDirection: true,
                      ),
                    ),
                    // Icon(Icons.arrow_forward_outlined)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getInitialDate() async {
    dateTime = await NTP.now();
    dateRangePickerController.selectedDate = DateTime(dateTime!.year, dateTime!.month + 1, 1);
    // addPlanBloc.add(
    //   GetSavedPlanEvent(selectedDate: DateFormat("yyyy-MM-dd").format(dateTime!)),
    // );
  }
}
