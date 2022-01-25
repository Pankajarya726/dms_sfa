import 'package:flutter/material.dart';

class DropDownField extends StatefulWidget {
  final Function(String value) onSelect;
  final String? hint;

  const DropDownField({Key? key, required this.onSelect, this.hint = "Select"}) : super(key: key);

  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  String selected = "";
  @override
  void initState() {
    selected = widget.hint ?? "Select";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: "Day1",
            child: ListTile(
              title: Text("Day1"),
            ),
          ),
          const PopupMenuItem(
            child: ListTile(
              title: Text("Day2"),
            ),
            value: "Day2",
          ),
        ];
      },
      initialValue: selected,
      onSelected: (item) {
        debugPrint("item---->$item");

        selected = item.toString();
        widget.onSelect(item.toString());
        setState(() {});
      },
      child: Container(
          decoration: BoxDecoration(color: const Color(0xffF2F2F2), borderRadius: BorderRadius.circular(25)),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(selected), const Icon(Icons.keyboard_arrow_down)],
          )),
    );
  }
}
