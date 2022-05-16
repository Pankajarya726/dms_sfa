import 'dart:async';
import 'package:dms/main.dart';
import 'package:dms/ui/add_store/model/select_retailer_category_response.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class SelectRetailerCategoryBottomSheet extends StatefulWidget {
  final Function(RetailerCategoryModel? retailerCategoryModel)
      onRetailerCategorySelect;
  final RetailerCategoryModel? retailerCategoryModel;
  const SelectRetailerCategoryBottomSheet(
      {Key? key,
      required this.onRetailerCategorySelect,
      required this.retailerCategoryModel})
      : super(key: key);

  @override
  _SelectRetailerCategoryBottomSheetState createState() =>
      _SelectRetailerCategoryBottomSheetState();
}

class _SelectRetailerCategoryBottomSheetState
    extends State<SelectRetailerCategoryBottomSheet> {
  int groupValue = -1;
  CommonBloc commonBloc = CommonBloc();
  StreamController<List<RetailerCategoryModel>> retailerCategoryStream =
      StreamController();
  RetailerCategoryModel? retailerCategoryModel;
  List<RetailerCategoryModel> retailerCategoryList = [];
  String failureMessage = "";

  @override
  void initState() {
    super.initState();
    if (widget.retailerCategoryModel != null) {
      debugPrint(
          "widget.selectedDistrict!.id---->${widget.retailerCategoryModel!.id}");
      groupValue = widget.retailerCategoryModel!.id;
      retailerCategoryModel = widget.retailerCategoryModel;
    }

    getRetailerCategory();
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
        child: StreamBuilder<List<RetailerCategoryModel>>(
            stream: retailerCategoryStream.stream,
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
                      StringConst.retailerCategory,
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
                            return InkWell(
                              onTap: () {
                                groupValue = snapshot.data![index].id;
                                retailerCategoryStream.add(snapshot.data!);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Radio<int>(
                                        value: snapshot.data![index].id,
                                        groupValue: groupValue,
                                        activeColor: MColor.colorPrimary,
                                        fillColor: MaterialStateProperty.all(
                                            MColor.colorPrimary),
                                        onChanged: (value) {
                                          groupValue = value!;
                                          retailerCategoryStream
                                              .add(snapshot.data!);
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        snapshot.data![index].category,
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

                            // return RadioListTile<int>(
                            //   contentPadding: const EdgeInsets.all(0),
                            //   value: snapshot.data![index].id,
                            //   groupValue: groupValue,
                            //   title: Text(
                            //     snapshot.data![index].category,
                            //     style: const TextStyle(
                            //       fontSize: 17.0,
                            //       color: MColor.backButton,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            //   onChanged: (value) {
                            //     groupValue = value!;
                            //     retailerCategoryStream.add(snapshot.data!);
                            //   },
                            // );
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
                            retailerCategoryModel =
                                retailerCategoryList.singleWhere(
                                    (element) => element.id == groupValue);
                            widget.onRetailerCategorySelect(
                                retailerCategoryModel);
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

  void getRetailerCategory() async {
    SelectRetailerCategoryResponse response =
        await repository.selectRetailerCategory();
    if (await Network.isConnected()) {
      if (response.success) {
        retailerCategoryList = response.data!;
        retailerCategoryStream.add(retailerCategoryList);
      } else {
        failureMessage = response.message;
        retailerCategoryStream.add(retailerCategoryList);
      }
    } else {
      failureMessage = StringConst.internetCheck;
      retailerCategoryStream.add(retailerCategoryList);
    }
  }
}
