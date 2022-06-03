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
  final Function(DateTime fromDate, DateTime toDate, String? locaitonType, LocationModel? location, CustomerType? customerType,
      Customer? customer) onSelect;
  final DateTime fromDate;
  final DateTime toDate;
  final LocationModel? location;
  final String locationType;
  final Customer? customer;
  final CustomerType? customerType;

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

  List<String> locationType = [
    "Zone",
    "State",
    "Division",
    "District",
    "Tahsil",
  ];
  String locType = "";

  CustomerType? customerType;
  Customer? customer;
  LocationModel? location;

  @override
  initState() {
    txtDate.text = DateFormat("dd/MM/yyyy").format(fromDate);

    customer = widget.customer;
    customerType = widget.customerType;
    location = widget.location;
    locType = widget.locationType;
    fromDate = widget.fromDate;
    toDate = widget.toDate;

    if (customer != null) {
      txtCustomer.text = customer!.customerName;
    }
    if (customerType != null) {
      txtCustomerType.text = customerType!.name;
    }
    if (locType.isNotEmpty) {
      txtLocationType.text = locType;
      getLocation(locType);
    }
    if (location != null) {
      txtLocation.text = location!.name;
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
                  List<Selection> selection = [
                    Selection(id: "Zone".toLowerCase(), name: "Zone"),
                    Selection(id: "State".toLowerCase(), name: "State"),
                    Selection(id: "Division".toLowerCase(), name: "Division"),
                    Selection(id: "District".toLowerCase(), name: "District"),
                    Selection(id: "city".toLowerCase(), name: "Tahsil")
                  ];

                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      isScrollControlled: true,
                      builder: (context) => SelectionBottomSheet(
                            selection: selection,
                            selected: Selection(id: "id", name: "name"),
                            onSelect: (Selection type) {
                              if (type.id.isNotEmpty) {
                                locType = type.id;
                                txtLocationType.text = type.name;
                                getLocation(locType.toLowerCase());
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
                  List<Selection> selection = [];
                  debugPrint("locationList--->${locationList}");
                  await Future.forEach(
                      locationList, (LocationModel element) => selection.add(Selection(id: element.id, name: element.name)));

                  debugPrint("selection--->${selection}");

                  showModalBottomSheet(
                      context: context,
                      shape: bottomSheetShape,
                      isScrollControlled: true,
                      builder: (context) => SelectionBottomSheet(
                            selection: selection,
                            selected: Selection(id: "id", name: "name"),
                            onSelect: (Selection type) {
                              if (type.id.isNotEmpty) {
                                location = LocationModel(
                                  id: type.id,
                                  name: type.name,
                                );
                                txtLocation.text = type.name;
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
                      } else if (fromDate != toDate && (customer == null || customer!.id.isEmpty)) {
                        Utility.showToast("Please select customer");
                      } else if (locType.isNotEmpty && location == null) {
                        Utility.showToast("Please select location");
                      } else if (customerType != null && customer == null) {
                        Utility.showToast("Please select customer");
                      } else {
                        widget.onSelect(fromDate, toDate, locType, location, customerType, customer);
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
      Map<String, dynamic> input = {"filter_type": locationType == "tahsil" ? "city" : locationType};

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
