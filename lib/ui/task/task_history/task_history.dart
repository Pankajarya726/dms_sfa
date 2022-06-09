import 'dart:collection';
import 'package:dms/ui/task/task_history/bloc/task_history_bloc.dart';
import 'package:dms/ui/task/task_history/bloc/task_history_events.dart';
import 'package:dms/ui/task/task_history/bloc/task_history_states.dart';
import 'package:dms/ui/task/task_history/model/task_history_respone.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskHistory extends StatefulWidget {
  final String retailerId;
  final String beatId;
  const TaskHistory({
    Key? key,
    required this.retailerId,
    required this.beatId,
  }) : super(key: key);

  @override
  State<TaskHistory> createState() => _TaskHistoryState();
}

class _TaskHistoryState extends State<TaskHistory> {
  List<TaskHistoryModal> taskHistoryList = [];
  DateTime? currentDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: MColor.backButton,
          ),
        ),
        elevation: 3,
        shadowColor: Colors.black26,
        title: const Text(StringConst.taskHistory),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: MColor.backButton,
        ),
      ),
      body: BlocProvider(
        create: (context) => TaskHistoryBloc(),
        child: BlocBuilder<TaskHistoryBloc, TaskHistoryStates>(
          builder: (context, state) {
            if (state is TaskHistoryInitialState) {
              Map<String, dynamic> input = HashMap<String, dynamic>();
              input["retailer_id"] = widget.retailerId;
              input["beat_id"] = widget.beatId;
              BlocProvider.of<TaskHistoryBloc>(context)
                  .add(GetTaskHistoryEvent(input: input));
            }
            if (state is TaskHistoryLodingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetTaskHistoryState) {
              currentDate = state.currentDate;
              taskHistoryList = state.taskHistory;
            }
            if (state is TaskHistoryFailureState) {
              return Center(
                child: Text(state.failureMessage),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              itemCount: taskHistoryList.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 20,
                );
              },
              itemBuilder: (context, index) {
                int days = 1;
                String daysPending = "";
                if (taskHistoryList[index].isResolve == "0") {
                  if (taskHistoryList[index].taskDate.isNotEmpty) {
                    DateTime enrolledDate =
                        DateTime.parse(taskHistoryList[index].taskDate);
                    days = days + currentDate!.difference(enrolledDate).inDays;
                    if (days < 2) {
                      daysPending = days.toString() + " day pending";
                    } else {
                      daysPending = days.toString() + " days pending";
                    }
                  }
                } else {
                  if (taskHistoryList[index].resolveDate.isNotEmpty) {
                    DateTime enrolledDate =
                        DateTime.parse(taskHistoryList[index].resolveDate);
                    days = currentDate!.difference(enrolledDate).inDays;
                    if (days < 2) {
                      daysPending = days.toString() + " day pending";
                    } else {
                      daysPending = days.toString() + " days pending";
                    }
                  }
                }

                taskHistoryList[index].daysPending = daysPending;
                return TaskHistoryItems(
                  index: index,
                  taskHistoryModal: taskHistoryList[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class TaskHistoryItems extends StatefulWidget {
  final int index;
  final TaskHistoryModal taskHistoryModal;
  const TaskHistoryItems({
    Key? key,
    required this.index,
    required this.taskHistoryModal,
  }) : super(key: key);

  @override
  State<TaskHistoryItems> createState() => _TaskHistoryItemsState();
}

class _TaskHistoryItemsState extends State<TaskHistoryItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: widget.taskHistoryModal.taskType == "HIT"
            ? const Color(0xffFD4848)
            : widget.taskHistoryModal.taskType == "KEY"
                ? const Color(0xff54C0EB)
                : widget.taskHistoryModal.taskType == "ST"
                    ? const Color(0xffF19028)
                    : const Color(0xff3369BA),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          )
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    child: Text(
                      widget.taskHistoryModal.taskUniuqeId,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff555555),
                        letterSpacing: 0.67,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Text(
                      widget.taskHistoryModal.taskDate,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff777777),
                        letterSpacing: 0.67,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.taskHistoryModal.escalationTag,
                      maxLines: 3,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff272727),
                        letterSpacing: 0.67,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Image(
                    image: AssetImage(
                      widget.taskHistoryModal.taskType == "HIT"
                          ? "assets/hit.png"
                          : widget.taskHistoryModal.taskType == "ST"
                              ? "assets/special.png"
                              : widget.taskHistoryModal.taskType == "KT"
                                  ? "assets/key.png"
                                  : "assets/blue_dash.png",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Image(
                      image: AssetImage(
                        "assets/time.png",
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Text(
                      widget.taskHistoryModal.daysPending,
                      style: const TextStyle(
                        color: Color(0xff555555),
                        letterSpacing: 0.67,
                        fontSize: 13,
                        overflow: TextOverflow.ellipsis,
                      ),
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
