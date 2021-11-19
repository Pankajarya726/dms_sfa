import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_bloc/add_pjp_bloc.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_bloc/add_pjp_event.dart';
import 'package:sfa/ui/add_pjp_screen/add_pjp_bloc/add_pjp_state.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/shared_prefrence.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddPjpScreen extends StatefulWidget {
  const AddPjpScreen({Key? key}) : super(key: key);

  @override
  _AddPjpScreenState createState() => _AddPjpScreenState();
}

class _AddPjpScreenState extends State<AddPjpScreen> {
  AddPJPBloc addPJPBloc = AddPJPBloc();
  TextEditingController getDescription = TextEditingController();
  DateRangePickerController pickerController = DateRangePickerController();
  String startDate = "";
  String endDate = "";
  DateTime currDate = DateTime.now();
  String date = "";
  String pjpDate = "";
  DateTime dateTime = DateTime.now();
  @override
  void initState() {
    // DateTime showDate = DateTime(dateTime.year, dateTime.month + 1, 1);
    DateTime showDate = DateTime(dateTime.year, dateTime.month, 1);
    date = DateFormat('EEE dd MMM').format(showDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddPJPBloc>(
      create: (context) => addPJPBloc,
      child: BlocListener<AddPJPBloc, AddPJPState>(
        listener: (context, state) {
          if (state is AddPJPSuccessState) {
            Fluttertoast.showToast(msg: state.response.message.toString());
            getDescription.clear();
          }
          if (state is AddPJPFailureState) {
            Fluttertoast.showToast(msg: state.messages);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: colorPrimary,
            centerTitle: true,
            title: const Text("Add PJP"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context, true),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: colorPrimary,
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.4,
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
                          monthViewSettings:
                              const DateRangePickerMonthViewSettings(
                            weekendDays: [7],
                            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                              textStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          monthCellStyle: const DateRangePickerMonthCellStyle(
                            weekendTextStyle: TextStyle(color: colorLightBlack),
                            disabledDatesDecoration:
                                BoxDecoration(color: Colors.grey),
                            todayTextStyle: TextStyle(color: Colors.white),
                            textStyle: TextStyle(color: Colors.white),
                          ),
                          controller: pickerController,
                          backgroundColor: colorPrimary,
                          selectionMode: DateRangePickerSelectionMode.single,

                          // minDate:
                          //     DateTime(dateTime.year, dateTime.month + 1, 1),
                          // maxDate:
                          //     DateTime(dateTime.year, dateTime.month + 2, -0),
                          minDate: DateTime(dateTime.year, dateTime.month, 1),
                          maxDate:
                              DateTime(dateTime.year, dateTime.month + 2, -0),
                          selectionTextStyle:
                              const TextStyle(color: colorPrimary),
                          selectionColor: Colors.white,
                          onSelectionChanged: onSelected,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(14, 20, 15, 10),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                date,
                                style: const TextStyle(
                                    color: colorPrimary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25, 10, 25, 50),
                              child: TextFormField(
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 17),
                                autocorrect: true,
                                enableSuggestions: true,
                                maxLines: 7,
                                controller: getDescription,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: colorGrayLite,
                                  border: InputBorder.none,
                                  hintText: "Write your PJP",
                                  hintStyle: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent, width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: ElevatedButton(
                                onPressed: () async {
                                  String id =
                                      await SharedPrefrence.getStringPreference(
                                          SharedPrefrence.id);
                                  if (getDescription.text.isNotEmpty) {
                                    addPJPBloc.add(AddPJPEvent(
                                        id: id,
                                        date: pjpDate,
                                        description: getDescription.text));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Field can't be empty");
                                  }
                                },
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                    const Size(220, 60),
                                  ),
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
                                  "Done",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onSelected(DateRangePickerSelectionChangedArgs args) {
    DateTime d = args.value;
    if (d.weekday == 7) {
      pickerController.selectedDate = DateTime.parse(pjpDate);
    } else {
      date = DateFormat('EEE dd MMM').format(args.value);
      pjpDate = DateFormat('yyyy-MM-dd').format(args.value);
      pickerController.selectedDate = d;
    }
    setState(() {});
  }
}
