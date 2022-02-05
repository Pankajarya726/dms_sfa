import 'dart:collection';

import 'package:dms/main.dart';
import 'package:dms/model/base_response.dart';
import 'package:dms/ui/drawer_screen/drawer_screen.dart';
import 'package:dms/ui/start_my_day/model/end_my_day_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/my_location.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class EndDayScreen extends StatefulWidget {
  final StartDayData startDayData;

  const EndDayScreen(this.startDayData, {Key? key}) : super(key: key);

  @override
  _EndDayScreenState createState() => _EndDayScreenState();
}

class _EndDayScreenState extends State<EndDayScreen> {
  TextEditingController edtRemark = TextEditingController();
  TextEditingController edtTc = TextEditingController();
  TextEditingController edtPc = TextEditingController();
  TextEditingController edtTotalSale = TextEditingController();
  TextEditingController edtAverageSale = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    // widget.startDayData.secondaryTag.add(SecondaryTag(id: 1, name: "asdfadsf "));
    // widget.startDayData.secondaryTag.add(SecondaryTag(id: 1, name: "asdfadsf "));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 15,
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 1,
        title: const Text(
          "End My Day",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Primary Tag",
              style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Tags(
              itemCount: 1,
              itemBuilder: (index) {
                return ItemTags(
                  index: index,
                  title: widget.startDayData.primaryTag.name,
                  active: true,
                  textActiveColor: Colors.black,
                  textColor: const Color(0xff555555),
                  elevation: 0,
                  textStyle: const TextStyle(color: Colors.black, fontSize: 16, letterSpacing: 0.5, fontWeight: FontWeight.normal),

                  // textStyle: const TextStyle(fontSize: 16),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: Border.all(color: MColor.colorPrimary),
                  singleItem: true,
                  activeColor: const Color(0xffFFC9CC),
                  color: const Color(0xffFFC9CC),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Secondary Tag",
              style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Tags(
              itemCount: widget.startDayData.secondaryTag.length,
              alignment: WrapAlignment.start,
              itemBuilder: (index) {
                return ItemTags(
                  index: index,
                  title: widget.startDayData.secondaryTag[index].name,
                  active: true,
                  pressEnabled: false,
                  textActiveColor: Colors.black,
                  elevation: 0,
                  textStyle: const TextStyle(color: Colors.black, fontSize: 16, letterSpacing: 0.5, fontWeight: FontWeight.normal),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: Border.all(color: MColor.colorPrimary),
                  activeColor: const Color(0xffFFC9CC),
                  color: const Color(0xffFFC9CC),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "TC *",
                        style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: edtTc,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: const InputDecoration(counterText: ""),
                        onChanged: (text) {
                          edtPc.text = "0";
                          edtTotalSale.text = "0";
                          edtAverageSale.text = "0";
                          edtTc.text = int.parse(text.trim()).toString();
                          edtTc.selection = TextSelection(baseOffset: edtTc.text.length, extentOffset: edtTc.text.length);
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PC *",
                        style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: edtPc,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: const InputDecoration(counterText: ""),
                        onChanged: (text) {
                          edtPc.text = int.parse(text.trim()).toString();
                          text = int.parse(text.trim()).toString();

                          if (edtTc.text.trim().isEmpty) {
                            Utility.showToast("Please enter TC first");
                            edtPc.clear();
                            edtPc.selection = TextSelection(baseOffset: edtPc.text.length, extentOffset: edtPc.text.length);
                            return;
                          }

                          if (int.parse(text.trim()) > int.parse(edtTc.text.trim().toString())) {
                            edtPc.text = "0";
                            Utility.showToast("PC can not be greater than TC");
                            edtPc.selection = TextSelection(baseOffset: edtPc.text.length, extentOffset: edtPc.text.length);
                            return;
                          }

                          if (text.trim() == "0") {
                            edtPc.text = "0";
                            edtAverageSale.text = "0";
                            edtTotalSale.text = "0";
                            edtPc.selection = (TextSelection(baseOffset: edtPc.text.length, extentOffset: edtPc.text.length));
                            return;
                          }

                          if (text.trim().isNotEmpty && edtTotalSale.text.trim().isNotEmpty && int.parse(text.trim()) != 0) {
                            double totalSale = double.parse(edtTotalSale.text.trim());
                            double profitCall = double.parse(text);
                            double average = totalSale / profitCall;
                            edtAverageSale.text = average.toStringAsFixed(2);
                          }
                          edtPc.selection = (TextSelection(baseOffset: edtPc.text.length, extentOffset: edtPc.text.length));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Total Sale Amount *",
              style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: edtTotalSale,
              maxLength: 10,
              decoration: const InputDecoration(counterText: ""),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: (text) {
                text = int.parse(text.trim()).toString();
                edtTotalSale.text = int.parse(text.trim()).toString();
                if (edtPc.text.trim().isEmpty || int.parse(edtPc.text.trim()) == 0) {
                  edtTotalSale.text = "0";
                  edtAverageSale.text = "0";
                  Utility.showToast("Please enter TC-PC first");
                  edtTotalSale.selection = TextSelection(baseOffset: edtTotalSale.text.length, extentOffset: edtTotalSale.text.length);
                  return;
                }
                if (text.trim().isNotEmpty && edtPc.text.trim().isNotEmpty && int.parse(edtPc.text.trim()) != 0) {
                  double totalSale = double.parse(text);
                  double profitCall = double.parse(edtPc.text.trim());
                  double average = totalSale / profitCall;
                  edtAverageSale.text = average.toStringAsFixed(2);
                }
                edtTotalSale.selection = TextSelection(baseOffset: edtTotalSale.text.length, extentOffset: edtTotalSale.text.length);
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Avg Sale Amount *",
              style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: edtAverageSale,
              readOnly: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,5}')),
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Remark",
              style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: edtRemark,
              keyboardType: TextInputType.text,
              minLines: 3,
              maxLines: 5,
              maxLength: 250,
              decoration: const InputDecoration(counterText: ""),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: MaterialButton(
          onPressed: () {
            submit(context);
          },
          height: 50,
          elevation: 0,
          color: MColor.colorSecondary,
          shape: const RoundedRectangleBorder(),
          child: const Text(
            "END DAY",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }

  void submit(BuildContext context) async {
    if (edtTc.text.isEmpty) {
      Utility.showToast("Please enter TC");
      return;
    }
    if (edtPc.text.isEmpty) {
      Utility.showToast("Please enter PC");
      return;
    }
    if (edtTotalSale.text.isEmpty) {
      Utility.showToast("Please enter Total sale amount");
      return;
    }

    if ((int.parse(edtPc.text.trim().toString())) > (int.parse(edtTc.text.trim().toString()))) {
      Utility.showToast("PC can not be grater than TC");
      return;
    }

    if (int.parse(edtPc.text.trim()) > 0 && edtTotalSale.text.trim() == "0") {
      Utility.showToast("Please enter Total sale amount");
      return;
    }

    if (edtAverageSale.text.isEmpty) {
      Utility.showToast("Please enter Average sale amount");
      return;
    }
    DateTime _ntpTime = await NTP.now();

    try {
      Position position = await MyLocation.getCurrentLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String locality = place.locality!;
      String name = place.name!;
      String postalCode = place.postalCode!;
      String street = place.street!;
      String subLocality = place.subLocality!;
      String address = "";
      if (street == name) {
        address = street + " " + subLocality + " " + locality + " " + postalCode;
      } else {
        address = street + " " + name + " " + subLocality + " " + locality + " " + postalCode;
      }
      Map input = HashMap<String, dynamic>();
      input["user_id"] = await Utility.getStringPreference(SharedPreference.userId);
      input["start_day_date"] = DateFormat("yyyy-MM-dd").format(_ntpTime);
      input["end_day_time"] = "${_ntpTime.hour}:${_ntpTime.minute}:${_ntpTime.second}";
      input["end_day_address"] = address;
      input["end_day_latitude"] = position.latitude.toString();
      input["end_day_longitude"] = position.longitude.toString();
      input["total_visit"] = edtTc.text.trim().toString();
      input["total_order"] = edtPc.text.trim().toString();
      input["total_sale_amount"] = edtTotalSale.text.trim().toString();
      input["avg_sale_value"] = edtAverageSale.text.trim().toString();
      input["end_day_remark"] = edtRemark.text.trim();
      debugPrint("input-->$input");
      confirmEndDayApi(input);
    } catch (exception) {
      debugPrint("exception--->$exception");
      return;
    }
  }

  void confirmEndDayApi(Map input) async {
    if (await Network.isConnected()) {
      EasyLoading.show();
      BaseResponse response = await repository.confirmEndDay(input);
      EasyLoading.dismiss();
      Utility.showToast(response.message);

      if (response.success) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DrawerScreen()), (route) => false);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
