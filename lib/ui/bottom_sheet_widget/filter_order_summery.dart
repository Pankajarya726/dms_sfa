import 'package:dms/main.dart';
import 'package:dms/ui/bottom_sheet_widget/selection_bottom_sheet.dart';
import 'package:dms/ui/custom_widget/drop_down_field.dart';
import 'package:dms/ui/order_summery/model/get_customer_response.dart';
import 'package:dms/ui/order_summery/model/get_customer_type_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
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
  TextEditingController txtLocation = TextEditingController();
  TextEditingController txtCustomerType = TextEditingController();
  TextEditingController txtCustomer = TextEditingController();
  List<CustomerType> customerTypeList = [];
  List<Customer> customerList = [];

  CustomerType? customerType;
  Customer? customer;

  @override
  initState() {
    txtDate.text = DateFormat("dd/MM/yyyy").format(fromDate);
    getCustomer();
    getCustomerType();

    super.initState();
  }

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
            mainAxisSize: MainAxisSize.min,
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
              TextFormField(
                readOnly: true,
                controller: txtCustomerType,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    hintText: "Select Customer Type"),
                onTap: () async {
                  List<Selection> selection = [];

                  await Future.forEach(
                      customerTypeList, (CustomerType element) => selection.add(Selection(id: element.id, name: element.name)));

                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      isScrollControlled: true,
                      builder: (context) => SelectionBottomSheet(
                            selection: selection,
                            selected: Selection(id: "id", name: "name"),
                            onSelect: (Selection type) {
                              if (type.id.isNotEmpty) {
                                customerType = CustomerType(id: type.id, name: type.name);
                                txtCustomerType.text = type.name;
                                getCustomer();
                              }
                            },
                            header: "Select Customer Type",
                          ));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                readOnly: true,
                controller: txtCustomer,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    hintText: "Select Customer"),
                onTap: () async {
                  List<Selection> selection = [];

                  if (customerType != null && customerType!.id.isNotEmpty) {
                    List<Customer> customers = customerList.where((element) => element.customerType == customerType!.id).toList();
                    await Future.forEach(customers, (Customer element) async {
                      selection.add(Selection(id: element.id, name: element.customerName));
                    });
                  } else {
                    await Future.forEach(customerList, (Customer element) async {
                      selection.add(Selection(id: element.id, name: element.customerName));
                    });
                  }

                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      isScrollControlled: true,
                      builder: (context) => SelectionBottomSheet(
                            selection: selection,
                            selected: customer != null
                                ? Selection(id: customer!.id, name: customer!.customerName)
                                : Selection(id: "id", name: "name"),
                            onSelect: (Selection type) {
                              if (type.id.isNotEmpty) {
                                customer = customerList.singleWhere((element) => element.id == type.id);
                                txtCustomer.text = type.name;
                              }
                            },
                            header: "Select Customer Type",
                          ));
                },
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

  void getCustomerType() async {
    if (await Network.isConnected()) {
      GetCustomerTypeResponse response = await repository.getCustomerType();
      if (response.success) {
        customerTypeList = response.data;
      } else {
        customerTypeList = [];
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  void getCustomer() async {
    if (await Network.isConnected()) {
      GetCustomerResponse response = await repository.getCustomers();
      if (response.success) {
        customerList = response.data;
      } else {
        customerList = [];
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
