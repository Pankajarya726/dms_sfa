import 'dart:async';
import 'dart:collection';
import 'package:dms/main.dart';
import 'package:dms/ui/add_store/model/select_distributor_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class SelectDistributorBottomSheet extends StatefulWidget {
  final Function(DistributorModel? distributorModel) onDistributorSelect;
  final DistributorModel? distributorModel;
  final String? districtId;
  const SelectDistributorBottomSheet(
      {Key? key,
      required this.onDistributorSelect,
      required this.distributorModel,
      required this.districtId})
      : super(key: key);

  @override
  _SelectDistributorBottomSheetState createState() =>
      _SelectDistributorBottomSheetState();
}

class _SelectDistributorBottomSheetState
    extends State<SelectDistributorBottomSheet> {
  int groupValue = -1;
  List<DistributorModel> distributorList = [];
  DistributorModel? selectedDistributor;
  StreamController<List<DistributorModel>> distributorStream =
      StreamController();
  StreamController<List<DistributorModel>> searchStream = StreamController();
  TextEditingController txtSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.distributorModel != null) {
      debugPrint(
          "widget.selectedDistrict!.id---->${widget.distributorModel!.id}");
      groupValue = widget.distributorModel!.id;
      selectedDistributor = widget.distributorModel;
    }
    getDistributors();
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
        child: StreamBuilder<List<DistributorModel>>(
            stream: distributorStream.stream,
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
                return StreamBuilder<List<DistributorModel>>(
                    stream: searchStream.stream,
                    initialData: distributorList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    StringConst.selectDistributor,
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: MColor.colorPrimary,
                                      letterSpacing: 0.67,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      groupValue = -1;
                                      distributorStream.add([]);
                                      selectedDistributor = null;
                                      widget.onDistributorSelect(
                                          DistributorModel(
                                              id: -1,
                                              userId: 0,
                                              name: "",
                                              customerCodes: ""));
                                    },
                                    child: const Text(
                                      StringConst.reset,
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: MColor.colorPrimary,
                                        letterSpacing: 0.67,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                style: const TextStyle(fontSize: 16),
                                onChanged: (text) {
                                  if (text.isNotEmpty) {
                                    List<DistributorModel> searchList = [];
                                    for (var element in distributorList) {
                                      if (element.name.toLowerCase().contains(
                                          text.trim().toLowerCase())) {
                                        searchList.add(element);
                                      }
                                    }
                                    searchStream.add(searchList);
                                  } else {
                                    searchStream.add(distributorList);
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
                                                distributorStream
                                                    .add(snapshot.data!);
                                                if (groupValue != -1) {
                                                  selectedDistributor =
                                                      distributorList
                                                          .singleWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  groupValue);
                                                  widget.onDistributorSelect(
                                                      selectedDistributor!);
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
                                                          distributorStream.add(
                                                              snapshot.data!);
                                                          if (groupValue !=
                                                              -1) {
                                                            selectedDistributor =
                                                                distributorList.singleWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        groupValue);
                                                            widget.onDistributorSelect(
                                                                selectedDistributor!);
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
                                            //   contentPadding:
                                            //       const EdgeInsets.all(0),
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
                                            //     distributorStream
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
                              //         selectedDistributor = distributorList
                              //             .singleWhere((element) =>
                              //                 element.id == groupValue);
                              //         widget.onDistributorSelect(
                              //             selectedDistributor!);
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

  getDistributors() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["districts_id"] = widget.districtId;
    SelectDistributorResponse response =
        await repository.selectDistributor(input);
    if (await Network.isConnected()) {
      if (response.success) {
        distributorList = response.data!;
        debugPrint("groupValue--->$groupValue");
        distributorStream.add(distributorList);
      } else {
        distributorStream.addError(response.message);
      }
    } else {
      distributorStream.addError(StringConst.internetCheck);
    }
  }
}
