import 'dart:async';
import 'package:dms/main.dart';
import 'package:dms/ui/add_store/model/select_retailer_type_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class SelectRetailerTypeBottomSheet extends StatefulWidget {
  final Function(RetailerTypeModel? retailerTypeModel) onRetailerTypeSelect;
  final RetailerTypeModel? retailerTypeModel;
  const SelectRetailerTypeBottomSheet(
      {Key? key,
      required this.onRetailerTypeSelect,
      required this.retailerTypeModel})
      : super(key: key);

  @override
  _SelectRetailerTypeBottomSheetState createState() =>
      _SelectRetailerTypeBottomSheetState();
}

class _SelectRetailerTypeBottomSheetState
    extends State<SelectRetailerTypeBottomSheet> {
  int groupValue = -1;
  RetailerTypeModel? retailerTypeModel;
  List<RetailerTypeModel> retailerTypeList = [];
  StreamController<List<RetailerTypeModel>> retailerTypeStream =
      StreamController();
  StreamController<List<RetailerTypeModel>> searchStream = StreamController();
  TextEditingController txtSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.retailerTypeModel != null) {
      debugPrint(
          "widget.selectedDistrict!.id---->${widget.retailerTypeModel!.id}");
      groupValue = widget.retailerTypeModel!.id;
      retailerTypeModel = widget.retailerTypeModel;
    }
    getRetailerType();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
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
        child: StreamBuilder<List<RetailerTypeModel>>(
            stream: retailerTypeStream.stream,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const IntrinsicHeight(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snap.hasError) {
                return IntrinsicHeight(
                  child: Center(
                    child: Text(snap.error.toString()),
                  ),
                );
              }

              if (snap.hasData) {
                return StreamBuilder<List<RetailerTypeModel>>(
                    stream: searchStream.stream,
                    initialData: retailerTypeList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                StringConst.retailerType,
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
                              TextFormField(
                                style: const TextStyle(fontSize: 16),
                                onChanged: (text) {
                                  if (text.isNotEmpty) {
                                    List<RetailerTypeModel> searchList = [];
                                    for (var element in retailerTypeList) {
                                      if (element.name.toLowerCase().contains(
                                          text.trim().toLowerCase())) {
                                        searchList.add(element);
                                      }
                                    }
                                    searchStream.add(searchList);
                                  } else {
                                    searchStream.add(retailerTypeList);
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: StringConst.search,
                                  hintStyle: const TextStyle(fontSize: 16),
                                  contentPadding: const EdgeInsets.all(10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    gapPadding: 2,
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Color(0xFF6E6E6E),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    gapPadding: 2,
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Color(0xFF6E6E6E),
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Color(0xff555555),
                                  ),
                                ),
                              ),
                              snapshot.data!.isEmpty
                                  ? const SizedBox(
                                      height: 20,
                                    )
                                  : const SizedBox(
                                      height: 5,
                                    ),
                              snapshot.data!.isNotEmpty
                                  ? Flexible(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: List.generate(
                                              snapshot.data!.length, (index) {
                                            return InkWell(
                                              onTap: () {
                                                groupValue =
                                                    snapshot.data![index].id;
                                                retailerTypeStream
                                                    .add(snapshot.data!);
                                                if (groupValue != -1) {
                                                  retailerTypeModel =
                                                      retailerTypeList
                                                          .singleWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  groupValue);
                                                  widget.onRetailerTypeSelect(
                                                      retailerTypeModel);
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Radio<int>(
                                                        value: snapshot
                                                            .data![index].id,
                                                        groupValue: groupValue,
                                                        activeColor:
                                                            MColor.colorPrimary,
                                                        fillColor:
                                                            MaterialStateProperty
                                                                .all(MColor
                                                                    .colorPrimary),
                                                        onChanged: (value) {
                                                          groupValue = value!;
                                                          retailerTypeStream
                                                              .add(snapshot
                                                                  .data!);
                                                          if (groupValue !=
                                                              -1) {
                                                            retailerTypeModel =
                                                                retailerTypeList.singleWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        groupValue);
                                                            widget.onRetailerTypeSelect(
                                                                retailerTypeModel);
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        snapshot
                                                            .data![index].name,
                                                        maxLines: 5,
                                                        style: const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 17.0,
                                                          color:
                                                              MColor.backButton,
                                                          fontWeight:
                                                              FontWeight.bold,
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

                                            // return RadioListTile<int>(
                                            //   contentPadding: EdgeInsets.zero,
                                            //   value: snapshot.data![index].id,
                                            //   groupValue: groupValue,
                                            //   title: Text(
                                            //     snapshot.data![index].name,
                                            //     style: const TextStyle(
                                            //       fontSize: 17.0,
                                            //       color: MColor.backButton,
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            //   onChanged: (value) {
                                            //     groupValue = value!;
                                            //     retailerTypeStream
                                            //         .add(snapshot.data!);
                                            //   },
                                            // );
                                          }),
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: Text("Data not found"),
                                    ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              // Center(
                              //   child: ElevatedButton(
                              //     onPressed: () {
                              //       if (groupValue != -1) {
                              //         retailerTypeModel = retailerTypeList
                              //             .singleWhere((element) =>
                              //                 element.id == groupValue);
                              //         widget.onRetailerTypeSelect(
                              //             retailerTypeModel);
                              //       }
                              //       Navigator.pop(context);
                              //     },
                              //     style: ButtonStyle(
                              //       fixedSize: MaterialStateProperty.all(
                              //           const Size(180, 55)),
                              //       backgroundColor: MaterialStateProperty.all(
                              //           MColor.colorPrimary),
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
                        );
                      }
                      return Container();
                    });
              }
              return Container();
            }),
      ),
    );
  }

  getRetailerType() async {
    SelectRetailerTypeResponse response = await repository.selectRetailerType();
    if (await Network.isConnected()) {
      if (response.success) {
        retailerTypeList = response.data!;
        retailerTypeStream.add(retailerTypeList);
      } else {
        retailerTypeStream.addError(response.message);
      }
    } else {
      retailerTypeStream.addError(StringConst.internetCheck);
    }
  }

  // List<Widget> radioButtonWidget() {
  //   List<Widget> widgets = [];
  //   for (RetailerTypeModel retailerType in retailerTypeModel!) {
  //     widgets.add(
  //       BlocProvider(
  //         create: (context) => commonBloc,
  //         child: BlocBuilder<CommonBloc, CommonBlocStates>(
  //           builder: (context, state) {
  //             if (state is CommonBlocInitialState) {
  //               if (groupValue == retailerType.name) {
  //                 commonBloc.add(CommonBlocEnrollTypeRadioEvent(
  //                     enrollmentRadioTag: retailerType.id));
  //               }
  //             }

  //             if (state is CommonBlocEnrollRadioTagState) {
  //               groupValue = state.enrollmentRadioTag;
  //             }
  //             return GestureDetector(
  //               onTap: () {
  //                 commonBloc.add(CommonBlocEnrollTypeRadioEvent(
  //                     enrollmentRadioTag: retailerType.id));
  //                 selectedRetailerType = retailerType.name;
  //                 selectedRetailerTypeId = retailerType.id.toString();
  //               },
  //               child: Row(
  //                 children: [
  //                   SizedBox(
  //                     width: 18,
  //                     child: Radio<dynamic>(
  //                       value: retailerType.id,
  //                       groupValue: groupValue,
  //                       activeColor: MColor.colorPrimary,
  //                       fillColor:
  //                           MaterialStateProperty.all(MColor.colorPrimary),
  //                       onChanged: (value) {
  //                         commonBloc.add(CommonBlocEnrollTypeRadioEvent(
  //                             enrollmentRadioTag: value));
  //                         selectedRetailerType = retailerType.name;
  //                         selectedRetailerTypeId = retailerType.id.toString();
  //                       },
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     width: 10,
  //                   ),
  //                   Text(
  //                     retailerType.name,
  //                     style: const TextStyle(
  //                       fontSize: 17.0,
  //                       color: MColor.backButton,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     width: 15,
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     );
  //   }
  //   return widgets;
  // }

}
