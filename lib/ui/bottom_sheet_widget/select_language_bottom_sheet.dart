import 'dart:async';
import 'package:dms/main.dart';
import 'package:dms/ui/add_store/model/select_language_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class SelectLanguageBottomSheet extends StatefulWidget {
  final Function(LanguageModel? languageModel) onLanguageSelect;
  final LanguageModel? languageModel;
  final String bottomSheetHeading;
  final String previousSelectedLang;
  const SelectLanguageBottomSheet(
      {Key? key,
      required this.onLanguageSelect,
      required this.languageModel,
      required this.bottomSheetHeading,
      required this.previousSelectedLang})
      : super(key: key);

  @override
  _SelectLanguageBottomSheetState createState() =>
      _SelectLanguageBottomSheetState();
}

class _SelectLanguageBottomSheetState extends State<SelectLanguageBottomSheet> {
  int groupValue = -1;
  List<LanguageModel> languageModelList = [];
  LanguageModel? languageModel;
  StreamController<List<LanguageModel>> languageStream = StreamController();
  String failureMessage = "";

  @override
  void initState() {
    super.initState();
    if (widget.languageModel != null) {
      debugPrint("widget.selectedDistrict!.id---->${widget.languageModel!.id}");
      groupValue = widget.languageModel!.id;
      languageModel = widget.languageModel;
    }
    getLanguage();
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
      child: StreamBuilder<List<LanguageModel>>(
          stream: languageStream.stream,
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
                  Text(
                    StringConst.selectLangFirst + widget.bottomSheetHeading,
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(snapshot.data!.length, (index) {
                          if (snapshot.data![index].languageName ==
                              widget.previousSelectedLang) {
                            return Container();
                          }
                          return RadioListTile<int>(
                            contentPadding: const EdgeInsets.all(0),
                            value: snapshot.data![index].id,
                            groupValue: groupValue,
                            title: Text(
                              snapshot.data![index].languageName,
                            ),
                            onChanged: (value) {
                              groupValue = value!;
                              languageStream.add(snapshot.data!);
                            },
                          );
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
                          languageModel = languageModelList.singleWhere(
                              (element) => element.id == groupValue);
                          widget.onLanguageSelect(languageModel);
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

  void getLanguage() async {
    SelectLanguageResponse response = await repository.selectLanguage();

    if (await Network.isConnected()) {
      if (response.success) {
        languageModelList = response.data!;
        languageStream.add(languageModelList);
      } else {
        failureMessage = response.message;
        languageStream.add(languageModelList);
      }
    } else {
      failureMessage = StringConst.internetCheck;
      languageStream.add(languageModelList);
    }
  }
}
