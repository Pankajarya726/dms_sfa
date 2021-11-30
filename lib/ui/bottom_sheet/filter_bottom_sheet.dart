import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/ui/bottom_sheet/filter_bloc/filter_bloc.dart';
import 'package:sfa/ui/bottom_sheet/filter_bloc/filter_event.dart';
import 'package:sfa/ui/bottom_sheet/filter_bloc/filter_state.dart';
import 'package:sfa/ui/bottom_sheet/filter_model/filter_model.dart';
import 'package:sfa/ui/dialogs/location_dialog.dart';
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
  TextEditingController locationTypeController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();
  TextEditingController filterController = TextEditingController();

  FilterData? selectedLocation;
  List<FilterData> locationList = [];
  List<FilterData> filterList = [];

  List<String> locationTypeList = ["City", "State", "District"];
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
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: nameController,
                          style: const TextStyle(
                              color: colorGrayDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                          autocorrect: true,
                          enableSuggestions: true,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: colorGrayLite,
                            hintText: "Name",
                            prefixText: "   ",
                            contentPadding:
                                const EdgeInsets.fromLTRB(12, 28, 0, 0),
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
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //   child: Container(
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //       color: colorGrayLite,
                    //       borderRadius: BorderRadius.circular(25),
                    //     ),
                    //     child: DropdownSearch<String>(
                    //       mode: Mode.BOTTOM_SHEET,
                    //       maxHeight: 200,
                    //       popupTitle: const Padding(
                    //         padding: EdgeInsets.fromLTRB(14, 24, 14, 14),
                    //         child: Text(
                    //           "Select Location Type",
                    //           style: TextStyle(
                    //               fontSize: 17,
                    //               fontWeight: FontWeight.bold,
                    //               color: colorPrimary),
                    //         ),
                    //       ),
                    //       items: locationTypeList,
                    //       onChanged: (value) {
                    //         locationType = value!;
                    //         getLocation(locationType!);
                    //       },
                    //       popupItemBuilder: (context, data, value) {
                    //         return Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(14),
                    //               child: Text(
                    //                 data,
                    //                 style: const TextStyle(
                    //                     color: colorGrayDark,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 17),
                    //               ),
                    //             ),
                    //             Container(
                    //               height: 0.5,
                    //               color: colorGray,
                    //             )
                    //           ],
                    //         );
                    //       },
                    //       dropdownSearchDecoration: InputDecoration(
                    //         prefixText: "  ",
                    //         contentPadding:
                    //             const EdgeInsets.fromLTRB(12, 12, 0, 0),
                    //         hintText: "Select Location Type",
                    //         hintStyle: const TextStyle(
                    //             fontSize: 17,
                    //             fontWeight: FontWeight.bold,
                    //             color: colorGray),
                    //         enabledBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(25),
                    //           borderSide: const BorderSide(
                    //               color: Colors.transparent, width: 2.0),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //   child: Container(
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         color: colorGrayLite,
                    //         borderRadius: BorderRadius.circular(25),
                    //       ),
                    //       child: StreamBuilder<List<FilterData>>(
                    //         stream: streamController.stream,
                    //         builder: (context, snapShot) {
                    //           return DropdownSearch<FilterData>(
                    //             mode: Mode.BOTTOM_SHEET,
                    //             maxHeight: 400,
                    //             popupTitle: const Padding(
                    //               padding: EdgeInsets.fromLTRB(14, 24, 14, 14),
                    //               child: Text(
                    //                 "Select Location",
                    //                 style: TextStyle(
                    //                     fontSize: 17,
                    //                     fontWeight: FontWeight.bold,
                    //                     color: colorPrimary),
                    //               ),
                    //             ),
                    //             showSearchBox: true,
                    //             searchFieldProps: TextFieldProps(
                    //               padding:
                    //                   const EdgeInsets.fromLTRB(10, 0, 10, 12),
                    //               style: const TextStyle(
                    //                   fontSize: 17,
                    //                   fontWeight: FontWeight.bold,
                    //                   color: colorGrayDark),
                    //               decoration: InputDecoration(
                    //                 border: InputBorder.none,
                    //                 filled: true,
                    //                 fillColor: colorGrayLite,
                    //                 hintText: "Search",
                    //                 prefixIcon: const Icon(
                    //                   Icons.search,
                    //                   color: colorGrayDark,
                    //                 ),
                    //                 contentPadding:
                    //                     const EdgeInsets.fromLTRB(12, 28, 0, 0),
                    //                 hintStyle: const TextStyle(
                    //                     fontSize: 17,
                    //                     fontWeight: FontWeight.bold,
                    //                     color: colorGray),
                    //                 focusedBorder: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(10),
                    //                   borderSide: const BorderSide(
                    //                       color: Colors.transparent,
                    //                       width: 2.0),
                    //                 ),
                    //                 enabledBorder: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(10),
                    //                   borderSide: const BorderSide(
                    //                       color: Colors.transparent,
                    //                       width: 2.0),
                    //                 ),
                    //               ),
                    //             ),
                    //             items: locationList,
                    //             onChanged: (value) {
                    //               selectedLocation = value!;
                    //             },
                    //             dropdownSearchDecoration: InputDecoration(
                    //               prefixText: "   ",
                    //               contentPadding:
                    //                   const EdgeInsets.fromLTRB(12, 12, 0, 0),
                    //               hintText: "Select Location",
                    //               hintStyle: const TextStyle(
                    //                   fontSize: 17,
                    //                   fontWeight: FontWeight.bold,
                    //                   color: colorGray),
                    //               enabledBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(25),
                    //                 borderSide: const BorderSide(
                    //                     color: Colors.transparent, width: 2.0),
                    //               ),
                    //             ),
                    //             popupItemBuilder: (context, data, value) {
                    //               return Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(14),
                    //                     child: Text(
                    //                       data.name,
                    //                       style: const TextStyle(
                    //                           color: colorGrayDark,
                    //                           fontWeight: FontWeight.bold,
                    //                           fontSize: 17),
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     height: 0.5,
                    //                     color: colorGray,
                    //                   )
                    //                 ],
                    //               );
                    //             },
                    //             isFilteredOnline: true,
                    //             onFind: (String? filter) => searchData(filter),
                    //           );
                    //         },
                    //       )),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          readOnly: true,
                          controller: locationTypeController,
                          style: const TextStyle(
                              color: colorGrayDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                          autocorrect: true,
                          enableSuggestions: true,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: colorGrayLite,
                            hintText: "Select Location Type",
                            prefixText: "   ",
                            suffixIcon: InkWell(
                              onTap: () {
                                showLocationType();
                              },
                              child: const Icon(
                                Icons.arrow_drop_down,
                                color: colorGrayDark,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(12, 28, 0, 0),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          readOnly: true,
                          controller: locationNameController,
                          style: const TextStyle(
                              color: colorGrayDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                          autocorrect: true,
                          enableSuggestions: true,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: colorGrayLite,
                            hintText: "Select Location Name",
                            prefixText: "   ",
                            suffixIcon: InkWell(
                              onTap: () {
                                showLocationName();
                              },
                              child: const Icon(
                                Icons.arrow_drop_down,
                                color: colorGrayDark,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(12, 28, 0, 0),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 14),
                      child: InkWell(
                        onTap: () {
                          widget.onSelect(selectedLocation, nameController.text,
                              locationTypeController.text);

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

  getLocation(int locationType) async {
    locationList.clear();
    filterBloc.add(FilterEvent(
        locationType: locationType == 0
            ? "city"
            : locationType == 1
                ? "state"
                : locationType == 2
                    ? "district "
                    : ""));
  }

  Future<List<FilterData>> searchData(String? filter) async {
    filterList = locationList
        .where(
            (value) => value.name.toLowerCase().contains(filter!.toLowerCase()))
        .toList();
    if (filterList.isNotEmpty) {
      return filterList;
    } else {
      return [];
    }
  }

  showLocationType() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            "Select Location Type",
            style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          content: Container(
            height: 200,
            width: 500,
            color: reportBG,
            child: ListView.separated(
              shrinkWrap: false,
              itemCount: 3,
              primary: false,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      locationTypeController.text = locationTypeList[index];
                    });
                    getLocation(index);
                  },
                  contentPadding: const EdgeInsets.all(0),
                  minVerticalPadding: 0,
                  horizontalTitleGap: 0,
                  dense: true,
                  title: Text(
                    locationTypeList[index],
                    style: const TextStyle(
                      color: colorGrayDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, int index) {
                return const Divider(
                  color: colorGray,
                );
              },
            ),
          ),
        );
      },
    );
  }

  showLocationName() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            "Select Location Name",
            style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          content: LocationAlertDialog(
            locationList: locationList,
            onLoctionSelect: (FilterData data) {
              locationNameController.text = data.name;
              selectedLocation = data;
            },
          ),
        );
      },
    );
  }

  searchFilter(String? value) {
    filterList = locationList
        .where((item) => item.name.toLowerCase().contains(value!.toLowerCase()))
        .toList();
    if (filterList.isNotEmpty) {
      return buidlLocationList(filterList);
    } else {
      return const Center(child: Text("Data not found!"));
    }
  }

  buidlLocationList(List<FilterData> listData) {
    return ListView.separated(
      shrinkWrap: false,
      itemCount: listData.length,
      primary: false,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.pop(context);

            setState(() {
              locationNameController.text = listData[index].name;
              selectedLocation = listData[index];
            });
          },
          contentPadding: const EdgeInsets.all(0),
          minVerticalPadding: 0,
          horizontalTitleGap: 0,
          dense: true,
          title: Text(
            listData[index].name,
            style: const TextStyle(
              color: colorGrayDark,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        );
      },
      separatorBuilder: (context, int index) {
        return const Divider(
          color: colorGray,
        );
      },
    );
  }
}
