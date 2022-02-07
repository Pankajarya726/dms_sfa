import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/ui/order_booking/edit_store/bloc/edit_store_bloc.dart';
import 'package:dms/ui/order_booking/edit_store/bloc/edit_store_events.dart';
import 'package:dms/ui/order_booking/edit_store/bloc/edit_store_states.dart';
import 'package:dms/ui/order_booking/edit_store/model/call_time_slot_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCallTimeSlotBottomSheet extends StatefulWidget {
  final Function(String selectedCallTimeSlot) onCallTimeSlotSelect;
  final String selectedCallTimeSlotName;
  const SelectCallTimeSlotBottomSheet(
      {Key? key,
      required this.onCallTimeSlotSelect,
      required this.selectedCallTimeSlotName})
      : super(key: key);

  @override
  _SelectCallTimeSlotBottomSheetState createState() =>
      _SelectCallTimeSlotBottomSheetState();
}

class _SelectCallTimeSlotBottomSheetState
    extends State<SelectCallTimeSlotBottomSheet> {
  String time = "";
  Object selectCallTimeSlotRadio = "";
  String selectedCallTimeSlot = "";
  CommonBloc commonBloc = CommonBloc();
  List<CallTimeSlotModel>? callTimeSlotModel = [];

  @override
  void initState() {
    super.initState();
    selectCallTimeSlotRadio = widget.selectedCallTimeSlotName;
    selectedCallTimeSlot = widget.selectedCallTimeSlotName;
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
      child: BlocProvider(
        create: (context) => EditStoreBloc(),
        child: BlocBuilder<EditStoreBloc, EditStoreStates>(
          builder: (context, state) {
            if (state is EditStoreInitialState) {
              BlocProvider.of<EditStoreBloc>(context)
                  .add(SelectCallTimeSlotEvent());
            }
            if (state is EditStoreILoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SelectCallTimeSlotState) {
              callTimeSlotModel = state.callTimeSlotResponse.data;
            }
            if (state is EditStoreFailureState) {
              return Center(
                child: Text(state.failureMessage),
              );
            }
            if (callTimeSlotModel == null) {
              return Container();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  callTimeSlot,
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
                      children: radioButtonWidget(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onCallTimeSlotSelect(selectedCallTimeSlot);
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(220, 60)),
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
                      done,
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
          },
        ),
      ),
    );
  }

  List<Widget> radioButtonWidget() {
    List<Widget> widgets = [];
    for (CallTimeSlotModel callTimeSlot in callTimeSlotModel!) {
      time = callTimeSlot.from + " to " + callTimeSlot.to;
      widgets.add(
        BlocProvider(
          create: (context) => commonBloc,
          child: BlocBuilder<CommonBloc, CommonBlocStates>(
            builder: (context, state) {
              if (state is CommonBlocInitialState) {
                if (selectCallTimeSlotRadio == time) {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                      enrollmentRadioTag: callTimeSlot.id));
                }
              }

              if (state is CommonBlocEnrollRadioTagState) {
                selectCallTimeSlotRadio = state.enrollmentRadioTag;
              }
              return GestureDetector(
                onTap: () {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                      enrollmentRadioTag: callTimeSlot.id));
                  selectedCallTimeSlot = time;
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      child: Radio<dynamic>(
                        value: callTimeSlot.id,
                        groupValue: selectCallTimeSlotRadio,
                        activeColor: MColor.colorPrimary,
                        fillColor:
                            MaterialStateProperty.all(MColor.colorPrimary),
                        onChanged: (value) {
                          commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                              enrollmentRadioTag: value));
                          selectedCallTimeSlot = time;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 17.0,
                        color: MColor.backButton,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
    return widgets;
  }
}
