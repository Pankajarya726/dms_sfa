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
import 'package:fluttertoast/fluttertoast.dart';
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
          debugPrint("state----->$state");

          if (state is GetTagState) {
            primaryTagList = state.primaryTagList;
            selectedPrimaryTag = primaryTagList.first;
            addPlanBloc.add(SelectPrimaryEvent(primaryTag: selectedPrimaryTag!));
            getInitialDate();
          }

          if (state is GetSavedPlanState) {
            _refreshController.refreshCompleted();
            planDateModel = state.planDateModel;
            planAlreadyExists = true;
            txtRemarkController.text = state.planDateModel.remark;

            selectedPrimaryTag = PrimaryTag(
                primaryId: int.parse(state.planDateModel.primaryTagId),
                primaryName: state.planDateModel.primaryTag,
                secondaryTag: state.planDateModel.secondaryTags);

            // primaryTag = PrimaryTag(id: state.planDateModel.primaryTagId, name: state.planDateModel.primaryTag);
            // secondaryTag = state.planDateModel.secondaryTags;
            // addPlanBloc.add(GetSecondaryTagEvent(primaryTagId: primaryTag!.id));
            String selectedBeats = "";
            // if (secondaryTag.isNotEmpty) {
            //   for (int i = 0; i < secondaryTag.length; i++) {
            //     if (i == secondaryTag.length - 1) {
            //       selectedBeats += secondaryTag[i].locationCode;
            //     } else {
            //       selectedBeats += secondaryTag[i].locationCode + ", ";
            //     }
            //   }
            // }
            txtBeatController.text = selectedBeats;
          }

          // if (state is GetSecondaryTagState) {
          //   secondaryTagList = state.secondaryTagList;
          //   if (secondaryTag.isNotEmpty) {
          //     addPlanBloc.add(SelectSecondaryEvent(secondaryTag: secondaryTag));
          //   }
          // }
          if (state is GetAddPlanFailureState) {
            _refreshController.refreshCompleted();
            planDateModel = null;
            planAlreadyExists = false;
            selectedPrimaryTag = primaryTagList.first;

            txtRemarkController.text = "";
            txtBeatController.clear();
            addPlanBloc.add(SelectPrimaryEvent(primaryTag: selectedPrimaryTag!));
          }

          if (state is AddPlanFailureState) {
            Fluttertoast.showToast(msg: state.failureMessage);
          }
          if (state is AddPlanSuccessState) {
            planAlreadyExists = true;
            planDateModel = state.planDataModel;
          }
        },
        child: Scaffold(
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
            title: const Text(addPlan),
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
                      navigationMode: DateRangePickerNavigationMode.none,
                      minDate: widget.fromDate,
                      maxDate: widget.toDate,
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
                        print('Week of the month: $weekOfMonth');

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
                        // BlocBuilder<AddPlanBloc, AddPlanStates>(builder: (context, state) {
                        //   if (primaryTagList.isEmpty || primaryTag == null) {
                        //     return Container();
                        //   }
                        //
                        //   return PrimaryTagWidget(
                        //     onSelect: (PrimaryTag tag) {
                        //       primaryTag = tag;
                        //     },
                        //     tag: primaryTag,
                        //     primaryTags: primaryTagList,
                        //   );
                        // }),

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
                            if (primaryTagList.isEmpty) {
                              return Container();
                            }
                            if (state is SelectPrimaryTagState) {
                              if (selectedPrimaryTag != null && selectedPrimaryTag!.primaryId == state.primaryTag.primaryId) {
                              } else {
                                selectedPrimaryTag = state.primaryTag;
                                txtBeatController.clear();
                                for (var element in selectedPrimaryTag!.secondaryTag) {
                                  element.check = false;
                                }

                                selectedSecondaryTag.clear();
                                // addPlanBloc.add(GetSecondaryTagEvent(primaryTagId: selectedPrimaryTag!.primaryId.toString()));
                              }
                            }
                            selectedPrimaryTag ??= primaryTagList.first;

                            return Tags(
                              itemCount: primaryTagList.length,
                              alignment: WrapAlignment.start,
                              itemBuilder: (index) {
                                return ItemTags(
                                  customData: primaryTagList[index],
                                  singleItem: true,
                                  onPressed: (item) {
                                    addPlanBloc.add(SelectPrimaryEvent(primaryTag: item.customData));
                                  },
                                  active: selectedPrimaryTag!.primaryId == primaryTagList[index].primaryId,
                                  title: primaryTagList[index].primaryName,
                                  textActiveColor: Colors.black,
                                  textColor: const Color(0xff555555),
                                  elevation: 0,
                                  textStyle: const TextStyle(fontSize: 16),
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  index: index,
                                  border: Border.all(
                                      color: selectedPrimaryTag!.primaryId == primaryTagList[index].primaryId
                                          ? MColor.colorPrimary
                                          : const Color.fromRGBO(197, 197, 197, 1)),
                                  activeColor: selectedPrimaryTag!.primaryId == primaryTagList[index].primaryId
                                      ? const Color(0xFFFFC9CC)
                                      : const Color(0xffFAFAFA),
                                  color: selectedPrimaryTag!.primaryId == primaryTagList[index].primaryId
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

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                selectedPrimaryTag!.primaryId == 1 || selectedPrimaryTag!.primaryId == 2
                                    ? const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          "Secondary Tag",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.67,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                selectedPrimaryTag!.primaryId == 1
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
                                    : selectedPrimaryTag!.primaryId == 2
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
                          remark,
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
                              maxLength: 255,
                              controller: txtRemarkController,
                              decoration: InputDecoration(
                                hintText: "Enter remark",
                                counter: Container(),
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
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
          bottomSheet: BlocProvider(
            create: (context) => addPlanBloc,
            child: BlocBuilder<AddPlanBloc, AddPlanStates>(
              builder: (context, state) {
                return MaterialButton(
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                  // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  color: MColor.colorSecondary,
                  textColor: Colors.white,
                  onPressed: () async {
                    Utility.hideKeyboard();
                    if (selectedPrimaryTag == null) {
                      Fluttertoast.showToast(msg: "Please select primary tag");
                      return;
                    }
                    if ((selectedPrimaryTag!.primaryId == 1 || selectedPrimaryTag!.primaryId == 2) && secondaryTag.isEmpty) {
                      Fluttertoast.showToast(msg: "Please select secondary tag");
                      return;
                    }
                    if (txtRemarkController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Please enter remark");
                      return;
                    }

                    Map<String, dynamic> input = HashMap<String, dynamic>();
                    input["user_id"] = await SharedPreference.getStringPreference(SharedPreference.userId);
                    input["add_plan_date"] = dateTime == null ? "" : DateFormat("yyyy-MM-dd").format(dateTime!);
                    if (selectedPrimaryTag != null) {
                      input["primary_tag"] = selectedPrimaryTag!.primaryName;
                      input["primary_tag_id"] = selectedPrimaryTag!.primaryId;

                      if (selectedPrimaryTag!.secondaryTag.isNotEmpty) {
                        String secondaryTagName = "";
                        String secondaryTagId = "";
                        if (secondaryTag.isNotEmpty) {
                          for (int i = 0; i < secondaryTag.length; i++) {
                            if (i == secondaryTag.length - 1) {
                              secondaryTagName += selectedPrimaryTag!.secondaryTag[i].name;
                              secondaryTagId += selectedPrimaryTag!.secondaryTag[i].id.toString();
                            } else {
                              secondaryTagName += selectedPrimaryTag!.secondaryTag[i].name + ",";
                              secondaryTagId += selectedPrimaryTag!.secondaryTag[i].id.toString() + ",";
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
                );
              },
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

extension DateTimeExtension on DateTime {
  int get weekOfMonth {
    var wom = 0;
    var date = this;

    while (date.month == month) {
      wom++;
      date = date.subtract(const Duration(days: 7));
    }

    return wom;
  }
}
