import 'dart:async';
import 'package:dms/main.dart';
import 'package:dms/model/base_response.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/task_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class TaskBottomSheet extends StatefulWidget {
  // final RetailerDetailsModal retailerDetails;
  final String retailerCode;
  final List<Task> taskList;
  const TaskBottomSheet({
    Key? key,
    required this.taskList,
    required this.retailerCode,
  }) : super(key: key);

  @override
  _TaskBottomSheetState createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  List<Widget> items = [];
  List<Task> taskList = [];
  TextEditingController tecRemark = TextEditingController();
  StreamController<List<Task>> taskStream = StreamController();

  @override
  void initState() {
    taskList.addAll(widget.taskList);
    debugPrint("widget.retailerDetails.uniqueCode--${widget.taskList.length}");
    // items.add(const BottomSheetHeading("Task"));
    // getTask();
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
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetHeading("Task"),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                        itemCount: taskList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return TaskItem(task: taskList[index]);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, bottom: 5, top: 5),
                      child: TextFormField(
                        controller: tecRemark,
                        minLines: 3,
                        maxLines: 5,
                        maxLength: 300,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: StringConst.remark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    resolveTask(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 40,
                  color: MColor.colorSecondary,
                  child: const Text(
                    StringConst.done,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 40,
                  color: MColor.colorPrimary,
                  child: const Text(
                    StringConst.cancel,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  void resolveTask(BuildContext context) async {
    if (await Network.isConnected()) {
      EasyLoading.show(status: "loading...");

      List<Task> task = taskList.where((element) => element.check).toList();
      String taskId = "";
      for (int i = 0; i < task.length; i++) {
        if (i == task.length - 1) {
          taskId += task[i].id.toString();
        } else {
          taskId += task[i].id.toString() + ",";
        }
      }

      Map<String, dynamic> input = {
        "task_id": taskId,
        "outlet_code": widget.retailerCode,
        "remark": tecRemark.text.trim()
      };

      BaseResponse response = await repository.resolveTask(input);
      EasyLoading.dismiss();
      if (response.success) {
        Utility.showToast(response.message);
        Navigator.pop(context, task.length);
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

// void getItem() async {
//   Future.forEach(taskList, (Task task) {
//     items.add(TaskItem(task: Task));
//   });
//   for (int i = 0; i < 3; i++) {
//     items.add(const TaskItem());
//   }
//
//   items.add(
//     Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: TextFormField(
//         minLines: 3,
//         maxLines: 5,
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
//         ),
//       ),
//     ),
//   );
// }

// void getTask() async {
//   if (await Network.isConnected()) {
//     Map<String, dynamic> input = {"outlet_code": widget.retailerDetails.uniqueCode};
//     TaskResponse response = await repository.getTaskByRetailer(input);
//     if (response.success) {
//       // getItem();
//       taskList.addAll(response.data);
//       taskStream.add(taskList);
//     } else {
//       taskStream.addError("No task created yet.");
//     }
//   } else {
//     Utility.showToast(Constants.internetAlert);
//   }
// }
}

class TaskItem extends StatefulWidget {
  final Task task;

  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Color(0xffC5C5C5)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.task.taskId),
              Checkbox(
                  value: widget.task.check,
                  onChanged: (value) {
                    widget.task.check = value!;
                    setState(() {});
                  })
            ],
          ),
          Text(
            widget.task.escalationTag,
            style: const TextStyle(color: Color(0xff555555), fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          Tags(
            itemCount: widget.task.bus.length,
            alignment: WrapAlignment.start,
            spacing: 10,
            runSpacing: 8,
            itemBuilder: (index) {
              return ItemTags(
                index: index,
                title: widget.task.bus[index].buName,
                pressEnabled: false,
                active: true,
                elevation: 0,
                activeColor: const Color(0xffE7E7E7),
                color: const Color(0xffE7E7E7),
                textColor: Colors.black,
                textActiveColor: Colors.black,
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.task.taskRemark,
            style: const TextStyle(color: MColor.textColor, fontSize: 16),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              widget.task.taskDate,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
