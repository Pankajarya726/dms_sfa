import 'package:dms/ui/task/task_history/task_history.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class TaskHistoryBottomSheet extends StatefulWidget {
  const TaskHistoryBottomSheet({Key? key}) : super(key: key);

  @override
  _TaskHistoryBottomSheetState createState() => _TaskHistoryBottomSheetState();
}

class _TaskHistoryBottomSheetState extends State<TaskHistoryBottomSheet> {
  List<Widget> itemList = [];

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
        minHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    itemList.length,
                    (index) {
                      return itemList[index];
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: Row(
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
                              builder: (context) => const TaskHistory()));
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
          ),
        ],
      ),
    );
  }

  void getList() {
    Widget heading = const Padding(
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
    );
    itemList.add(heading);

    for (int i = 0; i < 9; i++) {
      TaskHistoryModal status = TaskHistoryModal(
        icons: "assets/hit.png",
        reason: "Full delivery failure",
        task: "20",
      );
      itemList.add(TaskHistoryWidget(
        status: status,
      ));
    }
    Widget total = Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 70),
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
          children: const [
            Text(
              StringConst.totalTask,
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 0.67,
              ),
            ),
            Text("124"),
          ],
        ),
      ),
    );
    itemList.add(total);
    setState(() {});
  }
}

class TaskHistoryWidget extends StatelessWidget {
  final TaskHistoryModal status;
  const TaskHistoryWidget({Key? key, required this.status}) : super(key: key);

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
          Image(
            image: AssetImage(status.icons),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              status.reason,
              maxLines: 5,
              style: const TextStyle(
                color: MColor.textColor,
                fontSize: 14,
                letterSpacing: 0.67,
              ),
            ),
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
              status.task,
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

class TaskHistoryModal {
  String icons;
  String reason;
  String task;

  TaskHistoryModal(
      {required this.icons, required this.reason, required this.task});
}
