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
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';

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
                            for (var element in beats) {
                              element.selected = false;
                            }
                            beats[index].selected = true;
                            beatsStreamController.add(beats);
                          },
                          singleItem: true,
                          // change to single beat selection
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
      Map<String, dynamic> input = {"day": widget.day};
      GetAllBeatsResponse response = await repository.getBeatByOrderBookingDay(input);
      if (response.success) {
        beats = response.data!;

        // await Future.forEach(beats, (BeatsModal bu) {
        //   int i = beats.indexWhere((element) => element.id == bu.id);
        //   if (i != -1) {
        //     beats[i].selected = true;
        //   }
        // });

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
      int i = beats.indexWhere((element) => element.selected);
      String beatId = "";
      if (i > -1) {
        BeatsModal b = beats[i];
        beatId = b.id;
      } else {
        Utility.showToast("Please select beat");
        return;
      }

      // if (selected.isNotEmpty) {
      //   for (int i = 0; i < selected.length; i++) {
      //     if (i == selected.length - 1) {
      //       beatId += selected[i].id;
      //     } else {
      //       beatId += selected[i].id + ",";
      //     }
      //   }
      // }

      LocationData? position = await MyLocation.getCurrentLocation();

      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["order_status"] = "1";
      input["beat_id"] = beatId;
      input["day"] = widget.day;

      input["retailer_type"] = retailerCheck && teleRetailerCheck
          ? ""
          : retailerCheck
              ? "1"
              : teleRetailerCheck
                  ? "2"
                  : "";

      if (position != null) {
        input["lat"] = position.latitude.toString();
        input["long"] = position.longitude.toString();
      } else {
        return;
      }

      EasyLoading.show(status: "Loading...");
      GetRetailersResponse response = await repository.getRoute(input);
      Utility.dismissLoading();
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

      List<Coords> cords = [];
      Coords dest = Coords(0.0, 0.0);

      LocationData? position = await MyLocation.getCurrentLocation();
      if (position != null) {
        source = position.latitude.toString() + "," + position.longitude.toString();
      } else {
        return;
      }

      String url = "";

      if (list.length > 1) {
        for (int i = 0; i < list.length; i++) {
          if (i == list.length - 1) {
            if (list[i].lat.isNotEmpty && list[i].lng.isNotEmpty) {
              destination = list[i].lat + "," + list[i].lng;
              waypoint += "${list[i].lat},${list[i].lng}";
              dest = Coords(double.parse(list[i].lat), double.parse(list[i].lng));
              cords.add(Coords(double.parse(list[i].lat), double.parse(list[i].lng)));
            }
          } else {
            if (list[i].lat.isNotEmpty && list[i].lng.isNotEmpty) {
              destination = list[i].lat + "," + list[i].lng;
              dest = Coords(double.parse(list[i].lat), double.parse(list[i].lng));
              waypoint += "${list[i].lat},${list[i].lng}|";

              cords.add(Coords(double.parse(list[i].lat), double.parse(list[i].lng)));
            }
          }
        }
      } else {
        destination = list.first.lat + "," + list.first.lng;
        dest = Coords(double.parse(list.first.lat), double.parse(list.first.lng));
      }

      debugPrint("source---->$source");
      debugPrint("destination---->$destination");
      debugPrint("cords---->$cords");

      MapLauncher.showDirections(
          destination: dest,
          origin: Coords(position.latitude!, position.longitude!),
          directionsMode: DirectionsMode.driving,
          waypoints: cords,
          mapType: MapType.google);
    } catch (exception) {
      debugPrint("exception---->$exception");
      Utility.showToast("Unable to get route...");
    }
  }
}
