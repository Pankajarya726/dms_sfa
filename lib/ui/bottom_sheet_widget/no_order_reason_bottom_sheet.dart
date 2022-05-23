import 'dart:async';
import 'dart:ui';

import 'package:dms/main.dart';
import 'package:dms/model/base_response.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
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
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class NoOrderReasonSheet extends StatefulWidget {
  final String retailerId;
  const NoOrderReasonSheet({Key? key, required this.retailerId})
      : super(key: key);

  @override
  _NoOrderReasonSheetState createState() => _NoOrderReasonSheetState();
}

class _NoOrderReasonSheetState extends State<NoOrderReasonSheet> {
  bool issueResolve = false;
  ValueNotifier<bool> checkNotifier = ValueNotifier(false);
  List<ReasonsModal> reasonList = [];
  List<BUModal> buList = [];
  ReasonsModal groupValue = ReasonsModal(id: "", tagName: "", taskType: "");
  StreamController<List<ReasonsModal>> reasonStreamController =
      StreamController();
  StreamController<List<BUModal>> buStreamController = StreamController();

  TextEditingController edtRemark = TextEditingController();

  @override
  void initState() {
    getReason();
    getBu();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
        minHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetHeading("Reason for no order"),
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
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return Column(
                              children: List.generate(
                                reasonList.length,
                                (index) {
                                  return InkWell(
                                    onTap: () {
                                      groupValue = reasonList[index];
                                      reasonStreamController.add(reasonList);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 30,
                                            child: Radio<ReasonsModal>(
                                              value: reasonList[index],
                                              groupValue: groupValue,
                                              activeColor: MColor.colorPrimary,
                                              fillColor:
                                                  MaterialStateProperty.all(
                                                      MColor.colorPrimary),
                                              onChanged: (value) {
                                                groupValue = value!;
                                                reasonStreamController
                                                    .add(reasonList);
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
                                                overflow: TextOverflow.ellipsis,
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
                            //   items: reasonList,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: edtRemark,
                        minLines: 3,
                        maxLines: 5,
                        maxLength: 250,
                        decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter your Reason",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Select BU",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: StreamBuilder<List<BUModal>>(
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

                                  buStreamController.add(buList);
                                },
                                singleItem: false,
                                elevation: 0,
                                activeColor: const Color(0xffFFC9CC),
                                border: Border.all(
                                    color: buList[index].selected
                                        ? MColor.colorPrimary
                                        : const Color(0xffc5c5c5),
                                    width: 1),
                                color: const Color(0xffFAFAFA),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: checkNotifier,
                            builder: (context, bool check, child) {
                              return Checkbox(
                                  value: check,
                                  onChanged: (value) {
                                    issueResolve = value!;
                                    checkNotifier.value = issueResolve;
                                  });
                            }),
                        const Text("Issue Resolve"),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DoneButton(
                  onPressed: () async {
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
                      "remark": edtRemark.text.trim(),
                      "is_resolve": issueResolve ? 1 : 0
                    };

                    noOrderApi(context, input);
                  },
                ),
                DoneButton(
                    title: "Cancel",
                    onPressed: () {
                      Navigator.pop(context, false);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
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

  void getReason() async {
    if (await Network.isConnected()) {
      GetReasonsResponse response = await repository.getReasons();
      reasonList.addAll(response.data);
      reasonStreamController.add(reasonList);
    } else {
      reasonStreamController.addError(StringConst.internetCheck);
    }
  }

  void getBu() async {
    if (await Network.isConnected()) {
      DateTime dateTime =
          await NTP.now().timeout(const Duration(seconds: 5), onTimeout: () {
        return DateTime.now();
      });
      Map<String, dynamic> input = {"day": DateFormat("EEEE").format(dateTime)};
      GetBuResponse response = await repository.getBu();
      if (response.success) {
        buList = response.data!;

        // await Future.forEach(buList, (BUModal bu) {
        //   int i = buList.indexWhere((element) => element.id == bu.id);
        //   if (i != -1) {
        //     buList[i].selected = true;
        //   }
        // });

        buStreamController.add(buList);
      } else {
        buStreamController.addError(response.message);
      }
    } else {
      buStreamController.addError(StringConst.internetCheck);
    }
  }
}
