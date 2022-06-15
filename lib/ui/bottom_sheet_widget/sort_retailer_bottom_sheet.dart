import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortingRetailersBottomSheet extends StatefulWidget {
  final Function(String sortSelect) onSelect;
  final String selectedType;
  const SortingRetailersBottomSheet(
      {Key? key, required this.onSelect, required this.selectedType})
      : super(key: key);

  @override
  _SortingRetailersBottomSheetState createState() =>
      _SortingRetailersBottomSheetState();
}

class _SortingRetailersBottomSheetState
    extends State<SortingRetailersBottomSheet> {
  List<String> sortingList = [
    StringConst.retailer,
    StringConst.teleRetailer,
    StringConst.nearby,
  ];
  Object sortRetailersRadio = "";
  String selectedType = "";
  CommonBloc commonBloc = CommonBloc();

  @override
  void initState() {
    super.initState();
    sortRetailersRadio = widget.selectedType;
    selectedType = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
        minHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringConst.sorting,
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
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    sortingList.length,
                    (index) {
                      return BlocProvider(
                        create: (context) => commonBloc,
                        child: BlocBuilder<CommonBloc, CommonBlocStates>(
                          builder: (context, state) {
                            if (state is CommonBlocInitialState) {
                              if (sortRetailersRadio == sortingList[index]) {
                                commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                                    enrollmentRadioTag: index));
                              }
                            }
                            if (state is CommonBlocEnrollRadioTagState) {
                              sortRetailersRadio = state.enrollmentRadioTag;
                            }
                            return radioButtonWidget(
                                sortRetailersRadio, index, sortingList[index]);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       widget.onSelect(selectedType);
            //       Navigator.pop(context);
            //     },
            //     style: ButtonStyle(
            //       fixedSize: MaterialStateProperty.all(const Size(170, 50)),
            //       backgroundColor:
            //           MaterialStateProperty.all(MColor.colorPrimary),
            //       elevation: MaterialStateProperty.all(0),
            //       shape: MaterialStateProperty.all(
            //         RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(30),
            //         ),
            //       ),
            //     ),
            //     child: const Text(
            //       StringConst.done,
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 24,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget radioButtonWidget(groupValue, value, label) {
    return InkWell(
      onTap: () {
        commonBloc
            .add(CommonBlocEnrollTypeRadioEvent(enrollmentRadioTag: value));
        selectedType = sortingList[value];
        widget.onSelect(selectedType);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Radio<dynamic>(
                value: value,
                groupValue: groupValue,
                activeColor: MColor.colorPrimary,
                fillColor: MaterialStateProperty.all(MColor.colorPrimary),
                onChanged: (value) {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                      enrollmentRadioTag: value!));
                  selectedType = sortingList[value].toString();
                  widget.onSelect(selectedType);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                label,
                maxLines: 5,
                style: const TextStyle(
                  fontSize: 17.0,
                  color: MColor.backButton,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
    );
    // return GestureDetector(
    //   onTap: () {
    //     commonBloc
    //         .add(CommonBlocEnrollTypeRadioEvent(enrollmentRadioTag: value));
    //     selectedType = sortingList[value];
    //   },
    //   child: RadioListTile<dynamic>(
    //     contentPadding: const EdgeInsets.all(0),
    //     value: value,
    //     groupValue: groupValue,
    //     title: Text(
    //       label,
    //       style: const TextStyle(
    //         fontSize: 17.0,
    //         color: MColor.backButton,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     onChanged: (value) {
    //       commonBloc
    //           .add(CommonBlocEnrollTypeRadioEvent(enrollmentRadioTag: value!));
    //       selectedType = sortingList[value].toString();
    //     },
    //   ),
    // );
  }
}
