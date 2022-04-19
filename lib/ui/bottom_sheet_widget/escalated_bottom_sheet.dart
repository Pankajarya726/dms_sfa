import 'dart:collection';

import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/escalate_to_bottom_sheet.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_bloc.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_events.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_states.dart';
import 'package:dms/ui/task/task_details/model/retailer_details_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class EscalatedBottomSheet extends StatefulWidget {
  final PendingTaskModal pendingTaskModal;
  final String elapseDays;
  final String retailerId;
  final Function() onTaskResolve;
  const EscalatedBottomSheet({
    Key? key,
    required this.pendingTaskModal,
    required this.elapseDays,
    required this.retailerId,
    required this.onTaskResolve,
  }) : super(key: key);

  @override
  _EscalatedBottomSheetState createState() => _EscalatedBottomSheetState();
}

class _EscalatedBottomSheetState extends State<EscalatedBottomSheet> {
  List<String> beatNames = [
    "Yellow diamond",
    "Tiny tush",
  ];
  TextEditingController txtRemarkController = TextEditingController();
  PendingTaskModal pendingTaskModal = PendingTaskModal(
      id: "",
      taskCode: "",
      taskDate: "",
      taskType: "",
      escalationTag: "",
      escalationRemark: "",
      taskRemark: "",
      elapseDays: "",
      escalationTo: [],
      buId: []);
  TaskDetailsBloc taskDetailsBloc = TaskDetailsBloc();

  @override
  void initState() {
    pendingTaskModal = widget.pendingTaskModal;
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
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
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
                        children: [
                          Flexible(
                            flex: 4,
                            child: Text(
                              pendingTaskModal.taskCode,
                              style: const TextStyle(
                                color: Color(0xff555555),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Text(
                              pendingTaskModal.taskDate,
                              style: const TextStyle(
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
                      Text(
                        pendingTaskModal.escalationTag,
                        style: const TextStyle(
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
                        itemCount: pendingTaskModal.buId.length,
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
                            title: pendingTaskModal.buId[index].buName,
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
                      Text(
                        pendingTaskModal.taskRemark,
                        style: const TextStyle(
                          color: Color(0xff555555),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      RichText(
                        text: TextSpan(
                          text: StringConst.taskElapseDays,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff272727),
                            letterSpacing: 0.67,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: widget.elapseDays,
                              style: const TextStyle(
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
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    onPressed: () {
                      Utility.hideKeyboard();
                      FocusScope.of(context).unfocus();
                      if (pendingTaskModal.escalationTo.length < 2) {
                        submitDialog(
                            context,
                            pendingTaskModal.escalationTo.first,
                            "Do you wish to escalate this task to ");
                      } else {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: bottomSheetShape,
                            builder: (context) => EscalateToBottomSheet(
                                  pendingTaskModal: pendingTaskModal,
                                  retailerId: widget.retailerId,
                                  elapseDays: widget.elapseDays,
                                  remark: txtRemarkController.text,
                                  onTaskEscalated: () {
                                    widget.onTaskResolve();
                                    Navigator.pop(context);
                                  },
                                ));
                      }
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
                    onPressed: () {
                      Utility.hideKeyboard();
                      FocusScope.of(context).unfocus();
                      submitDialog(context, EscalationTo(id: "", name: ""),
                              "Are you sure to submit?")
                          .then((value) {
                        Navigator.pop(context);
                      });
                    },
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
    );
  }

  submitDialog(context, EscalationTo escalationTo, titleText) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocProvider(
          create: (context) => taskDetailsBloc,
          child: BlocListener<TaskDetailsBloc, TaskDetailStates>(
            listener: (context, state) {
              if (state is EscalateTaskState) {
                Utility.showToast(state.responseMessage);
                widget.onTaskResolve();
                Navigator.pop(context);
              }
              if (state is EscalateTaskFailureState) {
                Utility.showToast(state.failureMessage);
              }
            },
            child: AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 15),
              titlePadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              buttonPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RichText(
                  text: TextSpan(
                    text: titleText,
                    style: const TextStyle(
                      color: Color(0xff272727),
                      letterSpacing: 0.67,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: escalationTo.name,
                        style: const TextStyle(
                          color: MColor.colorPrimary,
                          letterSpacing: 0.67,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    StringConst.no,
                    style: TextStyle(
                      color: Color(0xff555555),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text(
                    StringConst.yes,
                    style: TextStyle(
                      color: Color(0xfff4511e),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () async {
                    if (escalationTo.id.isEmpty) {
                      Map<String, dynamic> input = HashMap<String, dynamic>();
                      input["status"] = "2";
                      input["task_id"] = pendingTaskModal.id;
                      input["retailer_id"] = widget.retailerId;
                      input["escalate_user_id"] = "";
                      input["remark"] = txtRemarkController.text;
                      input["elapse_days"] = widget.elapseDays;
                      taskDetailsBloc.add(EscalateTaskEvent(input: input));
                    } else {
                      Map<String, dynamic> input = HashMap<String, dynamic>();
                      input["status"] = "1";
                      input["task_id"] = pendingTaskModal.id;
                      input["retailer_id"] = widget.retailerId;
                      input["escalate_user_id"] = escalationTo.id;
                      input["remark"] = txtRemarkController.text;
                      input["elapse_days"] = widget.elapseDays;
                      taskDetailsBloc.add(EscalateTaskEvent(input: input));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
