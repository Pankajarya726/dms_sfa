import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class TaskHistory extends StatefulWidget {
  const TaskHistory({Key? key}) : super(key: key);

  @override
  State<TaskHistory> createState() => _TaskHistoryState();
}

class _TaskHistoryState extends State<TaskHistory> {
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
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        itemCount: 5,
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 20,
          );
        },
        itemBuilder: (context, index) {
          return TaskHistoryItems(
            index: index,
          );
        },
      ),
    );
  }
}

class TaskHistoryItems extends StatefulWidget {
  final int index;
  const TaskHistoryItems({Key? key, required this.index}) : super(key: key);

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
        color: widget.index == 0
            ? const Color(0xffFD4848)
            : widget.index == 1
                ? const Color(0xff54C0EB)
                : widget.index == 2
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
                children: const [
                  Flexible(
                    flex: 4,
                    child: Text(
                      "85awrs37463",
                      style: TextStyle(
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
                      "10-03-2022",
                      style: TextStyle(
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
                children: const [
                  Flexible(
                    child: Text(
                      "Partial delivery failure",
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff272727),
                        letterSpacing: 0.67,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Image(
                    image: AssetImage(
                      "assets/hit.png",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Flexible(
                    child: Image(
                      image: AssetImage(
                        "assets/time.png",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Text(
                      "5 days pending",
                      style: TextStyle(
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
