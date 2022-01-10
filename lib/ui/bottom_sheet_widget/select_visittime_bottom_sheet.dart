import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCallTimeSlotBottomSheet extends StatefulWidget {
  final Function(String selectedCallTimeSlot) onCallTimeSlotSelect;
  final String selectedCallTimeSlotName;
  const SelectCallTimeSlotBottomSheet(
      {Key? key,
      required this.onCallTimeSlotSelect,
      required this.selectedCallTimeSlotName})
      : super(key: key);

  @override
  _SelectCallTimeSlotBottomSheetState createState() =>
      _SelectCallTimeSlotBottomSheetState();
}

class _SelectCallTimeSlotBottomSheetState
    extends State<SelectCallTimeSlotBottomSheet> {
  List<String> names = [
    "9 AM to 6 PM",
    "1 PM to 3 PM",
    "11 AM to 1 PM",
    "4 PM to 6 PM",
  ];
  Object selectCallTimeSlotRadio = "";
  String selectedCallTimeSlot = "";
  CommonBloc commonBloc = CommonBloc();

  @override
  void initState() {
    super.initState();
    selectCallTimeSlotRadio = widget.selectedCallTimeSlotName;
    selectedCallTimeSlot = widget.selectedCallTimeSlotName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            callTimeSlot,
            style: TextStyle(
              fontSize: 19,
              color: MColor.colorPrimary,
              letterSpacing: 0.67,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: ListView.builder(
              controller: ScrollController(keepScrollOffset: false),
              itemCount: names.length,
              itemBuilder: (context, index) {
                return BlocProvider(
                  create: (context) => commonBloc,
                  child: BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocInitialState) {
                        if (selectCallTimeSlotRadio == names[index]) {
                          commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                              enrollmentRadioTag: index));
                        }
                      }
                      if (state is CommonBlocEnrollRadioTagState) {
                        selectCallTimeSlotRadio = state.enrollmentRadioTag;
                      }
                      return radioButtonWidget(
                          selectCallTimeSlotRadio, index, names[index]);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                widget.onCallTimeSlotSelect(selectedCallTimeSlot);
                Navigator.pop(context);
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(220, 60)),
                backgroundColor: MaterialStateProperty.all(MColor.colorPrimary),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              child: const Text(
                done,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget radioButtonWidget(groupValue, value, label) {
    return GestureDetector(
      onTap: () {
        commonBloc
            .add(CommonBlocEnrollTypeRadioEvent(enrollmentRadioTag: value));
        selectedCallTimeSlot = names[value];
      },
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Radio<dynamic>(
              value: value,
              groupValue: groupValue,
              activeColor: MColor.colorPrimary,
              fillColor: MaterialStateProperty.all(MColor.colorPrimary),
              onChanged: (value) {
                commonBloc.add(
                    CommonBlocEnrollTypeRadioEvent(enrollmentRadioTag: value));
                selectedCallTimeSlot = names[value].toString();
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 17.0,
              color: MColor.backButton,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
