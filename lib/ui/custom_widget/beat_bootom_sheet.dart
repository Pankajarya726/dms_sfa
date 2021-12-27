import 'dart:async';

import 'package:dms/model/secondary_tag_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

class BeatBottomSheet extends StatefulWidget {
  final String beat;
  final Function(SecondaryTag beat) onBeatSelect;
  final List<SecondaryTag> beats;

  const BeatBottomSheet({Key? key, required this.beat, required this.beats, required this.onBeatSelect}) : super(key: key);

  @override
  _BeatBottomSheetState createState() => _BeatBottomSheetState();
}

class _BeatBottomSheetState extends State<BeatBottomSheet> {
  TextEditingController edtSearch = TextEditingController();

  List<SecondaryTag> beats = [];

  StreamController<bool> editController = StreamController();
  StreamController<List<SecondaryTag>> controller = StreamController();

  @override
  void initState() {
    getBeats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
      child: IntrinsicHeight(
          child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: Column(
          // shrinkWrap: false,
          children: <Widget>[
            TextFormField(
              controller: edtSearch,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "SEARCH",
                  hintStyle: const TextStyle(
                    color: MColor.backButton,
                  ),
                  suffixIcon: StreamBuilder<bool>(
                    stream: editController.stream,
                    initialData: false,
                    builder: (context, snap) {
                      bool editing = false;

                      if (snap.hasData) {
                        editing = snap.data!;
                      }
                      return editing
                          ? IconButton(
                              onPressed: () {
                                edtSearch.clear();
                                controller.add(beats);
                                FocusScope.of(context).unfocus();
                                editController.add(false);
                              },
                              icon: const Icon(Icons.clear),
                            )
                          : Container(
                              width: 0,
                            );
                    },
                  )),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  List<SecondaryTag> searchList = [];

                  for (var element in beats) {
                    if (element.name.toLowerCase().contains(text.trim().toLowerCase())) {
                      searchList.add(element);
                    }
                  }

                  controller.add(searchList);
                  editController.add(true);
                } else {
                  controller.add(beats);
                  editController.add(false);
                }
              },
            ),
            SizedBox(
              width: width - 30,
              height: width * 0.6,
              // constraints: BoxConstraints(maxHeight: width, minHeight: 100),
              child: StreamBuilder<List<SecondaryTag>>(
                stream: controller.stream,
                initialData: widget.beats,
                builder: (context, snapshpt) {
                  debugPrint("snapshet data-->${snapshpt.data}");

                  if (snapshpt.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshpt.hasError) {
                    return const Text("data not found!");
                  }

                  if (snapshpt.data!.isEmpty) {
                    return const Text("data not found!");
                  }

                  if (snapshpt.hasData) {
                    return ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                              onTap: () {
                                widget.onBeatSelect(snapshpt.data![index]);
                                Navigator.pop(context);
                              },
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              leading: Text(snapshpt.data![index].name.toString().toUpperCase()),
                              trailing: snapshpt.data![index].toString() == widget.beat.toString()
                                  ? const Icon(Icons.check)
                                  : const SizedBox(
                                      width: 0,
                                      height: 0,
                                    ),
                            ),
                        separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                        itemCount: snapshpt.data!.length);
                  }

                  return const Text(
                    "data not found!",
                    style: TextStyle(
                      color: MColor.backButton,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                height: 50,
                minWidth: width,
                elevation: 5,
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void getBeats() async {
    // print(widget.beats);
    beats = widget.beats;
    // print(beats);
    controller.add(beats);
  }
}
