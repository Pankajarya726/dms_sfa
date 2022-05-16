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
  StreamController<List<LanguageModel>> searchStream = StreamController();
  TextEditingController txtSearchController = TextEditingController();

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
        child: StreamBuilder<List<LanguageModel>>(
            stream: languageStream.stream,
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
                    child: Text(snapshot.error.toString()),
                  ),
                );
              }

              if (snapshot.hasData) {
                return StreamBuilder<List<LanguageModel>>(
                    stream: searchStream.stream,
                    initialData: languageModelList,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringConst.selectLangFirst +
                                  widget.bottomSheetHeading,
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
                            TextFormField(
                              style: const TextStyle(fontSize: 16),
                              onChanged: (text) {
                                if (text.isNotEmpty) {
                                  List<LanguageModel> searchList = [];
                                  for (var element in languageModelList) {
                                    if (element.languageName
                                        .toLowerCase()
                                        .contains(text.trim().toLowerCase())) {
                                      searchList.add(element);
                                    }
                                  }
                                  searchStream.add(searchList);
                                } else {
                                  searchStream.add(languageModelList);
                                }
                              },
                              decoration: InputDecoration(
                                hintText: StringConst.search,
                                hintStyle: const TextStyle(fontSize: 16),
                                contentPadding: const EdgeInsets.all(10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  gapPadding: 2,
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color(0xFF6E6E6E),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  gapPadding: 2,
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color(0xFF6E6E6E),
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xff555555),
                                ),
                              ),
                            ),
                            snapshot.data!.isEmpty
                                ? const SizedBox(
                                    height: 20,
                                  )
                                : const SizedBox(
                                    height: 5,
                                  ),
                            snapshot.data!.isNotEmpty
                                ? Flexible(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: List.generate(
                                            snapshot.data!.length, (index) {
                                          if (snapshot
                                                  .data![index].languageName ==
                                              widget.previousSelectedLang) {
                                            return Container();
                                          }
                                          return InkWell(
                                            onTap: () {
                                              groupValue =
                                                  snapshot.data![index].id;
                                              languageStream
                                                  .add(snapshot.data!);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: Radio<int>(
                                                      value: snapshot
                                                          .data![index].id,
                                                      groupValue: groupValue,
                                                      activeColor:
                                                          MColor.colorPrimary,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .all(MColor
                                                                  .colorPrimary),
                                                      onChanged: (value) {
                                                        groupValue = value!;
                                                        languageStream.add(
                                                            snapshot.data!);
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      snapshot.data![index]
                                                          .languageName,
                                                      maxLines: 5,
                                                      style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 17.0,
                                                        color:
                                                            MColor.backButton,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                          //   contentPadding:
                                          //       const EdgeInsets.all(0),
                                          //   value: snapshot.data![index].id,
                                          //   groupValue: groupValue,
                                          //   title: Text(
                                          //     snapshot
                                          //         .data![index].languageName,
                                          //     style: const TextStyle(
                                          //       fontSize: 17.0,
                                          //       color: MColor.backButton,
                                          //       fontWeight: FontWeight.bold,
                                          //     ),
                                          //   ),
                                          //   onChanged: (value) {
                                          //     groupValue = value!;
                                          //     languageStream
                                          //         .add(snapshot.data!);
                                          //   },
                                          // );
                                        }),
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Text("Data not found"),
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (groupValue != -1) {
                                    languageModel = languageModelList
                                        .singleWhere((element) =>
                                            element.id == groupValue);
                                    widget.onLanguageSelect(languageModel);
                                  }
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(180, 55)),
                                  backgroundColor: MaterialStateProperty.all(
                                      MColor.colorPrimary),
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
                        ),
                      );
                    });
              }
              return Container();
            }),
      ),
    );
  }

  void getLanguage() async {
    SelectLanguageResponse response = await repository.selectLanguage();

    if (await Network.isConnected()) {
      if (response.success) {
        languageModelList = response.data!;
        languageStream.add(languageModelList);
      } else {
        languageStream.addError(response.message);
      }
    } else {
      languageStream.addError(StringConst.internetCheck);
    }
  }
}
