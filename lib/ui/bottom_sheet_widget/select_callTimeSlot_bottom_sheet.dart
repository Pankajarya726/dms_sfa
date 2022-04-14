import 'dart:async';
import 'package:dms/main.dart';
import 'package:dms/ui/add_store/model/call_time_slot_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class SelectCallTimeSlotBottomSheet extends StatefulWidget {
  final Function(CallTimeSlotModel? callTimeSlotModel) onCallTimeSlotSelect;
  final CallTimeSlotModel? callTimeSlotModel;
  const SelectCallTimeSlotBottomSheet(
      {Key? key,
      required this.onCallTimeSlotSelect,
      required this.callTimeSlotModel})
      : super(key: key);

  @override
  _SelectCallTimeSlotBottomSheetState createState() =>
      _SelectCallTimeSlotBottomSheetState();
}

class _SelectCallTimeSlotBottomSheetState
    extends State<SelectCallTimeSlotBottomSheet> {
  String time = "";
  int groupValue = -1;
  List<CallTimeSlotModel> callTimeSlotList = [];
  CallTimeSlotModel? callTimeSlotModel;
  StreamController<List<CallTimeSlotModel>> callTimeSlotStream =
      StreamController();
  String failureMessage = "";

  @override
  void initState() {
    super.initState();
    if (widget.callTimeSlotModel != null) {
      debugPrint(
          "widget.selectedDistrict!.id---->${widget.callTimeSlotModel!.id}");
      groupValue = widget.callTimeSlotModel!.id;
      callTimeSlotModel = widget.callTimeSlotModel;
      time = widget.callTimeSlotModel!.from +
          " to " +
          widget.callTimeSlotModel!.to;
    }
    getCallTimeSlot();
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
        child: StreamBuilder<List<CallTimeSlotModel>>(
            stream: callTimeSlotStream.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const IntrinsicHeight(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (failureMessage == StringConst.internetCheck) {
                return IntrinsicHeight(
                  child: Center(
                    child: Text(failureMessage),
                  ),
                );
              }
              if (snapshot.data!.isEmpty) {
                return IntrinsicHeight(
                  child: Center(
                    child: Text(failureMessage),
                  ),
                );
              }
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      StringConst.callTimeSlot,
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:
                              List.generate(snapshot.data!.length, (index) {
                            time = snapshot.data![index].from +
                                " to " +
                                snapshot.data![index].to;
                            return RadioListTile<int>(
                              contentPadding: const EdgeInsets.all(0),
                              value: snapshot.data![index].id,
                              groupValue: groupValue,
                              title: Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 17.0,
                                  color: MColor.backButton,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onChanged: (value) {
                                groupValue = value!;
                                callTimeSlotStream.add(snapshot.data!);
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (groupValue != -1) {
                            callTimeSlotModel = callTimeSlotList.singleWhere(
                                (element) => element.id == groupValue);
                            widget.onCallTimeSlotSelect(callTimeSlotModel);
                          }
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(const Size(180, 55)),
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
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }

  void getCallTimeSlot() async {
    CallTimeSlotResponse response = await repository.selectCallTimeslot();
    if (await Network.isConnected()) {
      if (response.success) {
        callTimeSlotList = response.data!;
        callTimeSlotStream.add(callTimeSlotList);
      } else {
        failureMessage = response.message;
        callTimeSlotStream.add(callTimeSlotList);
      }
    } else {
      failureMessage = StringConst.internetCheck;
      callTimeSlotStream.add(callTimeSlotList);
    }
  }
}
