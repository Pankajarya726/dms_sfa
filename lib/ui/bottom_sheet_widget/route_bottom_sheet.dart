import 'package:dms/ui/custom_widget/drop_down_field.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailer_bloc.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailers_event.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailers_state.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailers_tab.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteBottomSheet extends StatefulWidget {
  const RouteBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  _RouteBottomSheetState createState() => _RouteBottomSheetState();
}

class _RouteBottomSheetState extends State<RouteBottomSheet> {
  TextEditingController edtBookingDay = TextEditingController();
  TextEditingController edtPriority = TextEditingController();

  String selectedPrioType = "";
  List<BeatsModal> beats = [];
  BeatsModal beatModal = BeatsModal(id: "", name: "All");
  bool retailerCheck = false;
  bool teleRetailerCheck = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: IntrinsicHeight(
        child: BlocProvider(
          create: (context) => RetailersBloc(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // shrinkWrap: false,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                StringConst.route,
                style: TextStyle(
                  color: MColor.colorPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.67,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                StringConst.selectBeat,
                style: TextStyle(
                  color: MColor.inactiveTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.67,
                ),
              ),
              BlocBuilder<RetailersBloc, RetailerState>(
                  builder: (context, state) {
                if (state is RetailerInitState) {
                  BlocProvider.of<RetailersBloc>(context).add(GetBeatEvent());
                }
                if (state is GetBeatState) {
                  beats = state.beats;
                  beatModal = beats.first;
                }
                return SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: BeatWidget(
                    selectedBeat: "",
                    tags: beats,
                    onSelect: (BeatsModal tag) {
                      debugPrint("onBeatSelect-->${tag.name}");
                      beatModal = tag;
                    },
                  ),
                );
              }),
              const Text(
                StringConst.selectEnrolmentType,
                style: TextStyle(
                  color: MColor.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.67,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CheckboxListTile(
                title: const Text(StringConst.retailer),
                value: retailerCheck,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    retailerCheck = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text(StringConst.teleRetailer),
                value: teleRetailerCheck,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    teleRetailerCheck = value!;
                  });
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      color: MColor.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                      child: const Text(
                        StringConst.getRoute,
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
            ],
          ),
        ),
      ),
    );
  }
}
