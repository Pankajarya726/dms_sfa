import 'dart:async';

import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/order_confirmation/model/get_bu_response.dart';
import 'package:dms/ui/order_booking/order_confirmation/model/get_reason_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class OrderConfRemarkBottomSheet extends StatefulWidget {
  final String reason;
  final String remark;
  final List<BUModal> buList;
  final bool issueResolve;
  final Function(String reason, String remark, List<BUModal> buList, bool issueResolve) onReasonSelected;

  const OrderConfRemarkBottomSheet({
    Key? key,
    required this.onReasonSelected,
    required this.reason,
    required this.remark,
    required this.buList,
    required this.issueResolve,
  }) : super(key: key);

  @override
  _OrderConfRemarkBottomSheetState createState() => _OrderConfRemarkBottomSheetState();
}

class _OrderConfRemarkBottomSheetState extends State<OrderConfRemarkBottomSheet> {
  List<ReasonsModal> reasons = [];
  List<BUModal> buList = [];
  int groupValue = -1;
  bool issueResolve = false;
  StreamController<List<ReasonsModal>> reasonStreamController = StreamController();
  StreamController<List<BUModal>> buStreamController = StreamController();
  StreamController<bool> issueStreamController = StreamController();
  TextEditingController txtRemarkController = TextEditingController();
  List<BUModal> selectedBUList = [];

  @override
  void initState() {
    if (widget.reason.isNotEmpty) {
      groupValue = int.parse(widget.reason);
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
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Column(
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
                StreamBuilder<List<ReasonsModal>>(
                    stream: reasonStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                              return RadioListTile<int>(
                                contentPadding: const EdgeInsets.all(0),
                                value: int.parse(snapshot.data![index].id),
                                groupValue: groupValue,
                                title: Text(
                                  snapshot.data![index].tagName,
                                  style: const TextStyle(
                                    fontSize: 17.0,
                                    color: MColor.backButton,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onChanged: (value) {
                                  groupValue = value!;
                                  reasonStreamController.add(snapshot.data!);
                                },
                              );
                            },
                          ),
                        );
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter your remark",
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                            buList[index].selected = !buList[index].selected;

                            selectedBUList = buList.where((element) => element.selected).toList();

                            buStreamController.add(buList);
                          },
                          singleItem: false,
                          elevation: 0,
                          activeColor: const Color(0xffFFC9CC),
                          border: Border.all(color: buList[index].selected ? MColor.colorPrimary : const Color(0xffC5C5C5), width: 1),
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
                                fillColor: MaterialStateProperty.all(MColor.colorPrimary),
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
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onReasonSelected(groupValue.toString(), txtRemarkController.text, selectedBUList, issueResolve);
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(160, 50)),
                      backgroundColor: MaterialStateProperty.all(MColor.colorPrimary),
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
}
