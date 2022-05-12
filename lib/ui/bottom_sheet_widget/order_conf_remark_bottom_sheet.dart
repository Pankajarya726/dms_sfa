import 'dart:async';

import 'package:dms/main.dart';
import 'package:dms/model/base_response.dart';
import 'package:dms/ui/order_booking/order_confirmation/model/get_bu_response.dart';
import 'package:dms/ui/order_booking/order_confirmation/model/get_reason_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:group_radio_button/group_radio_button.dart';

class OrderConfRemarkBottomSheet extends StatefulWidget {
  final ReasonsModal? reason;
  final String remark;
  final List<BUModal> buList;
  final bool issueResolve;
  final String retailerId;
  final Function(ReasonsModal reason, String remark, List<BUModal> buList,
      bool issueResolve) onReasonSelected;

  const OrderConfRemarkBottomSheet({
    Key? key,
    required this.onReasonSelected,
    this.reason,
    required this.remark,
    required this.buList,
    required this.issueResolve,
    required this.retailerId,
  }) : super(key: key);

  @override
  _OrderConfRemarkBottomSheetState createState() =>
      _OrderConfRemarkBottomSheetState();
}

class _OrderConfRemarkBottomSheetState
    extends State<OrderConfRemarkBottomSheet> {
  List<ReasonsModal> reasons = [];
  List<BUModal> buList = [];
  ReasonsModal groupValue = ReasonsModal(taskType: "", id: "", tagName: "");
  bool issueResolve = false;
  StreamController<List<ReasonsModal>> reasonStreamController =
      StreamController();
  StreamController<List<BUModal>> buStreamController = StreamController();
  StreamController<bool> issueStreamController = StreamController();
  TextEditingController txtRemarkController = TextEditingController();
  List<BUModal> selectedBUList = [];

  @override
  void initState() {
    if (widget.reason != null) {
      groupValue = widget.reason!;
    }
    txtRemarkController.text = widget.remark;
    issueResolve = widget.issueResolve;
    selectedBUList = widget.buList;
    getReasons();
    getBu();
    super.initState();
  }

  logoutDialog(context) {}

  @override
  void dispose() {
    reasonStreamController.close();
    buStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
        minHeight: MediaQuery.of(context).size.height * 0.40,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                StringConst.reason,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<List<ReasonsModal>>(
                          stream: reasonStreamController.stream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }

                            if (snapshot.hasData) {
                              return Column(
                                children: List.generate(
                                  reasons.length,
                                  (index) {
                                    return InkWell(
                                      onTap: () {
                                        groupValue = reasons[index];
                                        reasonStreamController.add(reasons);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
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
                                              child: Radio<ReasonsModal>(
                                                value: reasons[index],
                                                groupValue: groupValue,
                                                activeColor:
                                                    MColor.colorPrimary,
                                                fillColor:
                                                    MaterialStateProperty.all(
                                                        MColor.colorPrimary),
                                                onChanged: (value) {
                                                  groupValue = value!;
                                                  reasonStreamController
                                                      .add(reasons);
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Text(
                                                snapshot.data![index].tagName,
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
                                  },
                                ),
                              );

                              // return RadioGroup<ReasonsModal>.builder(
                              //   groupValue: groupValue,
                              //   onChanged: (value) => setState(() {
                              //     groupValue = value!;
                              //   }),
                              //   items: snapshot.data!,
                              //   itemBuilder: (item) => RadioButtonBuilder(
                              //     item.tagName,
                              //   ),
                              // );
                            }
                            return Container();
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        minLines: 3,
                        maxLines: 5,
                        controller: txtRemarkController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Enter your reason",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Select Bu",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<List<BUModal>>(
                        stream: buStreamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }

                          if (buList.isEmpty) {
                            return Container();
                          }

                          if (snapshot.hasData) {
                            buList = snapshot.data!;
                          }

                          return Tags(
                            itemCount: buList.length,
                            runSpacing: 8,
                            spacing: 10,
                            alignment: WrapAlignment.start,
                            itemBuilder: (index) {
                              return ItemTags(
                                index: index,
                                customData: buList[index],
                                title: buList[index].businessUnit,
                                textColor: MColor.textColor,
                                active: buList[index].selected,
                                textActiveColor: MColor.activeTextColor,
                                pressEnabled: true,
                                onPressed: (item) {
                                  buList[index].selected =
                                      !buList[index].selected;

                                  selectedBUList = buList
                                      .where((element) => element.selected)
                                      .toList();

                                  buStreamController.add(buList);
                                },
                                singleItem: false,
                                elevation: 0,
                                activeColor: const Color(0xffFFC9CC),
                                border: Border.all(
                                    color: buList[index].selected
                                        ? MColor.colorPrimary
                                        : const Color(0xffC5C5C5),
                                    width: 1),
                                color: const Color(0xffFAFAFA),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<bool>(
                          stream: issueStreamController.stream,
                          initialData: false,
                          builder: (context, snapshot) {
                            return InkWell(
                              onTap: () {
                                issueResolve = !issueResolve;
                                issueStreamController.add(issueResolve);
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    child: Checkbox(
                                      fillColor: MaterialStateProperty.all(
                                          MColor.colorPrimary),
                                      value: issueResolve,
                                      onChanged: (value) {
                                        issueResolve = value!;
                                        issueStreamController.add(issueResolve);
                                      },
                                      splashRadius: 0,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Issue Resolve"),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onReasonSelected(groupValue,
                        txtRemarkController.text, selectedBUList, issueResolve);

                    List<BUModal> bus =
                        buList.where((element) => element.selected).toList();

                    String selectedBu = "";

                    for (int i = 0; i < bus.length; i++) {
                      if (i == bus.length - 1) {
                        selectedBu += bus[i].id;
                      } else {
                        selectedBu += bus[i].id + ",";
                      }
                    }

                    Map<String, dynamic> input = {
                      "retailer_id": widget.retailerId,
                      "bu": selectedBu,
                      "reason": groupValue.tagName,
                      "task_type": groupValue.taskType,
                      "remark": txtRemarkController.text.trim(),
                      "is_resolve": issueResolve ? 1 : 0
                    };

                    noOrderApi(context, input);
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(160, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(MColor.colorPrimary),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: const Text(
                    StringConst.done,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getReasons() async {
    if (await Network.isConnected()) {
      GetReasonsResponse response = await repository.getReasons();
      if (response.success) {
        reasons = response.data;
        reasonStreamController.add(reasons);
      } else {
        reasonStreamController.addError(response.message);
      }
    } else {
      reasonStreamController.addError(StringConst.internetCheck);
    }
  }

  void getBu() async {
    if (await Network.isConnected()) {
      GetBuResponse response = await repository.getBu();
      if (response.success) {
        buList = response.data!;

        await Future.forEach(widget.buList, (BUModal bu) {
          int i = buList.indexWhere((element) => element.id == bu.id);
          if (i != -1) {
            buList[i].selected = true;
          }
        });

        buStreamController.add(buList);
      } else {
        buStreamController.addError(response.message);
      }
    } else {
      buStreamController.addError(StringConst.internetCheck);
    }
  }

  void noOrderApi(BuildContext context, Map<String, dynamic> input) async {
    if (await Network.isConnected()) {
      EasyLoading.show(status: "Loading...");
      BaseResponse response = await repository.saveNoOrder(input);
      EasyLoading.dismiss();
      if (response.success) {
        Utility.showToast(response.message);
        Navigator.pop(context, true);
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
