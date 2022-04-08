import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class EscalatedBottomSheet extends StatefulWidget {
  const EscalatedBottomSheet({Key? key}) : super(key: key);

  @override
  _EscalatedBottomSheetState createState() => _EscalatedBottomSheetState();
}

class _EscalatedBottomSheetState extends State<EscalatedBottomSheet> {
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
        minHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      shape: const RoundedRectangleBorder(),
                      child: const Text(
                        StringConst.escalateCaps,
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 20,
                          letterSpacing: 0.72,
                        ),
                      ),
                      color: const Color(0XFF3D8FFF),
                      height: 50,
                      elevation: 0,
                      minWidth: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: MaterialButton(
                      shape: const RoundedRectangleBorder(),
                      onPressed: () {},
                      child: const Text(
                        StringConst.doneCaps,
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 20,
                          letterSpacing: 0.72,
                        ),
                      ),
                      color: MColor.colorSecondary,
                      height: 50,
                      elevation: 0,
                      minWidth: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
