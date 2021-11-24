import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sfa/listeners/report_type_listener.dart';
import 'package:sfa/ui/bottom_sheet/filter_bottom_sheet.dart';
import 'package:sfa/ui/bottom_sheet/filter_model/filter_model.dart';
import 'package:sfa/ui/pjp_by_date/bloc/pjp_by_date_state.dart';
import 'package:sfa/ui/report_data_grid/report_data_grid.dart';
import 'package:sfa/ui/report_screen/bloc/report_bloc.dart';
import 'package:sfa/ui/report_screen/bloc/report_event.dart';
import 'package:sfa/ui/report_screen/bloc/report_state.dart';
import 'package:sfa/utility/colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportBloc reportBloc = ReportBloc();
  bool accordionStatus = false;
  String? initialDate;
  String? endingDate;
  String? filterName;
  String? locationType;
  FilterData? location;
  String formatType = "";
  ReportTypeListener? reportTypeListener;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReportBloc>(
      create: (context) => reportBloc,
      child: Scaffold(
        backgroundColor: colorPrimary,
        appBar: AppBar(
          title: const Text(
            "Report",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                showFilters();
              },
              icon: const Image(
                height: 23,
                width: 23,
                image: AssetImage("assets/filter.png"),
                fit: BoxFit.cover,
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          showCalander();
                        },
                        child: Container(
                          height: 38,
                          width: MediaQuery.of(context).size.width * 0.23,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            border: Border.all(color: colorGrayDark),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 15,
                                width: 15,
                                child: Image.asset(
                                  "assets/custom-calendar.png",
                                  color: colorGrayDark,
                                ),
                              ),
                              const Text(
                                "Custom",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: colorGrayDark),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showType();
                        },
                        child: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "Report Type",
                                style: TextStyle(
                                    color: colorGrayDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: reportBG,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Center(
            child: BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                if (state is ReportLoadingState) {
                  return const CircularProgressIndicator();
                }
                if (state is ReportNetworkState) {
                  return Text(state.message);
                }
                if (state is ReportFailureState) {
                  Fluttertoast.showToast(msg: state.message);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: InkWell(
                      onTap: () {
                        getReport();
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        color: colorPrimary,
                        child: Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(bottom: 14, top: 30),
                              height: 45,
                              width: 45,
                              child: Image.asset(
                                "assets/download.png",
                                fit: BoxFit.cover,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              "All Staff",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (state is ReportSuccessState) {
                  return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      child: ReportDataGrid(
                        reportData: state.response.data,
                        onTypeSelect: (listener) {
                          reportTypeListener = listener;
                        },
                      ));
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: InkWell(
                    onTap: () {
                      getReport();
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      color: colorPrimary,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 14, top: 30),
                            height: 45,
                            width: 45,
                            child: Image.asset(
                              "assets/download.png",
                              fit: BoxFit.cover,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            "All Staff",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void showFilters() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return FilterBottomSheet(
          onSelect: (location, name, type) {
            this.location = location;
            filterName = name;
            locationType = type;
          },
        );
      },
    ).then((value) => getFilteredReport());
  }

  void showCalander() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return DateRangePickerView(
          onDateSelect: (startDate, endDate) {
            initialDate = startDate;
            endingDate = endDate;
          },
        );
      },
    ).then((value) => getReportByDate());
  }

  void showType() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: 148,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: reportBG,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: RadioListBuilder(onFormatSelect: (format) {
            formatType = format;
          }),
        );
      },
    ).then((value) {
      if (value != null) {
        if (reportTypeListener != null) {
          reportTypeListener!.onTypeSelect(formatType);
        } else {
          Fluttertoast.showToast(msg: "Press download button first!");
        }
      }
    });
  }

  getReport() {
    reportBloc.add(GetReportEvent(
      initDate: initialDate,
      endDate: endingDate,
      filterName: filterName,
      locationType: locationType,
      locationId: location != null ? location!.id : "",
    ));
  }

  getFilteredReport() {
    if (filterName!.isNotEmpty ||
        locationType!.isNotEmpty ||
        location!.id.isNotEmpty) {
      reportBloc.add(GetReportEvent(
        initDate: initialDate,
        endDate: endingDate,
        filterName: filterName,
        locationType: locationType,
        locationId: location != null ? location!.id : "",
      ));
    }
  }

  getReportByDate() {
    if (initialDate!.isNotEmpty && endingDate!.isNotEmpty) {
      reportBloc.add(GetReportEvent(
        initDate: initialDate,
        endDate: endingDate,
        filterName: filterName,
        locationType: locationType,
        locationId: location != null ? location!.id : "",
      ));
    }
  }
}

class DateRangePickerView extends StatefulWidget {
  final Function(String startDate, String endDate) onDateSelect;

  const DateRangePickerView({required this.onDateSelect, Key? key})
      : super(key: key);

  @override
  _DateRangePickerViewState createState() => _DateRangePickerViewState();
}

class _DateRangePickerViewState extends State<DateRangePickerView> {
  String startDate = "";
  String endDate = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: reportBG,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: IntrinsicHeight(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                  child: Text(
                    "Custom",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: colorGrayDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              color: reportBG,
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                maxDate: DateTime.now(),
                selectionColor: colorPrimary,
                onSelectionChanged: (dateRage) {
                  if (dateRage.value is PickerDateRange) {
                    startDate = DateFormat('yyyy-MM-dd')
                        .format(dateRage.value.startDate)
                        .toString();

                    endDate = DateFormat('yyyy-MM-dd')
                        .format(
                            dateRage.value.endDate ?? dateRage.value.startDate)
                        .toString();

                    setState(() {});
                  }
                },
              ),
            ),
            InkWell(
              onTap: () {
                widget.onDateSelect(startDate, endDate);
                Navigator.pop(context, true);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: reportBG,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
                child: Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        "Done",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadioListBuilder extends StatefulWidget {
  final Function(String format) onFormatSelect;
  const RadioListBuilder({required this.onFormatSelect, Key? key})
      : super(key: key);

  @override
  RadioListBuilderState createState() {
    return RadioListBuilderState();
  }
}

class RadioListBuilderState extends State<RadioListBuilder> {
  Object? value;
  List<String> types = ["Excel", "PDF"];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
      padding: const EdgeInsetsDirectional.only(top: 10),
      itemBuilder: (context, index) {
        return RadioListTile(
          value: index,
          groupValue: value,
          onChanged: (currentIndex) {
            setState(
              () {
                value = currentIndex;
                widget.onFormatSelect(value.toString());
                Timer(
                  const Duration(milliseconds: 200),
                  () => Navigator.pop(context, true),
                );
              },
            );
          },
          title: Text(
            types[index],
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      },
      itemCount: 2,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
        );
      },
    );
  }
}
