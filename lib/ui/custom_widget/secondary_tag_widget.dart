import 'package:dms/model/get_all_tag_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

import 'beat_bottom_sheet.dart';

class SecondaryTagWidget extends StatefulWidget {
  final Function(List<SecondaryTag> secondaryTag)? onSelect;
  final List<SecondaryTag>? secondaryTagList;
  final String uiType;

  const SecondaryTagWidget({Key? key, this.onSelect, this.secondaryTagList, this.uiType = "1"}) : super(key: key);

  @override
  _SecondaryTagWidgetState createState() => _SecondaryTagWidgetState();
}

class _SecondaryTagWidgetState extends State<SecondaryTagWidget> {
  List<SecondaryTag> secondaryTagList = [];
  SecondaryTag? selectedSecondaryTag;
  TextEditingController txtBeatController = TextEditingController();

  @override
  void initState() {
    debugPrint("SecondaryTagWidget--->");
    debugPrint("widget.secondaryTagList--->${widget.secondaryTagList}");
    secondaryTagList = widget.secondaryTagList!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            StringConst.secondaryTag,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.67,
            ),
          ),
        ),
        widget.uiType == "1"
            ? TextFormField(
                scrollPadding: const EdgeInsets.all(0),
                readOnly: true,
                controller: txtBeatController,
                onTap: () {
                  selectBeat(context, secondaryTagList);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  hintText: "Select Retailing",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.black,
                  ),
                  // suffixIconConstraints: BoxConstraints(maxWidth: 20, maxHeight: 20)
                ),
              )
            : widget.uiType == "2"
                ? Tags(
                    itemCount: secondaryTagList.length,
                    alignment: WrapAlignment.start,
                    itemBuilder: (index) {
                      return ItemTags(
                        singleItem: true,
                        customData: secondaryTagList[index],
                        onPressed: (item) {
                          selectedSecondaryTag = item.customData!;

                          setState(() {});
                        },
                        active: selectedSecondaryTag != null
                            ? selectedSecondaryTag!.id == secondaryTagList[index].id
                                ? true
                                : false
                            : false,
                        title: secondaryTagList[index].name,
                        textActiveColor: Colors.black,
                        textColor: const Color(0xff555555),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 16),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        index: index,
                        border: Border.all(
                            color: selectedSecondaryTag != null
                                ? selectedSecondaryTag!.id == secondaryTagList[index].id
                                    ? MColor.colorPrimary
                                    : const Color.fromRGBO(197, 197, 197, 1)
                                : const Color.fromRGBO(197, 197, 197, 1)),
                        activeColor: const Color(0xFFFFC9CC),
                        color: selectedSecondaryTag != null
                            ? selectedSecondaryTag!.id == secondaryTagList[index].id
                                ? const Color(0xFFFFC9CC)
                                : const Color(0xffFAFAFA)
                            : const Color(0xffFAFAFA),
                      );
                    },
                  )
                : Container(),
      ],
    );
  }

  void selectBeat(BuildContext context, List<SecondaryTag> secondaryTag) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (context) {
          return BeatBottomSheet(
              selectedBeat: const [],
              beats: secondaryTag,
              onBeatSelect: (List<SecondaryTag> beat) {
                widget.onSelect!(beat);
              });
        });
  }
}

abstract class SecondaryTagListener {
  void onSecondaryTagSelect(SecondaryTag secondaryTag);

  void onPrimaryTagChange(PrimaryTag primaryTag, SecondaryTag? secondaryTag);
}
