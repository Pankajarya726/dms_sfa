import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectLangSecondBottomSheet extends StatefulWidget {
  final Function(String selectedLangSecond) onLangSecondSelect;
  final String selectedLangSecondName;
  const SelectLangSecondBottomSheet(
      {Key? key,
      required this.onLangSecondSelect,
      required this.selectedLangSecondName})
      : super(key: key);

  @override
  _SelectLangSecondBottomSheetState createState() =>
      _SelectLangSecondBottomSheetState();
}

class _SelectLangSecondBottomSheetState
    extends State<SelectLangSecondBottomSheet> {
  List<String> names = [
    "English",
    "Hindi",
    "Tamil",
    "Urdu",
    "Telgu",
    "Marathi",
  ];
  Object selectLangSecondRadio = "";
  String selectedLangSecond = "";
  CommonBloc commonBloc = CommonBloc();

  @override
  void initState() {
    super.initState();
    selectLangSecondRadio = widget.selectedLangSecondName;
    selectedLangSecond = widget.selectedLangSecondName;
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
            selectLangSecond,
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
                        if (selectLangSecondRadio == names[index]) {
                          commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                              enrollmentRadioTag: index));
                        }
                      }
                      if (state is CommonBlocEnrollRadioTagState) {
                        selectLangSecondRadio = state.enrollmentRadioTag;
                      }
                      return radioButtonWidget(
                          selectLangSecondRadio, index, names[index]);
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
                widget.onLangSecondSelect(selectedLangSecond);
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
        selectedLangSecond = names[value];
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
                selectedLangSecond = names[value].toString();
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
