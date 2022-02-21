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
      {Key? key, required this.onDistributorSelect, required this.distributorModel, required this.districtId})
      : super(key: key);

  @override
  _SelectDistributorBottomSheetState createState() => _SelectDistributorBottomSheetState();
}

class _SelectDistributorBottomSheetState extends State<SelectDistributorBottomSheet> {
  int groupValue = -1;
  List<DistributorModel> distributorList = [];
  DistributorModel? selectedDistributor;
  StreamController<List<DistributorModel>> distributorStream = StreamController();
  String failureMessage = "";

  @override
  void initState() {
    super.initState();
    if (widget.distributorModel != null) {
      debugPrint("widget.selectedDistrict!.id---->${widget.distributorModel!.id}");
      groupValue = widget.distributorModel!.id;
      selectedDistributor = widget.distributorModel;
    }
    getDistributors();
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
      child: StreamBuilder<List<DistributorModel>>(
          stream: distributorStream.stream,
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
                    StringConst.selectDistributor,
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          snapshot.data!.length,
                          (index) => RadioListTile<int>(
                            contentPadding: const EdgeInsets.all(0),
                            value: snapshot.data![index].id,
                            groupValue: groupValue,
                            title: Text(
                              snapshot.data![index].name,
                            ),
                            onChanged: (value) {
                              groupValue = value!;
                              distributorStream.add(snapshot.data!);
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
                          selectedDistributor = distributorList.singleWhere((element) => element.id == groupValue);
                          widget.onDistributorSelect(selectedDistributor!);
                        }
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(220, 60)),
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

  getDistributors() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["districts_id"] = widget.districtId;
    SelectDistributorResponse response = await repository.selectDistributor(input);
    if (await Network.isConnected()) {
      if (response.success) {
        distributorList = response.data!;
        debugPrint("groupValue--->$groupValue");
        distributorStream.add(distributorList);
      } else {
        failureMessage = response.message;
        distributorStream.add(distributorList);
      }
    } else {
      failureMessage = StringConst.internetCheck;
      distributorStream.add(distributorList);
      // Utility.showToast(response.message);
    }
  }
}
