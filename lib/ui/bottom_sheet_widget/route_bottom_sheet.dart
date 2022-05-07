import 'dart:async';
import 'dart:collection';

import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailer_bloc.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/my_location.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
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
  StreamController<List<BeatsModal>> beatsStreamController = StreamController();

  @override
  void initState() {
    getBeats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
        minHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocProvider(
          create: (context) => RetailersBloc(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder<List<BeatsModal>>(
                  stream: beatsStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(
                        snapshot.error.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.67,
                        ),
                      );
                    }

                    if (beats.isEmpty) {
                      return Container();
                    }

                    if (snapshot.hasData) {
                      beats = snapshot.data!;
                    }

                    return Tags(
                      itemCount: beats.length,
                      runSpacing: 8,
                      spacing: 10,
                      alignment: WrapAlignment.start,
                      itemBuilder: (index) {
                        return ItemTags(
                          index: index,
                          customData: beats[index],
                          title: beats[index].name,
                          textColor: MColor.textColor,
                          active: beats[index].selected,
                          textActiveColor: MColor.activeTextColor,
                          pressEnabled: true,
                          onPressed: (item) {
                            beats[index].selected = !beats[index].selected;

                            beatsStreamController.add(beats);
                          },
                          singleItem: false,
                          elevation: 0,
                          activeColor: const Color(0xffFFC9CC),
                          border: Border.all(color: beats[index].selected ? MColor.colorPrimary : const Color(0xffc5c5c5), width: 1),
                          color: const Color(0xffFAFAFA),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
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
      ),
    );
  }

  void getBeats() async {
    if (await Network.isConnected()) {
      DateTime dateTime = await NTP.now().timeout(const Duration(seconds: 5), onTimeout: () {
        return DateTime.now();
      });
      Map<String, dynamic> input = {"day": DateFormat("EEEE").format(dateTime)};
      GetAllBeatsResponse response = await repository.getBeatByOrderBookingDay(input);
      if (response.success) {
        beats = response.data!;

        await Future.forEach(beats, (BeatsModal bu) {
          int i = beats.indexWhere((element) => element.id == bu.id);
          if (i != -1) {
            beats[i].selected = true;
          }
        });

        beatsStreamController.add(beats);
      } else {
        beatsStreamController.addError(response.message);
      }
    } else {
      beatsStreamController.addError(StringConst.internetCheck);
    }
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
