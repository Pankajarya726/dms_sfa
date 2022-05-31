import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:dms/listeners/select_beat_listener.dart';
import 'package:dms/ui/custom_widget/no_internet.dart';
import 'package:dms/ui/custom_widget/retailer_not_found.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailer_list_item.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_bloc.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_events.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/my_location.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../main.dart';

class RetailerTab extends StatefulWidget {
  final int index;
  final BeatsModal selectedBeat;
  final String day;
  final Function(SelectBeatListener listener) onInit;

  const RetailerTab({
    Key? key,
    required this.index,
    required this.onInit,
    required this.day,
    required this.selectedBeat,
  }) : super(key: key);

  @override
  _RetailerTabState createState() => _RetailerTabState();
}

class _RetailerTabState extends State<RetailerTab> implements SelectBeatListener {
  List<RetailersModal> retailers = [];
  BeatsModal? selectedBeat;
  StreamController<List<RetailersModal>> retailerStreamController = StreamController();
  String day = "";
  String retailerType = "";
  int pageNo = 1;

  double latitude = 0.0;
  double longitude = 0.0;
  String sortingType = "";
  UserLocationBloc userLocationBloc = UserLocationBloc();
  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    debugPrint("RetailerTab-->initState--->${widget.selectedBeat.name}");
    widget.onInit(this);
    selectedBeat ??= widget.selectedBeat;
    day = widget.day.isEmpty ? DateFormat.EEEE().format(DateTime.now()) : widget.day;
    retailerStreamController.addError("loading");
    getRetailers();
    getLocation();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RetailerTab oldWidget) {
    debugPrint("RetailerTab-->didUpdateWidget--->${widget.selectedBeat.id}");
    debugPrint("RetailerTab-->didUpdateWidget--->${oldWidget.selectedBeat.id}");
    selectedBeat = widget.selectedBeat;
    day = widget.day;
    userLocationBloc.add(GetUserLocationEvent());
    retailers.clear();
    pageNo = 1;
    retailerStreamController.addError("loading");
    getRetailers();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrint("retailer_tab --> deactivate");
    super.deactivate();
  }

  @override
  void reassemble() {
    debugPrint("retailer_tab --> reassemble");
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = BlocProvider(
      create: (context) => userLocationBloc,
      child: BlocBuilder<UserLocationBloc, UserLocationStates>(
        builder: (context, state) {
          debugPrint("state---->$state");
          if (state is UserLocationInitialState) {
            userLocationBloc.add(GetUserLocationEvent());
          }

          if (state is GetUserLocationState) {
            latitude = state.latitude;
            longitude = state.longitude;
          }

          if (state is UserLocationFailureState) {
            Utility.showToast("Please turn on GPS to get current location");
          }
          return Container();
        },
      ),
    );

    return Column(
      children: [
        // userLocation,
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
                if (snapshot.error.toString() == "loading") {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: NoInternetConnection(onRefresh: () {
                      getRetailers();
                    }),
                  );
                }
              }

              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(
                  child: RetailerNotFound(
                    onRefresh: () {
                      pageNo = 1;
                      retailers.clear();
                      retailerStreamController.addError("loading");
                      getRetailers();
                    },
                  ),
                );
              }

              return SmartRefresher(
                primary: false,
                controller: refreshController,
                onRefresh: onRefresh,
                enablePullDown: true,
                enablePullUp: true,
                onLoading: () {
                  getRetailers();
                },
                footer: CustomFooter(
                  builder: (context, loadStatus) {
                    if (loadStatus == LoadStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container();
                  },
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void getRetailers() async {
    debugPrint("getRetailers-->$pageNo${selectedBeat!.id}");
    // retailers.clear();
    int page = pageNo;

    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["order_status"] = widget.index;
      input["beat_id"] = selectedBeat!.id;
      input["day"] = day;
      input["page_no"] = pageNo;
      input["lat"] = latitude;
      input["long"] = longitude;
      input["sort_by"] = sortingType;
      input["retailer_type"] = retailerType;

      GetRetailersResponse response = await repository.getRetailersOrderWise(input);
      refreshController.loadComplete();
      refreshController.refreshCompleted();
      if (response.success) {
        pageNo = pageNo + 1;
        retailers.addAll(response.data!);
        retailerStreamController.add(retailers);
      } else {
        debugPrint("pageNo-->$pageNo---$page");
        if (pageNo == 1) {
          retailerStreamController.add([]);
        }
        // retailerStreamController.add([]);
      }
    } else {
      retailerStreamController.addError(StringConst.internetCheck);
    }
  }

  @override
  void onBeatSelect(BeatsModal beatsModal, String day, String type) {
    if (selectedBeat!.id == beatsModal.id && day == this.day) {
      return;
    }

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

    retailers.clear();
    pageNo = 1;
    retailerStreamController.addError("loading");
    getRetailers();
  }

  @override
  void onSorting(String type) {
    debugPrint("onSorting-->$type");

    if (type == StringConst.retailer) {
      sortingType = "1";
      // retailers.sort((a, b) => a.enrollmentTypeId.compareTo(b.enrollmentTypeId)); // ascending order
      // retailerStreamController.add(retailers);
    }

    if (type == StringConst.teleRetailer) {
      sortingType = "2";
      // retailers.sort((a, b) => b.enrollmentTypeId.compareTo(a.enrollmentTypeId)); // descending order
      // retailerStreamController.add(retailers);
    }

    if (type == StringConst.nearby) {
      sortingType = "3";
      // retailers.sort((a, b) => a.distance.compareTo(b.distance)); // ascending order
      // retailerStreamController.add(retailers);
    }
    retailers.clear();
    pageNo = 1;
    retailerStreamController.addError("loading");
    getRetailers();
  }

  // convert latitude and longitude into distance
  String getDistance(String passedLat, String passedLng) {
    debugPrint("getDistance-->\t lat $passedLat long $passedLng");
    if (passedLng.isEmpty) {
      passedLng = "0.0";
    }
    if (passedLat.isEmpty) {
      passedLat = "0.0";
    }
    double lat1 = latitude;
    double lon1 = longitude;
    double lat2 = double.parse(passedLat);
    double lon2 = double.parse(passedLng);
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double d = 12742 * asin(sqrt(a));
    // print("distance after converting into kilometers = $d");
    return d.toStringAsFixed(2);
  }

  void onRefresh() async {
    retailers.clear();
    pageNo = 1;
    getRetailers();
    retailerStreamController.addError("loading");
    refreshController.refreshCompleted();
  }

  void getLocation() async {
    Position position = await MyLocation.getCurrentLocation();
    latitude = position.latitude;
    longitude = position.longitude;
  }
}

class BeatWidget extends StatefulWidget {
  final List<BeatsModal> tags;
  final Function(BeatsModal tag) onSelect;
  final BeatsModal? selectedBeat;

  const BeatWidget({
    Key? key,
    required this.tags,
    required this.onSelect,
    required this.selectedBeat,
  }) : super(key: key);

  @override
  _BeatWidgetState createState() => _BeatWidgetState();
}

class _BeatWidgetState extends State<BeatWidget> {
  BeatsModal tag = BeatsModal(name: "All", id: "");

  @override
  void initState() {
    if (widget.tags.length > 1) {
      if (widget.selectedBeat == null) {
        widget.onSelect(tag);
      } else {
        tag = widget.selectedBeat!;
        widget.onSelect(tag);
      }
    } else {
      if (widget.tags.isEmpty) {
        tag = BeatsModal(name: "", id: "");
        widget.onSelect(tag);
      } else {
        tag = widget.selectedBeat!;
        widget.onSelect(tag);
      }
    }
    super.initState();
  }

  @override
  void didUpdateWidget(BeatWidget oldWidget) {
    if (widget.selectedBeat != null) {
      tag = widget.selectedBeat!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Tags(
      direction: Axis.horizontal,
      itemCount: widget.tags.length,
      horizontalScroll: true,
      itemBuilder: (index) {
        return Padding(
          padding: index == 0
              ? const EdgeInsets.only(left: 10)
              : widget.tags[index] == widget.tags.last
                  ? const EdgeInsets.only(right: 10)
                  : const EdgeInsets.all(0),
          child: ItemTags(
            index: index,
            onPressed: (item) {
              tag = item.customData;
              widget.onSelect(item.customData);
              setState(() {});
            },
            active: widget.tags[index].name == tag.name,
            customData: widget.tags[index],
            textActiveColor: widget.tags[index].name == tag.name ? Colors.black : const Color(0xff555555),
            textColor: widget.tags[index].name == tag.name ? Colors.black : const Color(0xff555555),
            elevation: 0,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            border: Border.all(color: widget.tags[index].name == tag.name ? MColor.colorPrimary : const Color(0xffC5C5C5), width: 1.5),
            singleItem: true,
            activeColor: widget.tags[index].name == tag.name ? const Color(0xffFFC9CC) : const Color(0xffFAFAFA),
            color: widget.tags[index].name == tag.name ? const Color(0xffFFC9CC) : const Color(0xffFAFAFA),
            title: widget.tags[index].name,
          ),
        );
      },
    );
  }
}
