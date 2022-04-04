import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:flutter/material.dart';

class DropDownField extends StatefulWidget {
  final Function(String value) onSelect;
  final String? hint;
  final List<String> menuList;
  final String prevSelected;
  List<BeatsModal>? beats;
  Function(BeatsModal? value)? onBeatSelected;

  DropDownField({
    Key? key,
    required this.onSelect,
    this.hint = "Select",
    required this.menuList,
    required this.prevSelected,
    this.beats,
    this.onBeatSelected,
  }) : super(key: key);

  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  String selected = "";

  @override
  void initState() {
    selected = widget.prevSelected.isEmpty ? widget.hint! : widget.prevSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return List.generate(
          widget.beats == null ? widget.menuList.length : widget.beats!.length,
          (index) {
            return widget.beats == null
                ? PopupMenuItem(
                    value: widget.menuList[index],
                    child: ListTile(
                      title: Text(widget.menuList[index]),
                    ),
                  )
                : PopupMenuItem(
                    value: widget.beats![index].name,
                    child: ListTile(
                      title: Text(widget.beats![index].name),
                    ),
                  );
          },
        );
      },
      initialValue: selected,
      onSelected: (item) {
        debugPrint("item---->$item");
        selected = item.toString();
        widget.onSelect(item.toString());
        if (widget.beats != null) {
          for (BeatsModal modal in widget.beats!) {
            if (selected == modal.name) {
              widget.onBeatSelected!(modal);
            }
          }
        }
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(25),
        ),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selected),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
