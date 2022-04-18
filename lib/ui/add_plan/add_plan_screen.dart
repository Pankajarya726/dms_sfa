import 'dart:collection';

import 'package:dms/model/get_all_tag_response.dart';
import 'package:dms/model/get_plan_response.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_bloc.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_events.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_states.dart';
import 'package:dms/ui/custom_widget/beat_bottom_sheet.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddPlanScreen extends StatefulWidget {
  final DateTime fromDate;
  final DateTime toDate;

  const AddPlanScreen({
    Key? key,
    required this.fromDate,
    required this.toDate,
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
  final RefreshController _refreshController = RefreshController();
  DateTime? dateTime;
  bool planAlreadyExists = false;
  int updateAddPlanId = 0;
  List<PrimaryTag> primaryTagList = [];
  PrimaryTag? selectedPrimaryTag;
  PlanDataModel? planDateModel;
  List<SecondaryTag> selectedSecondaryTag = [];

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
          if (state is GetTagState) {
            primaryTagList = state.primaryTagList;
            // selectedPrimaryTag = primaryTagList.firstWhere((element) => element.selected==1);
            // addPlanBloc.add(SelectPrimaryEvent(primaryTag: selectedPrimaryTag!));
            getInitialDate();
          }

          if (state is GetSavedPlanState) {
            _refreshController.refreshCompleted();
            planDateModel = state.planDateModel;
            planAlreadyExists = true;
            txtRemarkController.text = state.planDateModel.remark;
            // selectedSecondaryTag = state.planDateModel.secondaryTags;

            // String selectedBeats = state.planDateModel.secondaryTag;
            //
            // if (selectedSecondaryTag.isNotEmpty) {
            //   for (int i = 0; i < selectedSecondaryTag.length; i++) {
            //     if (i == selectedSecondaryTag.length - 1) {
            //       selectedBeats += selectedSecondaryTag[i].name;
            //     } else {
            //       selectedBeats += selectedSecondaryTag[i].name + ", ";
            //     }
            //   }
            // }
            //
            // txtBeatController.text = selectedBeats;

            List<SecondaryTag> secTag =
                primaryTagList.singleWhere((element) => element.id == int.parse(state.planDateModel.primaryTagId)).secondaryTag;

            for (var element in secTag) {
              element.check = false;
            }

            if (state.planDateModel.secondaryTags.isNotEmpty) {
              for (var element in state.planDateModel.secondaryTags) {
                secTag.singleWhere((tag) => tag.id == element.id).check = true;
              }
            }
            selectedSecondaryTag = secTag.where((element) => element.check).toList();

            selectedPrimaryTag = PrimaryTag(
                id: int.parse(state.planDateModel.primaryTagId),
                name: state.planDateModel.primaryTag,
                selectionType:
                    primaryTagList.singleWhere((element) => element.id.toString() == state.planDateModel.primaryTagId).selectionType,
                selected: 1,
                canSelect: 1,
                secondaryTagType: primaryTagList
                    .singleWhere((element) => element.id.toString() == state.planDateModel.primaryTagId)
                    .secondaryTagType,
                secondaryTag: secTag);

            addPlanBloc.add(SelectPrimaryEvent(primaryTag: selectedPrimaryTag!));
            addPlanBloc.add(SelectSecondaryEvent(secondaryTag: secTag.where((element) => element.check).toList()));
          }

          if (state is GetAddPlanFailureState) {
            _refreshController.refreshCompleted();
            planDateModel = null;
            planAlreadyExists = false;
            selectedPrimaryTag = null;
            selectedSecondaryTag.clear();
            txtRemarkController.clear();
            txtBeatController.clear();
            // addPlanBloc.add(SelectPrimaryEvent(primaryTag: selectedPrimaryTag!));
          }

          if (state is AddPlanFailureState) {
            Utility.showToast(state.failureMessage);
          }
          if (state is AddPlanSuccessState) {
            planAlreadyExists = true;
            planDateModel = state.planDataModel;
          }
          if (state is SelectPrimaryTagState) {
            selectedPrimaryTag = state.primaryTag;
            selectedSecondaryTag.clear();
            txtRemarkController.clear();
            txtBeatController.clear();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: MColor.backButton,
              ),
            ),
            title: const Text(StringConst.addPlan),
            elevation: 1,
            actions: [
              Center(
                child: Text(
                  DateFormat("MMM yyyy").format(widget.fromDate) + "\t\t\t\t",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          body: SmartRefresher(
            controller: _refreshController,
            onRefresh: () {
              addPlanBloc.add(
                GetSavedPlanEvent(selectedDate: DateFormat("yyyy-MM-dd").format(dateTime!)),
              );
            },
            onLoading: () {},
            header: const MaterialClassicHeader(),
            child: SingleChildScrollView(
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
                      showNavigationArrow: true,
                      toggleDaySelection: true,
                      headerHeight: 0,
                      showTodayButton: false,
                      selectionMode: DateRangePickerSelectionMode.single,
                      navigationMode: DateRangePickerNavigationMode.scroll,
                      minDate: widget.fromDate,
                      maxDate: widget.fromDate == widget.toDate
                          ? DateTime(widget.fromDate.year, widget.fromDate.month, widget.fromDate.day + 1)
                          : widget.toDate,
                      initialDisplayDate: widget.fromDate,
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16),
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
                        showTrailingAndLeadingDates: false,
                        firstDayOfWeek: 1,
                        viewHeaderHeight: 50,
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16),
                        ),
                      ),
                      onSelectionChanged: (selectedDate) {
                        debugPrint("onSelectionChanged-->$selectedDate");

                        dateTime = selectedDate.value;

                        // Current date and time of system
                        String date = dateTime!.toString();

                        String firstDay = date.substring(0, 8) +
                            '01' +
                            date.substring(10); // This will generate the time and date for first day of month

                        int weekDay = DateTime.parse(firstDay).weekday; // week day for the first day of the month
                        int weekOfMonth;
                        //  If your calender starts from Monday
                        weekDay--;
                        weekOfMonth = ((dateTime!.day + weekDay) / 7).ceil();
                        week = weekOfMonth;
                        debugPrint('Week of the month: $weekOfMonth');

                        addPlanBloc.add(
                          GetSavedPlanEvent(selectedDate: DateFormat("yyyy-MM-dd").format(dateTime!)),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    thickness: 1.5,
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Primary Tag",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.67,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        BlocBuilder<AddPlanBloc, AddPlanStates>(
                          builder: (context, state) {
                            debugPrint("state---->$state");
                            if (primaryTagList.isEmpty) {
                              return Container();
                            }

                            // selectedPrimaryTag ??= primaryTagList.first;

                            return Tags(
                              itemCount: primaryTagList.length,
                              alignment: WrapAlignment.start,
                              itemBuilder: (index) {
                                return ItemTags(
                                  customData: primaryTagList[index],
                                  singleItem: true,
                                  pressEnabled: primaryTagList[index].canSelect == 1,
                                  onPressed: (item) {
                                    PrimaryTag tag = item.customData;
                                    for (var element in tag.secondaryTag) {
                                      element.check = false;
                                    }
                                    txtBeatController.clear();
                                    selectedSecondaryTag.clear();
                                    addPlanBloc.add(SelectPrimaryEvent(primaryTag: tag));
                                  },
                                  active: selectedPrimaryTag == null ? false : selectedPrimaryTag!.id == primaryTagList[index].id,
                                  title: primaryTagList[index].name,
                                  textActiveColor: const Color(0xff555555),
                                  textColor: const Color(0xff555555),
                                  elevation: 0,
                                  textStyle: const TextStyle(fontSize: 16),
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  index: index,
                                  border: Border.all(
                                      color: selectedPrimaryTag == null
                                          ? const Color.fromRGBO(197, 197, 197, 1)
                                          : selectedPrimaryTag!.id == primaryTagList[index].id
                                              ? MColor.colorPrimary
                                              : const Color.fromRGBO(197, 197, 197, 1)),
                                  activeColor: selectedPrimaryTag == null
                                      ? const Color(0xffFAFAFA)
                                      : selectedPrimaryTag!.id == primaryTagList[index].id
                                          ? const Color(0xFFFFC9CC)
                                          : const Color(0xffFAFAFA),
                                  color: selectedPrimaryTag == null
                                      ? const Color(0xffFAFAFA)
                                      : selectedPrimaryTag!.id == primaryTagList[index].id
                                          ? const Color(0xFFFFC9CC)
                                          : const Color(0xffFAFAFA),
                                );
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
                            if (selectedPrimaryTag == null) {
                              return Container();
                            }

                            if (state is SelectSecondaryState) {
                              selectedSecondaryTag = state.secondaryTag;
                              debugPrint("selectedSecondaryTag1--->$selectedSecondaryTag");
                              String selectedBeats = "";
                              if (selectedSecondaryTag.isNotEmpty) {
                                for (int i = 0; i < selectedSecondaryTag.length; i++) {
                                  if (i == selectedSecondaryTag.length - 1) {
                                    selectedBeats += selectedSecondaryTag[i].name;
                                  } else {
                                    selectedBeats += selectedSecondaryTag[i].name + ", ";
                                  }
                                }
                              }
                              txtBeatController.text = selectedBeats;
                            }
                            if (selectedPrimaryTag!.secondaryTag.isEmpty) {
                              return Container();
                            }

                            debugPrint(selectedPrimaryTag!.secondaryTag.toString());
                            debugPrint(selectedPrimaryTag!.secondaryTagType.toString());

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    "Secondary Tag",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.67,
                                    ),
                                  ),
                                ),
                                selectedPrimaryTag!.secondaryTagType == "drop_down"
                                    ? TextFormField(
                                        scrollPadding: const EdgeInsets.all(0),
                                        readOnly: true,
                                        controller: txtBeatController,
                                        onTap: () {
                                          selectBeat(context, selectedPrimaryTag!.secondaryTag);
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(15),
                                          hintText: "Select Retailing",
                                          border:
                                              OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                                          suffixIcon: const Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Colors.black,
                                          ),
                                          // suffixIconConstraints: BoxConstraints(maxWidth: 20, maxHeight: 20)
                                        ),
                                      )
                                    : selectedPrimaryTag!.secondaryTagType == "tags"
                                        ? Tags(
                                            itemCount: selectedPrimaryTag!.secondaryTag.length,
                                            alignment: WrapAlignment.start,
                                            itemBuilder: (index) {
                                              return ItemTags(
                                                singleItem: true,
                                                customData: selectedPrimaryTag!.secondaryTag[index],
                                                onPressed: (item) {
                                                  addPlanBloc.add(SelectSecondaryEvent(secondaryTag: [item.customData]));
                                                },
                                                active: selectedSecondaryTag.isNotEmpty
                                                    ? selectedSecondaryTag.first.id == selectedPrimaryTag!.secondaryTag[index].id
                                                    : false,
                                                title: selectedPrimaryTag!.secondaryTag[index].name,
                                                textActiveColor: Colors.black,
                                                textColor: const Color(0xff555555),
                                                elevation: 0,
                                                textStyle: const TextStyle(fontSize: 16),
                                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                index: index,
                                                border: Border.all(
                                                    color: selectedSecondaryTag.isNotEmpty
                                                        ? selectedSecondaryTag.first.id == selectedPrimaryTag!.secondaryTag[index].id
                                                            ? MColor.colorPrimary
                                                            : const Color.fromRGBO(197, 197, 197, 1)
                                                        : const Color.fromRGBO(197, 197, 197, 1)),
                                                activeColor: const Color(0xFFFFC9CC),
                                                color: selectedSecondaryTag.isNotEmpty
                                                    ? selectedSecondaryTag.first.id == selectedPrimaryTag!.secondaryTag[index].id
                                                        ? const Color(0xFFFFC9CC)
                                                        : const Color(0xffFAFAFA)
                                                    : const Color(0xffFAFAFA),
                                              );
                                            },
                                          )
                                        : Container(),
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          StringConst.remark,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.67,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        BlocBuilder<AddPlanBloc, AddPlanStates>(
                          builder: (context, state) {
                            if (state is AddPlanInitialState) {
                              addPlanBloc.add(GetTagEvent());
                            }

                            return TextFormField(
                              minLines: 3,
                              maxLines: 5,
                              maxLength: 250,

                              enableInteractiveSelection: false,
                              // selectionControls: MaterialTextSelectionControls,
                              controller: txtRemarkController,
                              decoration: InputDecoration(
                                hintText: "Enter remark",
                                // counter: Container(),
                                filled: true,
                                fillColor: const Color(0xffF2F2F2),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: MaterialButton(
              height: 50,
              minWidth: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              color: MColor.colorSecondary,
              textColor: Colors.white,
              onPressed: () async {
                Utility.hideKeyboard();
                if (selectedPrimaryTag == null) {
                  Utility.showToast("Please select primary tag");
                  return;
                }
                if ((selectedPrimaryTag!.secondaryTag.isNotEmpty) && selectedSecondaryTag.isEmpty) {
                  Utility.showToast("Please select secondary tag");
                  return;
                }
                if (txtRemarkController.text.trim().isEmpty) {
                  Utility.showToast("Please enter remark");
                  return;
                }

                Map<String, dynamic> input = HashMap<String, dynamic>();
                input["user_id"] = await SharedPreference.getStringPreference(SharedPreference.userId);
                input["add_plan_date"] = dateTime == null ? "" : DateFormat("yyyy-MM-dd").format(dateTime!);
                if (selectedPrimaryTag != null) {
                  input["primary_tag"] = selectedPrimaryTag!.name;
                  input["primary_tag_id"] = selectedPrimaryTag!.id;

                  if (selectedPrimaryTag!.secondaryTag.isNotEmpty) {
                    String secondaryTagName = "";
                    String secondaryTagId = "";

                    if (selectedSecondaryTag.isNotEmpty) {
                      for (int i = 0; i < selectedSecondaryTag.length; i++) {
                        if (i == selectedSecondaryTag.length - 1) {
                          secondaryTagName += selectedSecondaryTag[i].name;
                          secondaryTagId += selectedSecondaryTag[i].id.toString();
                        } else {
                          secondaryTagName += selectedSecondaryTag[i].name + ",";
                          secondaryTagId += selectedSecondaryTag[i].id.toString() + ",";
                        }
                      }
                    }
                    input["secondary_tag"] = secondaryTagName;
                    input["secondary_tag_id"] = secondaryTagId;
                  } else {
                    input["secondary_tag"] = '';
                    input["secondary_tag_id"] = "";
                  }
                }
                input["remark"] = txtRemarkController.text.trim();
                input["week"] = week;

                debugPrint("input---->$input");
                // return;

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
                    StringConst.confirm,
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
    );
  }

  //  getWeekOfMonth(DateTime date) {
  //   const startWeekDayIndex = 1; // 1 MonthDay 0 Sundays
  //   DateT firstDate =  DateTime(date.year, date.month, 1);
  //   const firstDay = firstDate.getDay();
  //
  //   let weekNumber = m.ceil((date.getDate() + firstDay) / 7);
  //   if (startWeekDayIndex === 1) {
  //     if (date.getDay() === 0 && date.getDate() > 1) {
  //   weekNumber -= 1;
  //   }
  //
  //   if (firstDate.getDate() === 1 && firstDay === 0 && date.getDate() > 1) {
  //   weekNumber += 1;
  //   }
  // }
  //   return weekNumber;
  // }
  void getInitialDate() async {
    dateRangePickerController.selectedDate = widget.fromDate;
  }

  void selectBeat(BuildContext context, List<SecondaryTag> tags) async {
    debugPrint("selectedSecondaryTag-->$selectedSecondaryTag");
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (context) {
          return BeatBottomSheet(
              selectedBeat: selectedSecondaryTag,
              beats: tags,
              onBeatSelect: (List<SecondaryTag> beat) {
                String selectedBeats = "";
                if (beat.isNotEmpty) {
                  for (int i = 0; i < beat.length; i++) {
                    beat[i].name = beat[i].name;
                    if (i == beat.length - 1) {
                      selectedBeats += beat[i].name;
                    } else {
                      selectedBeats += beat[i].name + ", ";
                    }
                  }
                }
                txtBeatController.text = selectedBeats;
                addPlanBloc.add(SelectSecondaryEvent(secondaryTag: beat));
              });
        });
  }
}
