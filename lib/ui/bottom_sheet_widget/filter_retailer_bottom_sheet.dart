import 'package:dms/ui/custom_widget/drop_down_field.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailer_bloc.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterRetailerBottomSheet extends StatefulWidget {
  final String day;
  final String type;
  final String beat;
  final List<BeatsModal> beatList;
  final Function(String day, String type, String selectedBeat) onFilter;
  final Function(BeatsModal? beatsModal) onBeatSelected;
  const FilterRetailerBottomSheet({
    Key? key,
    required this.onFilter,
    required this.day,
    required this.type,
    required this.beat,
    required this.beatList,
    required this.onBeatSelected,
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
  String selectedPrioType = "";
  String selectedBeat = "";
  List<BeatsModal> beats = [];
  BeatsModal? beatsModal;

  @override
  void initState() {
    selectedDay = widget.day;
    selectedPrioType = widget.type;
    selectedBeat = widget.beat;
    debugPrint("FilterRetailerBottomSheet");
    beats = widget.beatList;
    super.initState();
  }

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
                prevSelected: selectedDay,
                onSelect: (value) {
                  debugPrint("select-->$value");
                  selectedDay = value;
                },
                hint: "Select Order Booking Day",
                menuList: days,
              ),
              const SizedBox(
                height: 20,
              ),
              DropDownField(
                prevSelected: selectedBeat,
                onSelect: (value) {
                  debugPrint("select-->$value");
                  selectedBeat = value;
                },
                hint: "Select Beat",
                menuList: days,
                beats: beats,
                onBeatSelected: (beatsM) {
                  if (beatsM != null) {
                    beatsModal = beatsM;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              DropDownField(
                prevSelected: selectedPrioType,
                onSelect: (value) {
                  debugPrint("select-->");
                  selectedPrioType = value;
                },
                hint: "Select Priority Type",
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
                            selectedDay, selectedPrioType, selectedBeat);
                        if (beatsModal != null) {
                          widget.onBeatSelected(beatsModal!);
                        }
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
    );
  }
}
