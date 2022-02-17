import 'dart:async';

import 'package:dms/main.dart';
import 'package:dms/ui/add_store/model/select_district_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';

class SelectDistrictBottomSheet extends StatefulWidget {
  final Function(DistrictModel distric) onDistrictSelect;
  final DistrictModel? selectedDistrict;

  const SelectDistrictBottomSheet({Key? key, required this.onDistrictSelect, required this.selectedDistrict}) : super(key: key);

  @override
  _SelectDistrictBottomSheetState createState() => _SelectDistrictBottomSheetState();
}

class _SelectDistrictBottomSheetState extends State<SelectDistrictBottomSheet> {
  int groupValue = -1;
  DistrictModel? selectedDistrict;
  List<DistrictModel> districtList = [];
  StreamController<List<DistrictModel>> districtStream = StreamController();

  @override
  void initState() {
    if (widget.selectedDistrict != null) {
      debugPrint("widget.selectedDistrict!.id---->${widget.selectedDistrict!.id}");
      groupValue = widget.selectedDistrict!.id;
      selectedDistrict = widget.selectedDistrict;
    }
    getDistricts();
    super.initState();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringConst.selectDistrict,
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
            StreamBuilder<List<DistrictModel>>(
                stream: districtStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Expanded(
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
                                districtStream.add(snapshot.data!);
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                }),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (groupValue != -1) {
                    selectedDistrict = districtList.singleWhere((element) => element.id == groupValue);
                    widget.onDistrictSelect(selectedDistrict!);
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
        ));
  }

  getDistricts() async {
    SelectDistrictResponse response = await repository.selectDistrict();
    if (response.success) {
      districtList = response.data!;
      debugPrint("groupValue--->$groupValue");
      districtStream.add(districtList);
    } else {
      Utility.showToast(response.message);
    }
  }
}
