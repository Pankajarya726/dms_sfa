import 'package:dms/ui/add_store/bloc/edit_store_bloc.dart';
import 'package:dms/ui/add_store/bloc/edit_store_events.dart';
import 'package:dms/ui/add_store/bloc/edit_store_states.dart';
import 'package:dms/ui/add_store/model/select_language_response.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectLanguageBottomSheet extends StatefulWidget {
  final Function(String selectedLanguage, int? selectedLangId) onLanguageSelect;
  final String selectedLanguageName;
  final String bottomSheetHeading;
  final String previousSelectedLang;
  const SelectLanguageBottomSheet(
      {Key? key,
      required this.onLanguageSelect,
      required this.selectedLanguageName,
      required this.bottomSheetHeading,
      required this.previousSelectedLang})
      : super(key: key);

  @override
  _SelectLanguageBottomSheetState createState() =>
      _SelectLanguageBottomSheetState();
}

class _SelectLanguageBottomSheetState extends State<SelectLanguageBottomSheet> {
  // List<String> names = [
  //   "English",
  //   "Hindi",
  //   "Tamil",
  //   "Urdu",
  //   "Telgu",
  //   "Marathi",
  // ];
  Object selectLanguageRadio = "";
  String selectedLanguage = "";
  int? selectedLanguageId;
  CommonBloc commonBloc = CommonBloc();
  List<LanguageModel>? languageModel = [];

  @override
  void initState() {
    super.initState();
    selectLanguageRadio = widget.selectedLanguageName;
    selectedLanguage = widget.selectedLanguageName;
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
                  .add(SelectLanguageTypeEvent());
            }
            if (state is EditStoreILoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SelectLanguageTypeState) {
              languageModel = state.selectLanguageResponse.data;
            }
            if (state is EditStoreFailureState) {
              return Center(
                child: Text(state.failureMessage),
              );
            }
            if (languageModel == null) {
              return Container();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectLangFirst + widget.bottomSheetHeading,
                  style: const TextStyle(
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
                      widget.onLanguageSelect(
                          selectedLanguage, selectedLanguageId);
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
    for (LanguageModel language in languageModel!) {
      widgets.add(
        BlocProvider(
          create: (context) => commonBloc,
          child: BlocBuilder<CommonBloc, CommonBlocStates>(
            builder: (context, state) {
              if (state is CommonBlocInitialState) {
                if (selectLanguageRadio == language.languageName) {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                      enrollmentRadioTag: language.id));
                }
              }

              if (state is CommonBlocEnrollRadioTagState) {
                selectLanguageRadio = state.enrollmentRadioTag;
              }
              if (language.languageName == widget.previousSelectedLang) {
                return Container();
              }
              return GestureDetector(
                onTap: () {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                      enrollmentRadioTag: language.id));
                  selectedLanguage = language.languageName;
                  selectedLanguageId = language.id;
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      child: Radio<dynamic>(
                        value: language.id,
                        groupValue: selectLanguageRadio,
                        activeColor: MColor.colorPrimary,
                        fillColor:
                            MaterialStateProperty.all(MColor.colorPrimary),
                        onChanged: (value) {
                          commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                              enrollmentRadioTag: value));
                          selectedLanguage = language.languageName;
                          selectedLanguageId = language.id;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      language.languageName,
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
