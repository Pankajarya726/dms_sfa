import 'dart:async';
import 'dart:collection';
import 'package:dms/listeners/pop_up_menu_listener.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/custom_widget/drop_down_field.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailer_bloc.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterRetailerBottomSheet extends StatefulWidget {
  final String day;
  final String type;
  final BeatsModal beat;
  final List<BeatsModal> beatList;
  final Function(String day, String type, BeatsModal selectedBeat,
      List<BeatsModal> beatList) onFilter;

  const FilterRetailerBottomSheet({
    Key? key,
    required this.onFilter,
    required this.day,
    required this.type,
    required this.beat,
    required this.beatList,
  }) : super(key: key);

  @override
  _FilterRetailerBottomSheetState createState() =>
      _FilterRetailerBottomSheetState();
}

class _FilterRetailerBottomSheetState extends State<FilterRetailerBottomSheet> {
  TextEditingController edtBookingDay = TextEditingController();
  TextEditingController edtPriority = TextEditingController();

  List<String> days = [
    StringConst.monday,
    StringConst.tuesday,
    StringConst.wednesday,
    StringConst.thursday,
    StringConst.friday,
    StringConst.saturday,
    StringConst.sunday,
  ];
  List<String> priorityType = [
    StringConst.retailer,
    StringConst.teleRetailer,
  ];
  String selectedDay = "";
  String seleBeat = "";
  String selectedEnrollmentType = "";
  BeatsModal? beatsModal;
  List<BeatsModal> beats = [];
  PopUpMenuListener? popUpMenuListener;
  StreamController<String> beatsStreamController = StreamController();

  @override
  void initState() {
    selectedDay = widget.day;
    selectedEnrollmentType = widget.type;
    if (widget.beatList.isNotEmpty) {
      beatsModal = widget.beat;
      if (widget.beat.name == "") {
        seleBeat = "Select Beat";
      } else {
        seleBeat = widget.beat.name;
      }
    } else {
      seleBeat = "Beats not found";
    }
    debugPrint("FilterRetailerBottomSheet");
    beats = widget.beatList;
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
                DropDownField(
                  onMenuItemSelected: (listener) {},
                  prevSelected: selectedDay,
                  onSelect: (value) {
                    debugPrint("select-->$value");
                    selectedDay = value;
                    beats.clear();
                    if (popUpMenuListener != null) {
                      seleBeat = "Select Beat";
                      popUpMenuListener!.onMenuItemSelect(seleBeat);
                    }
                    getBeats();
                  },
                  hint: "Select Order Booking Day",
                  menuList: days,
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<String>(
                    stream: beatsStreamController.stream,
                    initialData: seleBeat,
                    builder: (context, snapshot) {
                      if (snapshot.error == "loading") {
                        seleBeat = "Loading beats...";
                        return DropDownField(
                          onMenuItemSelected: (listener) {
                            popUpMenuListener = listener;
                          },
                          prevSelected: seleBeat,
                          onSelect: (value) {
                            debugPrint("select-->$value");
                          },
                          hint: seleBeat,
                          menuList: days,
                          beats: beats,
                          onBeatSelected: (beatsM) {
                            if (beatsM != null) {
                              beatsModal = beatsM;
                            }
                          },
                        );
                      }

                      if (snapshot.hasData) {
                        return DropDownField(
                          onMenuItemSelected: (listener) {
                            popUpMenuListener = listener;
                          },
                          prevSelected: seleBeat,
                          onSelect: (value) {
                            debugPrint("select-->$value");
                          },
                          hint: seleBeat,
                          menuList: days,
                          beats: beats,
                          onBeatSelected: (beatsM) {
                            if (beatsM != null) {
                              beatsModal = beatsM;
                            }
                          },
                        );
                      }
                      return Container();
                    }),
                const SizedBox(
                  height: 20,
                ),
                DropDownField(
                  onMenuItemSelected: (listener) {},
                  prevSelected: selectedEnrollmentType,
                  onSelect: (value) {
                    debugPrint("select-->");
                    selectedEnrollmentType = value;
                  },
                  hint: "Select Outlet Type",
                  menuList: priorityType,
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          widget.onFilter(
                              selectedDay,
                              selectedEnrollmentType,
                              beatsModal != null
                                  ? beatsModal!
                                  : (beats.length > 1
                                      ? BeatsModal(id: "", name: "All")
                                      : BeatsModal(id: "", name: "")),
                              beats);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getBeats() async {
    if (await Network.isConnected()) {
      beatsStreamController.addError("loading");
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["day"] = selectedDay;
      GetAllBeatsResponse response =
          await repository.getBeatByOrderBookingDay(input);
      beats.clear();
      beatsModal = null;
      if (response.success) {
        if (response.data!.length > 1) {
          beats.add(BeatsModal(id: "", name: "All"));
          seleBeat = "Select Beat";
        } else {
          beatsModal = response.data!.first;
          seleBeat = beatsModal!.name;
        }
        beats.addAll(response.data!);
        beatsStreamController.add(seleBeat);
      } else {
        Utility.showToast(response.message);
        seleBeat = response.message;
        beatsStreamController.add(response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
