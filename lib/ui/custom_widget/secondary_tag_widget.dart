import 'package:dms/model/primary_tag_response.dart';
import 'package:dms/model/secondary_tag_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';
import 'beat_bootom_sheet.dart';

class SecondaryTagWidget extends StatefulWidget {
  final SecondaryTag? secondaryTag;
  final PrimaryTag primaryTag;
  final Function(SecondaryTag secondaryTag) onSelect;
  final List<SecondaryTag> secondaryTagList;

  SecondaryTagWidget({Key? key, required this.primaryTag, this.secondaryTag, required this.onSelect, required this.secondaryTagList})
      : super(key: key);

  @override
  _SecondaryTagWidgetState createState() => _SecondaryTagWidgetState();
}

class _SecondaryTagWidgetState extends State<SecondaryTagWidget> implements SecondaryTagListener {
  List<SecondaryTag> secondaryTagList = [];
  SecondaryTag? selectedSecondaryTag;
  PrimaryTag? primaryTag;
  TextEditingController txtBeatController = TextEditingController();

  @override
  void initState() {
    print("SecondaryTagWidget--->");

    selectedSecondaryTag = widget.secondaryTag;
    secondaryTagList = widget.secondaryTagList;
    primaryTag = widget.primaryTag;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return primaryTag != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              primaryTag!.id == 1 || primaryTag!.id == 2
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        secondaryTag,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              primaryTag!.id == 1
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
                  : primaryTag!.id == 2
                      ? Tags(
                          itemCount: secondaryTagList.length,
                          alignment: WrapAlignment.start,
                          itemBuilder: (index) {
                            return ItemTags(
                              singleItem: true,
                              customData: secondaryTagList[index],
                              onPressed: (item) {
                                selectedSecondaryTag = item.customData!;
                                widget.onSelect(selectedSecondaryTag!);
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
          )
        : Container();
  }

  void getSecondaryTag() async {
    if (await Network.isConnected()) {
      SecondaryTagResponse response = await repository.getSecondaryTag(primaryTag!.id.toString());

      if (response.success) {
        if (primaryTag!.id == 1) {
          secondaryTagList = response.data!.location!;
        } else if (primaryTag!.id == 2) {
          secondaryTagList = response.data!.jointWorker!;
        }

        if (mounted) {
          setState(() {});
        }
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    } else {
      Fluttertoast.showToast(msg: Constants.internetAlert);
    }
  }

  void selectBeat(BuildContext context, List<SecondaryTag> secondaryTag) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (context) {
          return BeatBottomSheet(
              beat: txtBeatController.text,
              beats: secondaryTag,
              onBeatSelect: (SecondaryTag beat) {
                txtBeatController.text = beat.name;
                selectedSecondaryTag = beat;
                widget.onSelect(selectedSecondaryTag!);
              });
        });
  }

  @override
  void onPrimaryTagChange(PrimaryTag primaryTag, SecondaryTag? secondaryTag) {
    this.primaryTag = primaryTag;
    selectedSecondaryTag = secondaryTag;
    getSecondaryTag();
  }

  @override
  void onSecondaryTagSelect(SecondaryTag secondaryTag) {
    selectedSecondaryTag = secondaryTag;
    if (mounted) {
      setState(() {});
    }
  }
}

abstract class SecondaryTagListener {
  void onSecondaryTagSelect(SecondaryTag secondaryTag);

  void onPrimaryTagChange(PrimaryTag primaryTag, SecondaryTag? secondaryTag);
}
