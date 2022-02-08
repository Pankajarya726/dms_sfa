import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/ui/order_booking/edit_store/bloc/edit_store_bloc.dart';
import 'package:dms/ui/order_booking/edit_store/bloc/edit_store_events.dart';
import 'package:dms/ui/order_booking/edit_store/bloc/edit_store_states.dart';
import 'package:dms/ui/order_booking/edit_store/model/select_city_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCityBottomSheet extends StatefulWidget {
  final Function(String selectedCity, int? selectedCityId) onCitySelect;
  final String selectedCityName;
  const SelectCityBottomSheet(
      {Key? key, required this.onCitySelect, required this.selectedCityName})
      : super(key: key);

  @override
  _SelectCityBottomSheetState createState() => _SelectCityBottomSheetState();
}

class _SelectCityBottomSheetState extends State<SelectCityBottomSheet> {
  // List<String> names = [
  //   "Indore",
  //   "Bhopal",
  //   "Delhi",
  //   "Surat",
  //   "Banglore",
  // ];
  Object selectCityRadio = "";
  String selectedCity = "";
  int? selectedCityId;
  CommonBloc commonBloc = CommonBloc();
  List<CityModel>? cityModel = [];

  @override
  void initState() {
    super.initState();
    selectCityRadio = widget.selectedCityName;
    selectedCity = widget.selectedCityName;
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
              BlocProvider.of<EditStoreBloc>(context).add(SelectCityEvent());
            }
            if (state is EditStoreILoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SelectCityState) {
              cityModel = state.selectCityResponse.data;
            }
            if (state is EditStoreFailureState) {
              return Center(
                child: Text(state.failureMessage),
              );
            }
            if (cityModel == null) {
              return Container();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  selectCity,
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
                      widget.onCitySelect(selectedCity, selectedCityId!);
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
    for (CityModel cities in cityModel!) {
      widgets.add(
        BlocProvider(
          create: (context) => commonBloc,
          child: BlocBuilder<CommonBloc, CommonBlocStates>(
            builder: (context, state) {
              if (state is CommonBlocInitialState) {
                if (selectCityRadio == cities.name) {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                      enrollmentRadioTag: cities.id));
                }
              }

              if (state is CommonBlocEnrollRadioTagState) {
                selectCityRadio = state.enrollmentRadioTag;
              }
              return GestureDetector(
                onTap: () {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                      enrollmentRadioTag: cities.id));
                  selectedCity = cities.name;
                  selectedCityId = cities.id;
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      child: Radio<dynamic>(
                        value: cities.id,
                        groupValue: selectCityRadio,
                        activeColor: MColor.colorPrimary,
                        fillColor:
                            MaterialStateProperty.all(MColor.colorPrimary),
                        onChanged: (value) {
                          commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                              enrollmentRadioTag: value));
                          selectedCity = cities.name;
                          selectedCityId = cities.id;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      cities.name,
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
