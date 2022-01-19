import 'dart:async';

import 'package:dms/model/get_all_tag_response.dart';
import 'package:dms/ui/custom_widget/secondary_tag_widget.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class PrimaryTagWidget extends StatefulWidget {
  final PrimaryTag? tag;
  final List<PrimaryTag> primaryTags;
  final Function(PrimaryTag primaryTag) onSelect;

  const PrimaryTagWidget({
    Key? key,
    required this.onSelect,
    required this.primaryTags,
    this.tag,
  }) : super(key: key);

  @override
  _PrimaryTagWidgetState createState() => _PrimaryTagWidgetState();
}

class _PrimaryTagWidgetState extends State<PrimaryTagWidget> {
  PrimaryTag? selectedTag;
  StreamController<List<SecondaryTag>> streamController = StreamController();

  @override
  void initState() {
    debugPrint("PrimaryTagWidget--->");
    selectedTag = widget.tag ?? widget.primaryTags.first;
    getPrimaryTag();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Primary Tag",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.67,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Tags(
          itemCount: widget.primaryTags.length,
          alignment: WrapAlignment.start,
          itemBuilder: (index) {
            return ItemTags(
              customData: widget.primaryTags[index],
              singleItem: true,
              onPressed: (item) {
                selectedTag = item.customData;

                streamController.add(selectedTag!.secondaryTag);
              },
              active: selectedTag!.primaryId == widget.primaryTags[index].primaryId,
              title: widget.primaryTags[index].primaryName,
              textActiveColor: Colors.black,
              textColor: const Color(0xff555555),
              elevation: 0,
              textStyle: const TextStyle(fontSize: 16),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              index: index,
              activeColor: const Color(0xffFFC9CC),
              color: const Color(0xffFAFAFA),
              border: Border.all(
                  color: selectedTag!.primaryId == widget.primaryTags[index].primaryId
                      ? MColor.colorPrimary
                      : const Color.fromRGBO(197, 197, 197, 1)),
            );
          },
        ),
        // PrimaryWidget(
        //   onSelect: (PrimaryTag tag) {
        //     selectedTag = tag;
        //     streamController.add([]);
        //     streamController.add(tag.secondaryTag);
        //   },
        //   tags: widget.primaryTags,
        //   selected: selectedTag!,
        // ),

        /* Tags(
          itemCount: widget.primaryTags.length,
          alignment: WrapAlignment.start,
          itemBuilder: (index) {
            return ItemTags(
              customData: widget.primaryTags[index],
              singleItem: true,
              onPressed: (item) {
                selectedTag = item.customData;
                streamController.add(item.customData);
                setState(() {});
              },
              active: selectedTag!.primaryId == widget.primaryTags[index].primaryId,
              title: widget.primaryTags[index].primaryName,
              textActiveColor: Colors.black,
              textColor: const Color(0xff555555),
              elevation: 0,
              textStyle: const TextStyle(fontSize: 16),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              index: index,
              border: Border.all(
                  color: selectedTag!.primaryId == widget.primaryTags[index].primaryId
                      ? MColor.colorPrimary
                      : const Color.fromRGBO(197, 197, 197, 1)),
              activeColor:
                  selectedTag!.primaryId == widget.primaryTags[index].primaryId ? const Color(0xFFFFC9CC) : const Color(0xffFAFAFA),
              color: selectedTag!.primaryId == widget.primaryTags[index].primaryId ? const Color(0xFFFFC9CC) : const Color(0xffFAFAFA),
            );
          },
        ),*/
        const SizedBox(
          height: 15,
        ),
        StreamBuilder<List<SecondaryTag>>(
            stream: streamController.stream,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<SecondaryTag> tag = snapshot.data!;
                debugPrint("tag-->$tag");

                if (snapshot.data!.isEmpty) {
                  return Container();
                }
                debugPrint("tag1-->$tag");
                debugPrint("secondaryTag-->${tag}");
                return SecondaryTagWidget(
                  onSelect: (List<SecondaryTag> selected) {},
                  secondaryTagList: tag,
                  uiType: selectedTag == null ? "1" : selectedTag!.primaryId.toString(),
                );
              }
              return Container();
            })
      ],
    );
  }

  Future<List<PrimaryTag>> getPrimaryTag() async {
    if (await Network.isConnected()) {
      // GetAllTagResponse response = await repository.getAllTags();

      return widget.primaryTags;
    } else {
      Utility.showToast(Constants.internetAlert);
      return [];
    }
  }
}

class PrimaryWidget extends StatefulWidget {
  final List<PrimaryTag> tags;
  final PrimaryTag selected;
  final Function(PrimaryTag tag) onSelect;

  const PrimaryWidget({Key? key, required this.tags, required this.selected, required this.onSelect}) : super(key: key);

  @override
  _PrimaryWidgetState createState() => _PrimaryWidgetState();
}

class _PrimaryWidgetState extends State<PrimaryWidget> {
  late PrimaryTag selectedItem;

  @override
  void initState() {
    selectedItem = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Tags(
      itemCount: widget.tags.length,
      alignment: WrapAlignment.start,
      itemBuilder: (index) {
        return ItemTags(
          customData: widget.tags[index],
          singleItem: true,
          onPressed: (item) {
            selectedItem = item.customData;
            widget.onSelect(selectedItem);
            setState(() {});
          },
          active: selectedItem.primaryId == widget.tags[index].primaryId,
          title: widget.tags[index].primaryName,
          textActiveColor: Colors.black,
          textColor: const Color(0xff555555),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          index: index,
          activeColor: const Color(0xffFFC9CC),
          color: const Color(0xffFAFAFA),
          border: Border.all(
              color: selectedItem.primaryId == widget.tags[index].primaryId
                  ? MColor.colorPrimary
                  : const Color.fromRGBO(197, 197, 197, 1)),
        );
      },
    );
  }
}
