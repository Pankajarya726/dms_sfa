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
  String failureMessage = "";

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
    return Container(
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
                              retailerTypeStream.add(snapshot.data!);
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
                          retailerTypeModel = retailerTypeList.singleWhere(
                              (element) => element.id == groupValue);
                          widget.onRetailerTypeSelect(retailerTypeModel);
                        }
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(const Size(220, 60)),
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

  getRetailerType() async {
    SelectRetailerTypeResponse response = await repository.selectRetailerType();
    if (await Network.isConnected()) {
      if (response.success) {
        retailerTypeList = response.data!;
        retailerTypeStream.add(retailerTypeList);
      } else {
        failureMessage = response.message;
        retailerTypeStream.add(retailerTypeList);
      }
    } else {
      failureMessage = StringConst.internetCheck;
      retailerTypeStream.add(retailerTypeList);
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
