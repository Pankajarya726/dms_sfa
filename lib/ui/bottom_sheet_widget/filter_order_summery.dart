import 'package:dms/main.dart';
import 'package:dms/ui/bottom_sheet_widget/selection_bottom_sheet.dart';
import 'package:dms/ui/order_summery/model/get_customer_response.dart';
import 'package:dms/ui/order_summery/model/get_customer_type_response.dart';
import 'package:dms/ui/order_summery/model/get_location_response.dart';
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
  final Function(DateTime fromDate, DateTime toDate, Selection? locaitonType, Selection? location, Selection? customerType,
      Selection? customer) onSelect;
  final DateTime fromDate;
  final DateTime toDate;
  final Selection? location;
  final Selection? locationType;
  final Selection? customer;
  final Selection? customerType;

  const FilterOrderSummerySheet(
      {Key? key,
      required this.onSelect,
      required this.fromDate,
      required this.toDate,
      this.location,
      required this.locationType,
      this.customer,
      this.customerType})
      : super(key: key);

  @override
  _FilterOrderSummerySheetState createState() => _FilterOrderSummerySheetState();
}

class _FilterOrderSummerySheetState extends State<FilterOrderSummerySheet> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtLocation = TextEditingController();
  TextEditingController txtLocationType = TextEditingController();
  TextEditingController txtCustomerType = TextEditingController();
  TextEditingController txtCustomer = TextEditingController();
  List<CustomerType> customerTypeList = [];
  List<Customer> customerList = [];
  List<LocationModel> locationList = [];
  List<Selection> locationTypes = [
    Selection(id: "Zone", name: "Zone"),
    Selection(id: "State", name: "State"),
    Selection(id: "Division", name: "Division"),
    Selection(id: "District", name: "District"),
    Selection(id: "City", name: "Tehsil"),
    Selection(id: "Beat", name: "Beat")
  ];
  Selection? locationType;
  Selection? location;
  Selection? customer;
  Selection? customerType;

  String locType = "";

  // CustomerType? customerType;
  // Customer? customer;
  // LocationModel? location;

  @override
  initState() {
    txtDate.text = DateFormat("dd/MM/yyyy").format(fromDate);
    if (widget.customer != null) {
      customer = widget.customer;
      txtCustomer.text = customer!.name;
    }
    if (widget.customerType != null) {
      customerType = widget.customerType;
      txtCustomerType.text = customerType!.name;
    }

    if (widget.location != null) {
      location = widget.location;
      txtLocation.text = location!.name;
    }

    if (widget.locationType != null) {
      locType = widget.locationType!.id;
      locationType = widget.locationType;
      txtLocationType.text = locationType!.name;
      getLocation(locationType!.id);
    }

    fromDate = widget.fromDate;
    toDate = widget.toDate;

    if (locType.isNotEmpty) {
      txtLocationType.text = locType;
      getLocation(locType);
    }

    if (fromDate != toDate) {
      txtDate.text = DateFormat("dd/MM/yyyy").format(fromDate) + " to " + DateFormat("dd/MM/yyyy").format(toDate);
    } else {
      txtDate.text = DateFormat("dd/MM/yyyy").format(fromDate);
    }

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
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    StringConst.filter,
                    style: TextStyle(
                      color: MColor.colorPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.67,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      customer = null;
                      customerType = null;
                      location = null;
                      locationType = null;
                      txtCustomer.clear();
                      txtCustomerType.clear();
                      txtLocation.clear();
                      txtLocationType.clear();
                      locType = "";
                      fromDate = DateTime.now();
                      toDate = DateTime.now();

                      txtDate.text = DateFormat("dd/MM/yyyy").format(fromDate);
                    },
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                        color: MColor.colorPrimary,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.67,
                      ),
                    ),
                  ),
                ],
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
                              if (DateFormat("dd/MM/yyyy").format(fromDate) != DateFormat("dd/MM/yyyy").format(toDate)) {
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
              TextFormField(
                readOnly: true,
                controller: txtLocationType,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    hintText: "Select Location Type"),
                onTap: () async {
                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      isScrollControlled: true,
                      builder: (context) => SelectionBottomSheet(
                            selection: locationTypes,
                            selected: locationType ?? Selection(id: "id", name: "name"),
                            onSelect: (Selection type) {
                              if (type.id.isNotEmpty) {
                                locType = type.id;
                                locationType = type;
                                txtLocationType.text = type.name;
                                location = null;
                                txtLocation.clear();
                                customer = null;
                                txtCustomer.clear();
                                getLocation(locType);
                              }
                            },
                            header: "Select Location Type",
                          ));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                readOnly: true,
                controller: txtLocation,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    hintText: "Select Location"),
                onTap: () async {
                  if (locationType == null || locationType!.id.isEmpty) {
                    Utility.showToast("Please select location type");
                    return;
                  }

                  List<Selection> selection = [];
                  debugPrint("locationList--->$locationList");
                  await Future.forEach(
                      locationList, (LocationModel element) => selection.add(Selection(id: element.id, name: element.name)));

                  debugPrint("selection--->$selection");

                  if (selection.isEmpty) {
                    Utility.showToast("${locationType!.name} not found");
                    return;
                  }

                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      isScrollControlled: true,
                      builder: (context) => SelectionBottomSheet(
                            selection: selection,
                            selected: location ?? Selection(id: "id", name: "name"),
                            onSelect: (Selection type) {
                              if (type.id.isNotEmpty) {
                                location = type;
                                txtLocation.text = type.name;
                                customer = null;
                                txtCustomer.clear();
                              }
                            },
                            header: "Select Location",
                          ));
                },
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
                            selected: customerType ?? Selection(id: "id", name: "name"),
                            onSelect: (Selection type) {
                              if (type.id.isNotEmpty) {
                                if (customerType == null || customerType!.id != type.id) {
                                  customerType = type;
                                  txtCustomerType.text = type.name;
                                  customer = null;
                                  txtCustomer.clear();
                                  getCustomer();
                                }
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

                  if (selection.isEmpty) {
                    Utility.showToast("Customers not found");
                    return;
                  }

                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      isScrollControlled: true,
                      builder: (context) => SelectionBottomSheet(
                            selection: selection,
                            selected: customer ?? Selection(id: "id", name: "name"),
                            onSelect: (Selection type) {
                              if (type.id.isNotEmpty) {
                                customer = type;
                                // customerList.singleWhere((element) => element.id == type.id);
                                txtCustomer.text = type.name;
                              }
                            },
                            header: "Select Customer",
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
                      if (((DateFormat("dd-MM-yyyy").format(fromDate) == DateFormat("dd-MM-yyyy").format(toDate)) &&
                              DateFormat("dd-MM-yyyy").format(fromDate) != DateFormat("dd-MM-yyyy").format(DateTime.now())) &&
                          (customer == null || customer!.id.isEmpty)) {
                        Utility.showToast("Please select customer");
                      } else if (DateFormat("dd-MM-yyyy").parse(fromDate.toString()) !=
                              DateFormat("dd-MM-yyyy").parse(toDate.toString()) &&
                          (customer == null || customer!.id.isEmpty)) {
                        Utility.showToast("Please select customer");
                      } else if (locType.isNotEmpty && location == null) {
                        Utility.showToast("Please select location");
                      } else if (customerType != null && customer == null) {
                        Utility.showToast("Please select customer");
                      } else {
                        widget.onSelect(fromDate, toDate, locationType, location, customerType, customer);
                        Navigator.pop(context);
                      }
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
      Map<String, dynamic> input = {};

      input["location_type"] = locType.toLowerCase();
      input["location_id"] = location != null ? location!.id : "";
      input["cutomer_type_id"] = customerType != null ? customerType!.id : "";

      GetCustomerResponse response = await repository.getCustomers(input);
      if (response.success) {
        customerList = response.data;
      } else {
        customerList = [];
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  void getLocation(String locationType) async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = {"filter_type": locationType.toLowerCase() == "tehsil" ? "city" : locationType.toLowerCase()};

      GetLocationResponse response = await repository.getFilterLocation(input);

      debugPrint("response--->${response.data}");
      if (response.success) {
        locationList.clear();
        locationList.addAll(response.data);
        debugPrint("locationList--->$locationList");
      } else {
        locationList = [];
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
