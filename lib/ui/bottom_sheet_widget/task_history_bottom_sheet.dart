import 'dart:async';
import 'package:dms/ui/task/task/model/get_retailers_task_response.dart';
import 'package:dms/ui/task/task_history/task_history.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class TaskHistoryBottomSheet extends StatefulWidget {
  final RetailersTaskModal? modal;
  const TaskHistoryBottomSheet({
    Key? key,
    required this.modal,
  }) : super(key: key);

  @override
  _TaskHistoryBottomSheetState createState() => _TaskHistoryBottomSheetState();
}

class _TaskHistoryBottomSheetState extends State<TaskHistoryBottomSheet> {
  StreamController<List<TaskWiseRetailersTaskModal>> taskStreamController =
      StreamController();
  List<TaskWiseRetailersTaskModal> taskHistory = [];
  int totalTask = 0;

  @override
  void initState() {
    if (widget.modal != null) {
      taskHistory.addAll(widget.modal!.taskWiseData);
      taskStreamController.add(taskHistory);
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
      child: StreamBuilder<List<TaskWiseRetailersTaskModal>>(
          stream: taskStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const IntrinsicHeight(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (taskHistory.isEmpty) {
              return const IntrinsicHeight(
                child: Center(
                  child: Text(StringConst.dataNotFound),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                  child: Text(
                    StringConst.taskHistory,
                    style: TextStyle(
                      color: MColor.colorPrimary,
                      fontSize: 20,
                      letterSpacing: 0.67,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            taskHistory.length,
                            (index) {
                              totalTask = totalTask +
                                  int.parse(taskHistory[index].taskNumber);
                              return TaskHistoryWidget(
                                modal: taskHistory[index],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 20),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: MColor.colorYellow,
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  MColor.colorYellow,
                                  MColor.colorYellow.withOpacity(0.67),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  StringConst.totalTask,
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.67,
                                  ),
                                ),
                                Text("$totalTask"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          StringConst.closeCaps,
                          style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 20,
                            letterSpacing: 0.72,
                          ),
                        ),
                        color: const Color(0XFFB7B7B7),
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskHistory(
                                        retailerId: widget.modal!.retailerId,
                                        beatId: widget.modal!.beatId,
                                      )));
                        },
                        child: const Text(
                          StringConst.viewCaps,
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
            );
          }),
    );
  }
}

class TaskHistoryWidget extends StatelessWidget {
  final TaskWiseRetailersTaskModal modal;
  const TaskHistoryWidget({Key? key, required this.modal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffC5C5C5), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Image(
            image: AssetImage("assets/hit.png"),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              modal.escalationTag,
              maxLines: 5,
              style: const TextStyle(
                color: MColor.textColor,
                fontSize: 14,
                letterSpacing: 0.67,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 25,
            height: 25,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: MColor.colorYellow,
            ),
            child: Text(
              modal.taskNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          )
        ],
      ),
    );
  }
}
