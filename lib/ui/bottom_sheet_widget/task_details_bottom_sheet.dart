import 'dart:collection';

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

class TaskDetailsBottomSheet extends StatefulWidget {
  final PendingTaskModal pendingTaskModal;
  final String elapseDays;
  final String retailerId;
  final Function() onTaskResolve;
  const TaskDetailsBottomSheet({
    Key? key,
    required this.pendingTaskModal,
    required this.elapseDays,
    required this.retailerId,
    required this.onTaskResolve,
  }) : super(key: key);

  @override
  _TaskDetailsBottomSheetState createState() => _TaskDetailsBottomSheetState();
}

class _TaskDetailsBottomSheetState extends State<TaskDetailsBottomSheet> {
  TextEditingController txtRemarkController = TextEditingController();
  PendingTaskModal pendingTaskModal = PendingTaskModal(
      id: "",
      taskCode: "",
      taskDate: "",
      taskType: "",
      escalationTag: [],
      escalationRemark: "",
      taskRemark: "",
      escalationTo: [],
      buId: [],
      action: '0');
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
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
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
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      pendingTaskModal.escalationTag.isNotEmpty
                          ? Text(
                              pendingTaskModal.escalationTag.first.tagName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff272727),
                                letterSpacing: 0.67,
                                fontSize: 16,
                              ),
                            )
                          : Container(),
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
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
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
                      pendingTaskModal.taskRemark.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                              ],
                            )
                          : Container(),
                      pendingTaskModal.escalationRemark.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                Text(
                                  pendingTaskModal.escalationRemark,
                                  style: const TextStyle(
                                    color: Color(0xff555555),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            )
                          : Container(),
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
                        maxLength: 300,
                        controller: txtRemarkController,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
              ),
              const SizedBox(
                height: 25,
              ),
              BlocProvider(
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
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Map<String, dynamic> input = HashMap<String, dynamic>();
                        input["status"] = "2";
                        input["task_id"] = pendingTaskModal.id;
                        input["retailer_id"] = widget.retailerId;
                        input["escalate_user_id"] = "";
                        input["remark"] = txtRemarkController.text;
                        input["elapse_days"] = widget.elapseDays;
                        taskDetailsBloc.add(EscalateTaskEvent(input: input));
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(160, 50)),
                        backgroundColor: MaterialStateProperty.all(MColor.colorPrimary),
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
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
