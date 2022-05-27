import 'package:dms/ui/custom_widget/drop_down_field.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bottom_sheet_widget.dart';
import 'date_picker_sheet.dart';

class FilterOrderSummerySheet extends StatefulWidget {
  const FilterOrderSummerySheet({Key? key}) : super(key: key);

  @override
  _FilterOrderSummerySheetState createState() => _FilterOrderSummerySheetState();
}

class _FilterOrderSummerySheetState extends State<FilterOrderSummerySheet> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
        minHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                StringConst.filter,
                style: TextStyle(
                  color: MColor.colorPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.67,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                readOnly: true,
                controller: txtDate,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    suffixIcon: Image(
                      image: AssetImage("assets/date.png"),
                    )),
                onTap: () async {
                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      builder: (context) => DatePickerSheet(
                            onSelect: (DateTime frmDate, DateTime endDate) {
                              fromDate = frmDate;
                              toDate = endDate;
                              if (fromDate != toDate) {
                                txtDate.text =
                                    DateFormat("dd/MM/yyyy").format(fromDate) + " to " + DateFormat("dd/MM/yyyy").format(toDate);
                              } else {
                                txtDate.text = DateFormat("dd/MM/yyyy").format(fromDate);
                              }
                            },
                            toDate: toDate,
                            fromDate: fromDate,
                          ));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              DropDownField(
                onMenuItemSelected: (listener) {},
                prevSelected: "selectedEnrollmentType",
                onSelect: (value) {
                  debugPrint("select-->$value");
                  // selectedEnrollmentType = value;
                },
                hint: "Select Location Type",
                menuList: const ["Zone", "State", "Division", "District", "Tahsil", "Beat"],
              ),
              const SizedBox(
                height: 20,
              ),
              DropDownField(
                onMenuItemSelected: (listener) {},
                prevSelected: "selectedEnrollmentType",
                onSelect: (value) {
                  debugPrint("select-->$value");
                  // selectedEnrollmentType = value;
                },
                hint: "Select Location",
                menuList: const ["Zone", "State", "Division", "District", "Tahsil", "Beat"],
              ),
              const SizedBox(
                height: 20,
              ),
              DropDownField(
                onMenuItemSelected: (listener) {},
                prevSelected: "selectedEnrollmentType",
                onSelect: (value) {
                  debugPrint("select-->$value");
                  // selectedEnrollmentType = value;
                },
                hint: "Select Customer Type",
                menuList: const ["Retailer", "Distributor", "Super stockist"],
              ),
              const SizedBox(
                height: 20,
              ),
              DropDownField(
                onMenuItemSelected: (listener) {},
                prevSelected: "selectedEnrollmentType",
                onSelect: (value) {
                  debugPrint("select-->$value");
                  // selectedEnrollmentType = value;
                },
                hint: "Select Customer",
                menuList: const ["Retailer", "Distributor", "Super stockist"],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 55),
                    color: MColor.colorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                    child: const Text(
                      StringConst.done,
                      style: TextStyle(
                        letterSpacing: 0.67,
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
