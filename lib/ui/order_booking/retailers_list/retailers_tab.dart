import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:dms/listeners/select_beat_listerner.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailer_list_item.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_bloc.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_events.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';

class RetailerTab extends StatefulWidget {
  final int index;
  final BeatsModal selectedBeat;
  final Function(SelectBeatListener listener) onInit;

  const RetailerTab({
    Key? key,
    required this.index,
    required this.onInit,
    required this.selectedBeat,
  }) : super(key: key);

  @override
  _RetailerTabState createState() => _RetailerTabState();
}

class _RetailerTabState extends State<RetailerTab>
    implements SelectBeatListener {
  List<RetailersModal> retailers = [];
  List<BeatsModal> beatList = [];
  BeatsModal? selectedBeat;
  String tag = "All";
  StreamController<List<RetailersModal>> retailerStreamController =
      StreamController();
  String day = "";
  String retailerType = "";
  // RetailersBloc retailersBloc = RetailersBloc();
  double latitude = 0.0;
  double longitude = 0.0;
  String sortingType = "";

  @override
  void initState() {
    debugPrint("initState--->${widget.selectedBeat.id}");
    widget.onInit(this);
    selectedBeat ??= widget.selectedBeat;
    day = DateFormat.EEEE().format(DateTime.now());
    getRetailers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = BlocProvider(
      create: (context) => UserLocationBloc(),
      child: BlocBuilder<UserLocationBloc, UserLocationStates>(
        builder: (context, state) {
          debugPrint("state---->$state");
          if (state is UserLocationInitialState) {
            BlocProvider.of<UserLocationBloc>(context)
                .add(GetUserLocationEvent());
          }

          if (state is GetUserLocationState) {
            latitude = state.latitude;
            longitude = state.longitude;
          }

          if (state is UserLocationFailureState) {
            Fluttertoast.showToast(
                msg: "Please turn on GPS to get current location");
          }
          return Container();
        },
      ),
    );

    return Column(
      children: [
        // BeatWidget(
        //     tags: beatList,
        //     onSelect: (BeatsModal tag) {
        //       if (selectedBeat != tag) {
        //         selectedBeat = tag;
        //         getRetailers();
        //       }
        //     }),

        userLocation,
        Expanded(
          child: StreamBuilder<List<RetailersModal>>(
            stream: retailerStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(15),
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 15,
                  );
                },
                itemBuilder: (context, index) {
                  return RetailerListItems(
                    index: widget.index,
                    retailer: snapshot.data![index],
                    beatId: selectedBeat!.id,
                    orderStatus: widget.index == 0
                        ? 1
                        : widget.index == 1
                            ? 2
                            : 3,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void getRetailers() async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["order_status"] = widget.index;
      input["beat_id"] = selectedBeat!.id;
      input["day"] = day;
      input["retailer_type"] = retailerType;
      GetRetailersResponse response =
          await repository.getRetailersOrderWise(input);
      if (response.success) {
        retailers = response.data!;
        for (var element in retailers) {
          element.setDistance(getDistance(element.lat, element.lng));
        }
        retailerStreamController.add(retailers);
        if (sortingType.isNotEmpty) {
          onSorting(sortingType);
        }
        debugPrint("response = ${response.message}");
      } else {
        retailerStreamController.addError(response.message);
      }
    } else {
      retailerStreamController.addError(StringConst.internetCheck);
    }
  }

  @override
  void onBeatSelect(BeatsModal beatsModal, String day, String type) {
    selectedBeat = beatsModal;
    if (day.isEmpty) {
      this.day = DateFormat.EEEE().format(DateTime.now());
    } else {
      this.day = day;
    }

    if (type == StringConst.retailer) {
      retailerType = "1";
    } else if (type == StringConst.teleRetailer) {
      retailerType = "2";
    } else {
      retailerType = "";
    }
    getRetailers();
  }

  @override
  void onSorting(String type) {
    sortingType = type;
    if (type == StringConst.retailer) {
      retailers.sort((a, b) =>
          a.enrollmentTypeId.compareTo(b.enrollmentTypeId)); // ascending order
      retailerStreamController.add(retailers);
    }

    if (type == StringConst.teleRetailer) {
      retailers.sort((a, b) =>
          b.enrollmentTypeId.compareTo(a.enrollmentTypeId)); // descending order
      retailerStreamController.add(retailers);
    }

    if (type == StringConst.nearby) {
      retailers
          .sort((a, b) => a.distance.compareTo(b.distance)); // ascending order
      retailerStreamController.add(retailers);
    }
  }

// convert latitude and longitude into distance
  String getDistance(passedLat, passedLng) {
    double lat1 = latitude;
    double lon1 = longitude;
    double lat2 = double.parse(passedLat);
    double lon2 = double.parse(passedLng);
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double d = 12742 * asin(sqrt(a));
    // print("distance after converting into kilometers = $d");
    return d.toStringAsFixed(2);
  }
}

class BeatWidget extends StatefulWidget {
  final List<BeatsModal> tags;
  final Function(BeatsModal tag) onSelect;

  const BeatWidget({Key? key, required this.tags, required this.onSelect})
      : super(key: key);

  @override
  _BeatWidgetState createState() => _BeatWidgetState();
}

class _BeatWidgetState extends State<BeatWidget> {
  BeatsModal tag = BeatsModal(name: "All", id: "");

  @override
  void initState() {
    super.initState();
    widget.onSelect(tag);
  }

  @override
  Widget build(BuildContext context) {
    return Tags(
      direction: Axis.horizontal,
      itemCount: widget.tags.length,
      horizontalScroll: true,
      itemBuilder: (index) {
        return ItemTags(
          index: index,
          onPressed: (item) {
            tag = item.customData;
            widget.onSelect(item.customData);
            setState(() {});
          },
          active: widget.tags[index].name == tag.name,
          customData: widget.tags[index],
          textActiveColor: Colors.black,
          textColor: const Color(0xff555555),
          elevation: 0,
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          border: Border.all(
              color: widget.tags[index].name == tag.name
                  ? MColor.colorPrimary
                  : const Color(0xffC5C5C5),
              width: 1.5),
          singleItem: true,
          activeColor: widget.tags[index].name == tag.name
              ? const Color(0xffFFC9CC)
              : const Color(0xffFAFAFA),
          color: widget.tags[index].name == tag.name
              ? const Color(0xffFFC9CC)
              : const Color(0xffFAFAFA),
          title: widget.tags[index].name,
        );
      },
    );
  }
}


// retailersBloc.add(GetRetailerEvent(
    //     status: widget.index,
    //     beatId: selectedBeat!.id,
    //     day: "friday",
    //     retailerType: retailerType));
// get retailers using bloc
        // Expanded(
        //   child: BlocProvider(
        //     create: (context) => retailersBloc,
        //     child: BlocBuilder<RetailersBloc, RetailerState>(
        //       builder: (context, state) {
        //         if (state is RetailerInitState) {
        //           retailersBloc.add(GetRetailerEvent(
        //               status: widget.index,
        //               beatId: selectedBeat!.id,
        //               day: "friday",
        //               retailerType: retailerType));
        //         }
        //         if (state is RetailerLoadingState) {
        //           return const Center(
        //             child: CircularProgressIndicator(),
        //           );
        //         }
        //         if (state is GetRetailersState) {
        //           retailers = state.retailers;
        //         }
        //         if (state is RetailerFailureState) {
        //           return Center(
        //             child: Text(state.msg),
        //           );
        //         }
        //         return ListView.separated(
        //           padding: const EdgeInsets.all(15),
        //           itemCount: retailers.length,
        //           separatorBuilder: (context, index) {
        //             return const SizedBox(
        //               height: 15,
        //             );
        //           },
        //           itemBuilder: (context, index) {
        //             return RetailerListItems(
        //               index: widget.index,
        //               retailer: retailers[index],
        //               beatId: selectedBeat!.id,
        //               orderStatus: widget.index == 0
        //                   ? 1
        //                   : widget.index == 1
        //                       ? 2
        //                       : 3,
        //             );
        //           },
        //         );
        //       },
        //     ),
        //   ),
        // ),
