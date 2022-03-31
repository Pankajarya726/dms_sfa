import 'dart:async';
import 'package:dms/main.dart';
import 'package:dms/ui/custom_widget/tag_widget.dart';
import 'package:dms/ui/order_booking/order_confirmation/model/get_reason_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';

class OrderConfRemarkBottomSheet extends StatefulWidget {
  const OrderConfRemarkBottomSheet({Key? key}) : super(key: key);

  @override
  _OrderConfRemarkBottomSheetState createState() =>
      _OrderConfRemarkBottomSheetState();
}

class _OrderConfRemarkBottomSheetState
    extends State<OrderConfRemarkBottomSheet> {
  List<ReasonsModal> reasons = [];
  int groupValue = -1;
  bool issueResolve = false;
  StreamController<List<ReasonsModal>> reasonStreamController =
      StreamController();
  List buList = ["Yellow diamond", "Hoppin", "Shree", "Anik", "Tiny Tush"];

  @override
  void initState() {
    getReasons();
    super.initState();
  }

  @override
  void dispose() {
    reasonStreamController.close();
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  StringConst.remark,
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
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
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
                TagWidget(items: buList),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: issueResolve,
                      onChanged: (value) {
                        issueResolve = value!;
                        setState(() {});
                      },
                      splashRadius: 15,
                      visualDensity: VisualDensity.compact,
                    ),
                    const Text("Issue Resolve"),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
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
      ),
    );
  }

  void getReasons() async {
    if (await Network.isConnected()) {
      GetReasonsResponse response = await repository.getReasons();
      if (response.success) {
        reasons = response.data!;
        reasonStreamController.add(reasons);
      } else {
        reasonStreamController.addError(response.message);
      }
    } else {
      reasonStreamController.addError(StringConst.internetCheck);
    }
  }
}
