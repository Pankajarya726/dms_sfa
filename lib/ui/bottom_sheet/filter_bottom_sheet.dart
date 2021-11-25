import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/ui/bottom_sheet/filter_bloc/filter_bloc.dart';
import 'package:sfa/ui/bottom_sheet/filter_bloc/filter_event.dart';
import 'package:sfa/ui/bottom_sheet/filter_bloc/filter_state.dart';
import 'package:sfa/ui/bottom_sheet/filter_model/filter_model.dart';
import 'package:sfa/utility/colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(FilterData? location, String? name, String? locationType)
      onSelect;
  const FilterBottomSheet({Key? key, required this.onSelect}) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  FilterBloc filterBloc = FilterBloc();
  TextEditingController nameController = TextEditingController();
  String? locationType;
  FilterData? selectedLocation;
  List<FilterData> locationList = [];
  StreamController<List<FilterData>> streamController = StreamController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FilterBloc>(
      create: (context) => filterBloc,
      child: BlocListener<FilterBloc, FilterState>(
        listener: (context, state) {
          if (state is FilterSuccessState) {
            locationList = state.response.data!;
            streamController.add(locationList);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: reportBG,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Filter",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: colorGrayDark,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                      child: TextFormField(
                        controller: nameController,
                        style: const TextStyle(
                            color: colorGrayDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                        autocorrect: true,
                        enableSuggestions: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: colorGrayLite,
                          hintText: "Name",
                          prefixText: "   ",
                          hintStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: colorGray),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorGrayLite,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButtonFormField(
                          dropdownColor: reportBG,
                          hint: const Text(
                            "Select Location Type",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: colorGray),
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Colors.transparent, width: 2.0),
                            ),
                          ),
                          items: <String>['city', 'state', 'district']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    color: colorGrayDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              value = value;
                              locationType = value.toString();
                              getLocation(locationType!);
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Container(
                          decoration: BoxDecoration(
                            color: colorGrayLite,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: StreamBuilder<List<FilterData>>(
                            stream: streamController.stream,
                            builder: (context, snapShot) {
                              // return DropdownButtonFormField<FilterData>(
                              //   dropdownColor: reportBG,
                              //   hint: const Text(
                              //     "Select Location",
                              //     style: TextStyle(
                              //         fontSize: 17,
                              //         fontWeight: FontWeight.bold,
                              //         color: colorGray),
                              //   ),
                              //   decoration: InputDecoration(
                              //     enabledBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(25),
                              //       borderSide: const BorderSide(
                              //           color: Colors.transparent, width: 2.0),
                              //     ),
                              //   ),
                              //   items: locationList.map((FilterData value) {
                              //     return DropdownMenuItem<FilterData>(
                              //       value: value,
                              //       child: Text(
                              //         value.name,
                              //         style: const TextStyle(
                              //             color: colorGrayDark,
                              //             fontWeight: FontWeight.bold,
                              //             fontSize: 17),
                              //       ),
                              //     );
                              //   }).toList(),
                              //   onChanged: (value) {
                              //     selectedLocation = value;
                              //   },
                              // );
                              return DropdownSearch<FilterData>(
                                mode: Mode.DIALOG,
                                showSearchBox: true,
                              );
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 14),
                      child: InkWell(
                        onTap: () {
                          widget.onSelect(selectedLocation, nameController.text,
                              locationType);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 180,
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getLocation(String locationType) async {
    locationList.clear();
    filterBloc.add(FilterEvent(locationType: locationType));
  }
}
