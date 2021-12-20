import 'package:dms/ui/add_plan/bloc/add_plan_bloc.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_events.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_states.dart';
import 'package:dms/ui/custom_widget/beat_bootom_sheet.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({Key? key}) : super(key: key);

  @override
  _AddPlanScreenState createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  String month = "Jan 2021";
  List<String> primaryTags = [
    "Retailing",
    "Joint Working",
    "Official Meeting",
    "Dealer Meeting",
    "Leave",
    "Holiday"
  ];
  Map<String, List<String>> secondaryTags = {
    "Retailing": [
      "Vijay nagar",
      "Palasiya",
      "Regel square",
      "Bangali square",
      "malwa meel square",
      "Pardesipura"
    ],
    "Joint Working": ["Joint Working1", "Joint Working2", "Joint Working3"],
  };

  String selectedPrimaryTag = "Retailing";
  String selectedSecondaryTag = "";
  AddPlanBloc addPlanBloc = AddPlanBloc();

  TextEditingController txtRemarkController = TextEditingController();
  TextEditingController txtBeatController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  DateTime? dateTime;
  bool planAlreadyExists = false;
  int updateAddPlanId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              month + "\t\t",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
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
                  addPlanBloc.add(
                    GetAddPlanDataEvent(
                        selectedDate:
                            DateFormat("yyyy-MM-dd").format(dateTime!)),
                  );
                },
                // cellBuilder: (context, detail) {
                //   return Container(
                //     height: 20,
                //
                //     child: Text(detail.date.day.toString()),
                //   );
                // },
                minDate:
                    DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
                initialDisplayDate:
                    DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
                selectionMode: DateRangePickerSelectionMode.single,
                navigationMode: DateRangePickerNavigationMode.none,
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black),
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
            BlocProvider(
              create: (context) => addPlanBloc,
              child: BlocBuilder<AddPlanBloc, AddPlanStates>(
                builder: (context, state) {
                  if (state is AddPlanLoadingState) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is GetAddPlanDataState) {
                    selectedPrimaryTag =
                        state.getAddPlanDataResponse.data!.first.primaryTag;
                    // selectedSecondaryTag =
                    //     state.getAddPlanDataResponse.data!.first.secondaryTag;

                    txtRemarkController = TextEditingController(
                        text: state.getAddPlanDataResponse.data!.first.remark);
                    planAlreadyExists = state.getAddPlanDataResponse.success;
                    updateAddPlanId =
                        state.getAddPlanDataResponse.data!.first.id;
                  }
                  if (state is GetAddPlanFailureState) {
                    txtRemarkController = TextEditingController(text: "");
                    planAlreadyExists = state.success;
                  }
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          primaryTag,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Tags(
                          itemCount: primaryTags.length,
                          alignment: WrapAlignment.start,
                          itemBuilder: (index) {
                            return ItemTags(
                              singleItem: true,
                              onPressed: (item) {
                                selectedPrimaryTag = item.title!;
                                setState(() {});
                              },
                              active: selectedPrimaryTag == primaryTags[index]
                                  ? true
                                  : false,
                              title: primaryTags[index],
                              textActiveColor: Colors.black,
                              textColor: const Color(0xff555555),
                              elevation: 0,
                              textStyle: const TextStyle(fontSize: 16),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              index: index,
                              border: Border.all(
                                  color: selectedPrimaryTag ==
                                          primaryTags[index]
                                      ? MColor.colorPrimary
                                      : const Color.fromRGBO(197, 197, 197, 1)),
                              activeColor: const Color(0xFFFFC9CC),
                              color: const Color(0xffFAFAFA),
                            );
                          },
                        ),
                        selectedPrimaryTag == "Retailing" ||
                                selectedPrimaryTag == "Joint Working"
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  secondaryTag,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(),
                        selectedPrimaryTag == primaryTags[0]
                            ? TextFormField(
                                scrollPadding: const EdgeInsets.all(0),
                                readOnly: true,
                                controller: txtBeatController,
                                onTap: () {
                                  selectBeat(context,
                                      secondaryTags[selectedPrimaryTag]!);
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  hintText: "Select Retailing",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none),
                                  suffixIcon: const Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Colors.black,
                                  ),
                                  // suffixIconConstraints: BoxConstraints(maxWidth: 20, maxHeight: 20)
                                ),
                              )
                            : selectedPrimaryTag == primaryTags[1]
                                ? Tags(
                                    itemCount:
                                        secondaryTags[selectedPrimaryTag]!
                                            .length,
                                    alignment: WrapAlignment.start,
                                    itemBuilder: (index) {
                                      return ItemTags(
                                        singleItem: true,
                                        onPressed: (item) {
                                          selectedSecondaryTag = item.title!;
                                          setState(() {});
                                        },
                                        active: selectedSecondaryTag ==
                                                secondaryTags[
                                                    selectedPrimaryTag]![index]
                                            ? true
                                            : false,
                                        title: secondaryTags[
                                            selectedPrimaryTag]![index],
                                        textActiveColor: Colors.black,
                                        textColor: const Color(0xff555555),
                                        elevation: 0,
                                        textStyle:
                                            const TextStyle(fontSize: 16),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        index: index,
                                        border: selectedPrimaryTag ==
                                                primaryTags[index]
                                            ? Border.all(
                                                color: MColor.colorPrimary)
                                            : Border.all(
                                                color: MColor.colorPrimary),
                                        activeColor: const Color(0xFFFFC9CC),
                                        color: const Color(0xffFAFAFA),
                                      );
                                    },
                                  )
                                : Container(),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          remark,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
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
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPlanScreen()));
              if (planAlreadyExists) {
                addPlanBloc.add(
                  AddPlanUpdateEvent(
                      id: updateAddPlanId.toString(),
                      addPlanDate: dateTime == null
                          ? ""
                          : DateFormat("yyyy-MM-dd").format(dateTime!),
                      primaryTag: selectedPrimaryTag,
                      secondaryTag: selectedSecondaryTag,
                      remark: txtRemarkController.text),
                );
              } else {
                addPlanBloc.add(
                  AddPlanEvent(
                      addPlanDate: dateTime == null
                          ? ""
                          : DateFormat("yyyy-MM-dd").format(dateTime!),
                      primaryTag: selectedPrimaryTag,
                      secondaryTag: selectedSecondaryTag,
                      remark: txtRemarkController.text),
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
    );
  }

  void selectBeat(BuildContext context, List<String> secondaryTag) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (context) {
          return BeatBottomSheet(
              beat: txtBeatController.text,
              beats: secondaryTag,
              onBeatSelect: (String beat) {
                txtBeatController.text = beat;
                selectedSecondaryTag = txtBeatController.text;
              });
        });
  }
}
