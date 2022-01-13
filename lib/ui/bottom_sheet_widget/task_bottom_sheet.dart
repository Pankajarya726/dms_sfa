import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:intl/intl.dart';

class TaskBottomSheet extends StatefulWidget {
  const TaskBottomSheet({Key? key}) : super(key: key);

  @override
  _TaskBottomSheetState createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  List<Widget> items = [];

  @override
  void initState() {
    // items.add(const BottomSheetHeading("Task"));
    getItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetHeading("Task"),
            Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return items[index];
                  }),
            ),
            Center(
              child: DoneButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void getItem() async {
    for (int i = 0; i < 3; i++) {
      items.add(const TaskItem());
    }

    items.add(
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextFormField(
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({Key? key}) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color(0xffC5C5C5)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("1548c8ef456895"),
              Checkbox(
                  value: check,
                  onChanged: (value) {
                    check = value!;
                    setState(() {});
                  })
            ],
          ),
          const Text("Partial delivery failure"),
          const SizedBox(
            height: 5,
          ),
          Tags(
            itemCount: 3,
            alignment: WrapAlignment.start,
            spacing: 10,
            runSpacing: 8,
            itemBuilder: (index) {
              return ItemTags(
                index: index,
                title: "Yellow Diamond",
                pressEnabled: false,
                color: const Color(0xffE7E7E7),
                textColor: MColor.textColor,
              );
            },
          ),
          const SizedBox(
            height: 5,
          ),
          const Text("Lorem Ipsum is simply dummy text of the printing and typesetting. "),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(DateFormat("dd-MM-yyyy").format(DateTime.now())),
          )
        ],
      ),
    );
  }
}
