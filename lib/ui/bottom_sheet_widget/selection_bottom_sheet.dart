import 'dart:async';

import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class SelectionBottomSheet extends StatefulWidget {
  final List<Selection> selection;
  final Selection? selected;
  final Function(Selection selection) onSelect;
  final String header;

  const SelectionBottomSheet({Key? key, this.selected, required this.selection, required this.onSelect, required this.header})
      : super(key: key);

  @override
  _SelectionBottomSheetState createState() => _SelectionBottomSheetState();
}

class _SelectionBottomSheetState extends State<SelectionBottomSheet> {
  List<Selection> selection = [];
  Selection? selected;
  StreamController<List<Selection>> searchStream = StreamController();
  TextEditingController txtSearchController = TextEditingController();
  Selection groupValue = Selection(id: "", name: "");

  @override
  initState() {
    if (widget.selected != null) {
      selected = widget.selected;
    }
    selection = widget.selection;
    searchStream.add(selection);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
        minHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        margin: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.header,
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
                  List<Selection> searchList = [];
                  for (var element in selection) {
                    if (element.name.toLowerCase().contains(text.trim().toLowerCase())) {
                      searchList.add(element);
                    }
                  }
                  searchStream.add(searchList);
                } else {
                  searchStream.add(selection);
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
            StreamBuilder<List<Selection>>(
                stream: searchStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const SizedBox(
                      height: 20,
                    );
                  }

                  if (snapshot.hasData) {
                    return Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(snapshot.data!.length, (index) {
                            return InkWell(
                              onTap: () {
                                groupValue = snapshot.data![index];
                                searchStream.add(snapshot.data!);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Radio<Selection>(
                                        value: snapshot.data![index],
                                        groupValue: groupValue,
                                        activeColor: MColor.colorPrimary,
                                        fillColor: MaterialStateProperty.all(MColor.colorPrimary),
                                        onChanged: (value) {
                                          groupValue = value!;
                                          searchStream.add(snapshot.data!);
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        snapshot.data![index].name,
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

                            //  return RadioListTile<int>(
                            //     contentPadding:
                            //         const EdgeInsets.all(0),
                            //     value: snapshot.data![index].id,
                            //     groupValue: groupValue,
                            //     title: Text(
                            //       snapshot.data![index].name,
                            //       style: const TextStyle(
                            //         fontSize: 17.0,
                            //         color: MColor.backButton,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //     onChanged: (value) {
                            //       groupValue = value!;
                            //       districtStream
                            //           .add(snapshot.data!);
                            //     },
                            //   );
                          }),
                        ),
                      ),
                    );
                  }

                  return const Center(
                    child: Text("Data not found"),
                  );
                }),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (groupValue.id != "") {
                    selected = selection.singleWhere((element) => element.id == groupValue.id);
                    widget.onSelect(selected!);
                  }

                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(180, 55)),
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
        ),
      ),
    );
  }
}

class Selection {
  String id;
  String name;

  Selection({required this.id, required this.name});
}
