import 'dart:async';
import 'dart:collection';
import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_filter_mrp_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class FilterOrderBookingBottomSheet extends StatefulWidget {
  final Function(FilterMrpModal? mrp) onMrpSelected;
  final FilterMrpModal? filterMrpModal;
  final String beatId;
  const FilterOrderBookingBottomSheet({
    Key? key,
    required this.onMrpSelected,
    required this.filterMrpModal,
    required this.beatId,
  }) : super(key: key);

  @override
  _FilterOrderBookingBottomSheetState createState() =>
      _FilterOrderBookingBottomSheetState();
}

class _FilterOrderBookingBottomSheetState
    extends State<FilterOrderBookingBottomSheet> {
  List<String> names = [
    "₹200",
    "₹400",
    "₹600",
    "₹800",
    "₹1000",
    "₹1200",
  ];
  int groupValue = -1;
  FilterMrpModal? filterMrpModal;
  List<FilterMrpModal> mrpList = [];
  StreamController<List<FilterMrpModal>> mrpStreamController =
      StreamController();

  @override
  void initState() {
    super.initState();
    if (widget.filterMrpModal != null) {
      debugPrint(
          "widget.selectedDistrict!.id---->${widget.filterMrpModal!.id}");
      groupValue = int.parse(widget.filterMrpModal!.id);
      filterMrpModal = widget.filterMrpModal;
    }
    getFilterMrp();
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
        child: StreamBuilder<List<FilterMrpModal>>(
            stream: mrpStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const IntrinsicHeight(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return IntrinsicHeight(
                  child: Center(
                    child: Text("${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      StringConst.filter,
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
                          children: List.generate(
                            snapshot.data!.length,
                            (index) {
                              return InkWell(
                                onTap: () {
                                  groupValue =
                                      int.parse(snapshot.data![index].id);
                                  mrpStreamController.add(snapshot.data!);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Radio<int>(
                                          value: int.parse(
                                              snapshot.data![index].id),
                                          groupValue: groupValue,
                                          activeColor: MColor.colorPrimary,
                                          fillColor: MaterialStateProperty.all(
                                              MColor.colorPrimary),
                                          onChanged: (value) {
                                            groupValue = value!;
                                            mrpStreamController
                                                .add(snapshot.data!);
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "₹" + snapshot.data![index].mrp,
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

                              // return RadioListTile<int>(
                              //   contentPadding: const EdgeInsets.all(0),
                              //   value: int.parse(snapshot.data![index].id),
                              //   groupValue: groupValue,
                              //   title: Text(
                              //     "₹" + snapshot.data![index].mrp,
                              //     style: const TextStyle(
                              //       fontSize: 17.0,
                              //       color: MColor.backButton,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              //   onChanged: (value) {
                              //     groupValue = value!;
                              //     mrpStreamController.add(snapshot.data!);
                              //   },
                              // );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              if (groupValue != -1) {
                                filterMrpModal = mrpList.singleWhere(
                                    (element) =>
                                        element.id == groupValue.toString());
                                widget.onMrpSelected(filterMrpModal!);
                              }
                              Navigator.pop(context);
                            },
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 55),
                            color: MColor.colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                            child: const Text(
                              StringConst.done,
                              style: TextStyle(
                                letterSpacing: 0.67,
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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

  void getFilterMrp() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["beat_id"] = widget.beatId;
    GetFilterMrpResponse response = await repository.getFilterMrp(input);
    if (await Network.isConnected()) {
      if (response.success) {
        mrpList = response.data!;
        mrpList
            .sort((a, b) => double.parse(a.mrp).compareTo(double.parse(b.mrp)));
        mrpStreamController.add(mrpList);
      } else {
        mrpStreamController.addError(response.message);
      }
    } else {
      mrpStreamController.addError(StringConst.internetCheck);
    }
  }
}
