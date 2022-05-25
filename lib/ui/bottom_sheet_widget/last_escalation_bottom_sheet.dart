import 'package:dms/ui/task/task/model/get_retailers_task_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class LastEscalationBottomSheet extends StatefulWidget {
  final LastEscalation? lastEscalation;
  const LastEscalationBottomSheet({
    Key? key,
    required this.lastEscalation,
  }) : super(key: key);

  @override
  _LastEscalationBottomSheetState createState() =>
      _LastEscalationBottomSheetState();
}

class _LastEscalationBottomSheetState extends State<LastEscalationBottomSheet> {
  LastEscalation? lastEscalation;
  @override
  void initState() {
    if (widget.lastEscalation != null) {
      lastEscalation = widget.lastEscalation!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
        minHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: lastEscalation != null
            ? SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      StringConst.lastEscalation,
                      style: TextStyle(
                        fontSize: 19,
                        color: MColor.colorPrimary,
                        letterSpacing: 0.67,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        lastEscalation!.reassignDate,
                        style: const TextStyle(
                          color: Color(0xff777777),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      lastEscalation!.escalationTag,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff272727),
                        letterSpacing: 0.67,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Tags(
                      direction: Axis.horizontal,
                      itemCount: lastEscalation!.bus.length,
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
                          title: lastEscalation!.bus[index].buName,
                        );
                      },
                    ),
                    lastEscalation!.reassignRemark.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
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
                                height: 10,
                              ),
                              Text(
                                lastEscalation!.reassignRemark,
                                style: const TextStyle(
                                  color: Color(0xff555555),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        color: const Color(0xffB7B7B7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                        child: const Text(
                          StringConst.close,
                          style: TextStyle(
                            letterSpacing: 0.67,
                            color: Colors.white,
                            fontSize: 20,
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
              )
            : const IntrinsicHeight(
                child: Center(
                  child: Text("Data not found"),
                ),
              ),
      ),
    );
  }
}
