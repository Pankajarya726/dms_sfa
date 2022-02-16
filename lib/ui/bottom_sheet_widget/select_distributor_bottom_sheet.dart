import 'package:dms/ui/add_store/bloc/edit_store_bloc.dart';
import 'package:dms/ui/add_store/bloc/edit_store_events.dart';
import 'package:dms/ui/add_store/bloc/edit_store_states.dart';
import 'package:dms/ui/add_store/model/select_distributor_response.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectDistributorBottomSheet extends StatefulWidget {
  final Function(String selectedDistributor, String? selectedDistributorId)
      onDistributorSelect;
  final String selectedDistributorName;
  const SelectDistributorBottomSheet(
      {Key? key,
      required this.onDistributorSelect,
      required this.selectedDistributorName})
      : super(key: key);

  @override
  _SelectDistributorBottomSheetState createState() =>
      _SelectDistributorBottomSheetState();
}

class _SelectDistributorBottomSheetState
    extends State<SelectDistributorBottomSheet> {
  // List<String> names = [
  //   "Murtuza",
  //   "Himanshu",
  //   "Vaibhav",
  //   "Pankaj",
  //   "Rishabh",
  //   "Chandan",
  //   "Atul",
  //   "Aakash",
  // ];
  Object selectDistributorRadio = "";
  String selectedDistributor = "";
  String? selectedDistributorId;
  CommonBloc commonBloc = CommonBloc();
  List<DistributorModel>? distributorModel = [];

  @override
  void initState() {
    super.initState();
    selectDistributorRadio = widget.selectedDistributorName;
    selectedDistributor = widget.selectedDistributorName;
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
                  .add(SelectDistributorEvent());
            }
            if (state is EditStoreILoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SelectDistributorState) {
              distributorModel = state.selectDistributorResponse.data;
            }
            if (state is EditStoreFailureState) {
              return Center(
                child: Text(state.failureMessage),
              );
            }
            if (distributorModel == null) {
              return Container();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  selectDistributor,
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
                      widget.onDistributorSelect(
                          selectedDistributor, selectedDistributorId);
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
    for (DistributorModel distributor in distributorModel!) {
      widgets.add(
        BlocProvider(
          create: (context) => commonBloc,
          child: BlocBuilder<CommonBloc, CommonBlocStates>(
            builder: (context, state) {
              if (state is CommonBlocInitialState) {
                if (selectDistributorRadio == distributor.name) {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                      enrollmentRadioTag: distributor.id));
                }
              }

              if (state is CommonBlocEnrollRadioTagState) {
                selectDistributorRadio = state.enrollmentRadioTag;
              }
              return GestureDetector(
                onTap: () {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                      enrollmentRadioTag: distributor.id));
                  selectedDistributor = distributor.name;
                  selectedDistributorId = distributor.id.toString();
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      child: Radio<dynamic>(
                        value: distributor.id,
                        groupValue: selectDistributorRadio,
                        activeColor: MColor.colorPrimary,
                        fillColor:
                            MaterialStateProperty.all(MColor.colorPrimary),
                        onChanged: (value) {
                          commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                              enrollmentRadioTag: value));
                          selectedDistributor = distributor.name;
                          selectedDistributorId = distributor.id.toString();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      distributor.name,
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
