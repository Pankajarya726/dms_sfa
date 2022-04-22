import 'dart:collection';
import 'package:dms/listeners/drop_down_field_listener.dart';
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

class FilterTaskBottomSheet extends StatefulWidget {
  final String day;
  final BeatsModal beat;
  final List<BeatsModal> beatList;
  final Function(
    String day,
    BeatsModal beatsModal,
    List<BeatsModal> beats,
  ) onFilter;

  const FilterTaskBottomSheet({
    Key? key,
    required this.onFilter,
    required this.day,
    required this.beat,
    required this.beatList,
  }) : super(key: key);

  @override
  _FilterTaskBottomSheetState createState() => _FilterTaskBottomSheetState();
}

class _FilterTaskBottomSheetState extends State<FilterTaskBottomSheet> {
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

  String selectedDay = "";
  String selectedBeat = "";
  List<BeatsModal> beatsList = [];
  BeatsModal beatsModal = BeatsModal(id: "", name: "All");
  DropDownFieldListener? dropDownFieldListener;
  PopUpMenuListener? popUpMenuListener;

  @override
  void initState() {
    selectedDay = widget.day;
    selectedBeat = widget.beat.name;
    debugPrint("FilterTaskBottomSheet");
    beatsList = widget.beatList;
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
                    beatsList.clear();
                    if (popUpMenuListener != null) {
                      selectedBeat = "Select Beat";
                      popUpMenuListener!.onMenuItemSelect(selectedBeat);
                    }
                    getBeats();
                  },
                  hint: "Select Order Booking Day",
                  menuList: days,
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownField(
                  onMenuItemSelected: (listener) {
                    popUpMenuListener = listener;
                  },
                  prevSelected: selectedBeat,
                  onSelect: (value) {
                    debugPrint("select-->$value");
                    selectedBeat = value;
                  },
                  hint: "Select Beat",
                  menuList: days,
                  beats: beatsList,
                  onBeatSelected: (beatsM) {
                    if (beatsM != null) {
                      beatsModal = beatsM;
                    }
                  },
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
                          widget.onFilter(selectedDay, beatsModal, beatsList);
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
      Map<String, dynamic> input = HashMap<String, dynamic>();
      input["day"] = selectedDay;
      GetAllBeatsResponse response =
          await repository.getBeatByOrderBookingDay(input);
      if (response.success) {
        beatsList.add(BeatsModal(id: "", name: "All"));
        beatsList.addAll(response.data!);
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
