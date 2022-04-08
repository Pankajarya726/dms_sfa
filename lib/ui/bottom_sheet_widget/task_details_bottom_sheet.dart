import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class TaskDetailsBottomSheet extends StatefulWidget {
  const TaskDetailsBottomSheet({Key? key}) : super(key: key);

  @override
  _TaskDetailsBottomSheetState createState() => _TaskDetailsBottomSheetState();
}

class _TaskDetailsBottomSheetState extends State<TaskDetailsBottomSheet> {
  List<String> beatNames = [
    "Yellow diamond",
    "Tiny tush",
  ];
  TextEditingController txtRemarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  StringConst.taskDetails,
                  style: TextStyle(
                    fontSize: 19,
                    color: MColor.colorPrimary,
                    letterSpacing: 0.67,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Flexible(
                      flex: 4,
                      child: Text(
                        "7a639147rt9835",
                        style: TextStyle(
                          color: Color(0xff555555),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        "10-03-2022",
                        style: TextStyle(
                          color: Color(0xff777777),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Full delivery failure",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff272727),
                    letterSpacing: 0.67,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Tags(
                  direction: Axis.horizontal,
                  itemCount: beatNames.length,
                  horizontalScroll: false,
                  alignment: WrapAlignment.start,
                  spacing: 10,
                  itemBuilder: (index) {
                    return ItemTags(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      pressEnabled: false,
                      index: index,
                      textActiveColor: Colors.black,
                      textColor: const Color(0xff555555),
                      elevation: 0,
                      activeColor: const Color(0xffE7E7E7),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 0.67,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      border: Border.all(
                        color: const Color(0xffE7E7E7),
                      ),
                      color: const Color(0xffE7E7E7),
                      title: beatNames[index],
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  StringConst.remark,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff272727),
                    letterSpacing: 0.67,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  StringConst.loremIpsum,
                  style: TextStyle(
                    color: Color(0xff555555),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  StringConst.escalatedRemark,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff272727),
                    letterSpacing: 0.67,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  StringConst.loremIpsum,
                  style: TextStyle(
                    color: Color(0xff555555),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  text: const TextSpan(
                    text: StringConst.taskElapseDays,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff272727),
                      letterSpacing: 0.67,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "25",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MColor.colorPrimary,
                          letterSpacing: 0.67,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  controller: txtRemarkController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: StringConst.enterComments,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(160, 50)),
                      backgroundColor:
                          MaterialStateProperty.all(MColor.colorPrimary),
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
        ),
      ),
    );
  }
}
