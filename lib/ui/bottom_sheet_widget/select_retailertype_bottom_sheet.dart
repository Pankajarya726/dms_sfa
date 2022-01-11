import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectRetailerTypeBottomSheet extends StatefulWidget {
  final Function(String selectedRetailerType) onRetailerTypeSelect;
  final String selectedRetailerTypeName;
  const SelectRetailerTypeBottomSheet(
      {Key? key,
      required this.onRetailerTypeSelect,
      required this.selectedRetailerTypeName})
      : super(key: key);

  @override
  _SelectRetailerTypeBottomSheetState createState() =>
      _SelectRetailerTypeBottomSheetState();
}

class _SelectRetailerTypeBottomSheetState
    extends State<SelectRetailerTypeBottomSheet> {
  List<String> names = [
    "Super Market",
    "Grocery Store",
    "Pharmacy / Chemist",
    "Bakery",
    "Dairy",
    "Namkeen / Sweet Shop",
    "Cosmetics",
  ];
  Object selectRetailerTypeRadio = "";
  String selectedRetailerType = "";
  CommonBloc commonBloc = CommonBloc();

  @override
  void initState() {
    super.initState();
    selectRetailerTypeRadio = widget.selectedRetailerTypeName;
    selectedRetailerType = widget.selectedRetailerTypeName;
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
            retailerType,
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
                        if (selectRetailerTypeRadio == names[index]) {
                          commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                              enrollmentRadioTag: index));
                        }
                      }
                      if (state is CommonBlocEnrollRadioTagState) {
                        selectRetailerTypeRadio = state.enrollmentRadioTag;
                      }
                      return radioButtonWidget(
                          selectRetailerTypeRadio, index, names[index]);
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
                widget.onRetailerTypeSelect(selectedRetailerType);
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
        selectedRetailerType = names[value];
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
                selectedRetailerType = names[value].toString();
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
