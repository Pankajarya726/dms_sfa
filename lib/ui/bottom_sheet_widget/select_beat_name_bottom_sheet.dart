import 'dart:async';
import 'dart:collection';
import 'package:dms/main.dart';
import 'package:dms/ui/add_store/model/select_beat_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class SelectBeatNameBottomSheet extends StatefulWidget {
  final Function(BeatModal? beatModal) onBeatNameSelect;
  final BeatModal? beatModal;
  final String customerCode;
  const SelectBeatNameBottomSheet(
      {Key? key,
      required this.onBeatNameSelect,
      required this.beatModal,
      required this.customerCode})
      : super(key: key);

  @override
  _SelectBeatNameBottomSheetState createState() =>
      _SelectBeatNameBottomSheetState();
}

class _SelectBeatNameBottomSheetState extends State<SelectBeatNameBottomSheet> {
  int groupValue = -1;
  BeatModal? beatModal;
  StreamController<List<BeatModal>> beatStream = StreamController();
  List<BeatModal> beatList = [];
  String failureMessage = "";

  @override
  void initState() {
    super.initState();
    if (widget.beatModal != null) {
      debugPrint("widget.selectedDistrict!.id---->${widget.beatModal!.id}");
      groupValue = widget.beatModal!.id;
      beatModal = widget.beatModal;
    }
    getBeats();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      child: StreamBuilder<List<BeatModal>>(
          stream: beatStream.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (failureMessage == StringConst.internetCheck) {
              return Center(
                child: Text(failureMessage),
              );
            }
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(failureMessage),
              );
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    StringConst.beatName,
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          snapshot.data!.length,
                          (index) => RadioListTile<int>(
                            contentPadding: const EdgeInsets.all(0),
                            value: snapshot.data![index].id,
                            groupValue: groupValue,
                            title: Text(
                              snapshot.data![index].name,
                              style: const TextStyle(
                                fontSize: 17.0,
                                color: MColor.backButton,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onChanged: (value) {
                              groupValue = value!;
                              beatStream.add(snapshot.data!);
                            },
                          ),
                        ),
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
                          beatModal = beatList.singleWhere(
                              (element) => element.id == groupValue);
                          widget.onBeatNameSelect(beatModal!);
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
    );
  }

  void getBeats() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["customer_codes"] = widget.customerCode;
    SelectBeatResponse response = await repository.selectBeat(input);
    if (await Network.isConnected()) {
      if (response.success) {
        beatList = response.data!;
        beatStream.add(beatList);
      } else {
        failureMessage = response.message;
        beatStream.add(beatList);
      }
    } else {
      failureMessage = StringConst.internetCheck;
      beatStream.add(beatList);
    }
  }
}
