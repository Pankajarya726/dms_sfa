import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class TagWidget extends StatefulWidget {
  final List<dynamic> items;

  const TagWidget({Key? key, required this.items}) : super(key: key);

  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  dynamic selectedItem;
  @override
  Widget build(BuildContext context) {
    return Tags(
      itemCount: widget.items.length,
      runSpacing: 8,
      spacing: 10,
      alignment: WrapAlignment.start,
      itemBuilder: (index) {
        return ItemTags(
          index: index,
          title: widget.items[index].toString(),
          textColor: MColor.textColor,
          active: selectedItem == widget.items[index],
          textActiveColor: MColor.textColor,
          onPressed: (item) {
            selectedItem = item.customData;
            setState(() {});
          },
          singleItem: true,
          customData: widget.items[index],
          activeColor: const Color(0xffFFC9CC),
          border: Border.all(color: selectedItem == widget.items[index] ? const Color(0xffF24B55) : const Color(0xffC5C5C5), width: 1),
          color: const Color(0xffFAFAFA),
        );
      },
    );
  }
}
