import 'dart:collection';

import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailer_bloc.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailers_event.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailers_state.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailers_tab.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/my_location.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteBottomSheet extends StatefulWidget {
  final String day;

  const RouteBottomSheet({
    required this.day,
    Key? key,
  }) : super(key: key);

  @override
  _RouteBottomSheetState createState() => _RouteBottomSheetState();
}

class _RouteBottomSheetState extends State<RouteBottomSheet> {
  TextEditingController edtBookingDay = TextEditingController();
  TextEditingController edtPriority = TextEditingController();

  String selectedPrioType = "";
  List<BeatsModal> beats = [];
  BeatsModal beatModal = BeatsModal(id: "", name: "All");
  bool retailerCheck = false;
  bool teleRetailerCheck = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: IntrinsicHeight(
        child: BlocProvider(
          create: (context) => RetailersBloc(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // shrinkWrap: false,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                StringConst.route,
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
              const Text(
                StringConst.selectBeat,
                style: TextStyle(
                  color: MColor.inactiveTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.67,
                ),
              ),
              BlocBuilder<RetailersBloc, RetailerState>(builder: (context, state) {
                if (state is RetailerInitState) {
                  BlocProvider.of<RetailersBloc>(context).add(GetBeatEvent());
                }
                if (state is GetBeatState) {
                  beats = state.beats;
                  beatModal = beats.first;
                }
                return SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: BeatWidget(
                    selectedBeat: beatModal,
                    tags: beats,
                    onSelect: (BeatsModal tag) {
                      debugPrint("onBeatSelect-->${tag.name}");
                      beatModal = tag;
                    },
                  ),
                );
              }),
              const Text(
                StringConst.selectEnrolmentType,
                style: TextStyle(
                  color: MColor.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.67,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CheckboxListTile(
                title: const Text(StringConst.retailer),
                value: retailerCheck,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    retailerCheck = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text(StringConst.teleRetailer),
                value: teleRetailerCheck,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    teleRetailerCheck = value!;
                  });
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        getRetailers();

                        // Navigator.pop(context, data);
                      },
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      color: MColor.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                      child: const Text(
                        StringConst.getRoute,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getRetailers() async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["order_status"] = "1";
      input["beat_id"] = beatModal.id;
      input["day"] = widget.day;
      input["retailer_type"] = retailerCheck && teleRetailerCheck
          ? ""
          : retailerCheck
              ? "1"
              : teleRetailerCheck
                  ? "2"
                  : "";
      EasyLoading.show(status: "Loading...");
      GetRetailersResponse response = await repository.getRetailersOrderWise(input);
      EasyLoading.dismiss();
      if (response.success) {
        if (response.data!.isNotEmpty) {
          getRoute(response.data!);
        }
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  void getRoute(List<RetailersModal> list) async {
    try {
      String waypoint = "";
      String destination = "";
      String source = "";

      Position position = await MyLocation.getCurrentLocation();
      source = position.latitude.toString() + "," + position.longitude.toString();

      String url = "";

      if (list.length > 1) {
        destination = list.last.lat + "," + list.last.lng;
        for (int i = 0; i < list.length - 1; i++) {
          if (i == list.length - 1) {
            if (list[i].lat.isNotEmpty && list[i].lng.isNotEmpty) {
              waypoint += "${list[i].lat},${list[i].lng}";
            }
          } else {
            if (list[i].lat.isNotEmpty && list[i].lng.isNotEmpty) {
              waypoint += "${list[i].lat},${list[i].lng}|";
            }
          }
        }
      } else {
        destination = list.first.lat + "," + list.first.lng;
      }
      debugPrint("source---->$source");
      debugPrint("destination---->$destination");
      debugPrint("waypoint---->$waypoint");

      // source = "22.715088511443923,75.86964084100623";
      // destination = "22.71776838847584,75.85447157736643";
      // waypoint =
      //     "22.716526236699924,75.86440962634244|22.717271529118445,75.86255129198103|22.718526305557464,75.86029141716736|22.71882987877391,75.85717586159898";

      url =
          'https://www.google.com/maps/dir/?api=1&origin=$source&destination=$destination&waypoints=$waypoint&travelmode=driving&dir_action=navigate';
      debugPrint("url---->$url");
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Utility.showToast("Unable to get route...");
      }
    } catch (exception) {
      debugPrint("exception---->$exception");
      Utility.showToast("Unable to get route...");
    }
  }
}
