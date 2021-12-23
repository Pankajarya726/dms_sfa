import 'package:dms/main.dart';
import 'package:dms/model/primary_tag_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PrimaryTagWidget extends StatefulWidget {
  final Function(PrimaryTag primaryTag) onSelect;
  final Function(PrimaryTagListener primaryTagListener) onInit;

  const PrimaryTagWidget({
    Key? key,
    required this.onSelect,
    required this.onInit,
  }) : super(key: key);

  @override
  _PrimaryTagWidgetState createState() => _PrimaryTagWidgetState();
}

class _PrimaryTagWidgetState extends State<PrimaryTagWidget> implements PrimaryTagListener {
  List<PrimaryTag> primaryTags = [];
  PrimaryTag? selectedTag;

  @override
  void initState() {
    print("PrimaryTagWidget--->");
    widget.onInit(this);
    getPrimaryTag();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return primaryTags.isEmpty || selectedTag == null
        ? const SizedBox(
            width: 0,
            height: 0,
          )
        : Tags(
            itemCount: primaryTags.length,
            alignment: WrapAlignment.start,
            itemBuilder: (index) {
              debugPrint("selectedTag->${selectedTag.toString()}");
              debugPrint("primaryTags->${primaryTags[index].toString()}");
              print(selectedTag!.id == primaryTags[index].id);
              return ItemTags(
                customData: primaryTags[index],
                singleItem: true,
                onPressed: (item) {
                  selectedTag = item.customData;
                  widget.onSelect(selectedTag!);
                  setState(() {});
                },
                active: selectedTag!.id == primaryTags[index].id,
                title: primaryTags[index].name,
                textActiveColor: Colors.black,
                textColor: const Color(0xff555555),
                elevation: 0,
                textStyle: const TextStyle(fontSize: 16),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                index: index,
                border: Border.all(
                    color: selectedTag!.id == primaryTags[index].id ? MColor.colorPrimary : const Color.fromRGBO(197, 197, 197, 1)),
                activeColor: const Color(0xFFFFC9CC),
                color: selectedTag!.id == primaryTags[index].id ? const Color(0xFFFFC9CC) : const Color(0xffFAFAFA),
              );
            },
          );
  }

  void getPrimaryTag() async {
    if (await Network.isConnected()) {
      PrimaryTagResponse response = await repository.getPrimaryTag();

      if (response.success) {
        primaryTags = response.data;

        selectedTag = primaryTags[0];
        widget.onSelect(selectedTag!);
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    } else {
      Fluttertoast.showToast(msg: Constants.internetAlert);
    }
  }

  @override
  void onPrimaryTagSelect(PrimaryTag primaryTag) {
    selectedTag = primaryTag;

    debugPrint("onPrimaryTagSelect->$selectedTag");
  }
}

abstract class PrimaryTagListener {
  void onPrimaryTagSelect(PrimaryTag primaryTag);
}
