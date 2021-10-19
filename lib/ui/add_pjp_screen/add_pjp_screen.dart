import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:sfa/utility/colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddPjpScreen extends StatefulWidget {
  const AddPjpScreen({Key? key}) : super(key: key);

  @override
  _AddPjpScreenState createState() => _AddPjpScreenState();
}

class _AddPjpScreenState extends State<AddPjpScreen> {
  String startDate = "";
  String endDate = "";
  @override
  void initState() {
    log(DateTime.now().toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text("Add PJP"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: Container(
          color: reportBG,
          child: SfDateRangePicker(
            headerHeight: 40,
            headerStyle: const DateRangePickerHeaderStyle(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            selectionRadius: 20,
            monthViewSettings: const DateRangePickerMonthViewSettings(
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: TextStyle(color: Colors.white))),
            monthCellStyle: const DateRangePickerMonthCellStyle(
              todayTextStyle: TextStyle(color: Colors.white),
              disabledDatesTextStyle: TextStyle(color: Colors.white54),
              textStyle: TextStyle(color: Colors.white),
            ),
            backgroundColor: colorPrimary,
            selectionMode: DateRangePickerSelectionMode.single,
            minDate: DateTime.parse("2021-01-25"),
            maxDate: DateTime.parse("2021-11-30"),
            selectionTextStyle: const TextStyle(color: colorPrimary),
            selectionColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
