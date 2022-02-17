import 'package:dms/ui/add_store/bloc/edit_store_bloc.dart';
import 'package:dms/ui/add_store/bloc/edit_store_events.dart';
import 'package:dms/ui/add_store/bloc/edit_store_states.dart';
import 'package:dms/ui/add_store/model/select_retailer_category_response.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectRetailerCategoryBottomSheet extends StatefulWidget {
  final Function(String selectedRetailerCategory, String? selectedRetailerCategoryId) onRetailerCategorySelect;
  final String selectedRetailerCategoryName;
  const SelectRetailerCategoryBottomSheet(
      {Key? key, required this.onRetailerCategorySelect, required this.selectedRetailerCategoryName})
      : super(key: key);

  @override
  _SelectRetailerCategoryBottomSheetState createState() => _SelectRetailerCategoryBottomSheetState();
}

class _SelectRetailerCategoryBottomSheetState extends State<SelectRetailerCategoryBottomSheet> {
  List<RetailerCategoryModel>? retailerCategoryModel = [];
  Object selectRetailerCategoryRadio = "";
  String selectedRetailerCategory = "";
  String? selectedRetailerCategoryId;
  CommonBloc commonBloc = CommonBloc();

  @override
  void initState() {
    super.initState();
    selectRetailerCategoryRadio = widget.selectedRetailerCategoryName;
    selectedRetailerCategory = widget.selectedRetailerCategoryName;
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
              BlocProvider.of<EditStoreBloc>(context).add(SelectRetailerCategoryEvent());
            }
            if (state is EditStoreILoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SelectRetailerCategoryState) {
              retailerCategoryModel = state.selectRetailerCategoryResponse.data;
            }
            if (state is EditStoreFailureState) {
              return Center(
                child: Text(state.failureMessage),
              );
            }
            if (retailerCategoryModel == null) {
              return Container();
            }
            return Column(
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
                      widget.onRetailerCategorySelect(selectedRetailerCategory, selectedRetailerCategoryId);
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
          },
        ),
      ),
    );
  }

  List<Widget> radioButtonWidget() {
    List<Widget> widgets = [];
    for (RetailerCategoryModel retailerCategory in retailerCategoryModel!) {
      widgets.add(
        BlocProvider(
          create: (context) => commonBloc,
          child: BlocBuilder<CommonBloc, CommonBlocStates>(
            builder: (context, state) {
              if (state is CommonBlocInitialState) {
                if (selectRetailerCategoryRadio == retailerCategory.category) {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(enrollmentRadioTag: retailerCategory.id));
                }
              }

              if (state is CommonBlocEnrollRadioTagState) {
                selectRetailerCategoryRadio = state.enrollmentRadioTag;
              }
              return GestureDetector(
                onTap: () {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(enrollmentRadioTag: retailerCategory.id));
                  selectedRetailerCategory = retailerCategory.category;
                  selectedRetailerCategoryId = retailerCategory.id.toString();
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      child: Radio<dynamic>(
                        value: retailerCategory.id,
                        groupValue: selectRetailerCategoryRadio,
                        activeColor: MColor.colorPrimary,
                        fillColor: MaterialStateProperty.all(MColor.colorPrimary),
                        onChanged: (value) {
                          commonBloc.add(CommonBlocEnrollTypeRadioEvent(enrollmentRadioTag: value));
                          selectedRetailerCategory = retailerCategory.category;
                          selectedRetailerCategoryId = retailerCategory.id.toString();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      retailerCategory.category,
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
