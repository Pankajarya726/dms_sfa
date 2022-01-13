import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

class TeleCallerStatusSheet extends StatefulWidget {
  const TeleCallerStatusSheet({Key? key}) : super(key: key);

  @override
  _TeleCallerStatusSheetState createState() => _TeleCallerStatusSheetState();
}

class _TeleCallerStatusSheetState extends State<TeleCallerStatusSheet> {
  List<Widget> itemList = [];

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.3,
        maxChildSize: 0.8,
        minChildSize: 0.3,
        builder: (context, scrollControle) {
          return ListView.builder(
            controller: scrollControle,
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              return itemList[index];
            },
          );
        });
  }

  Widget heading = const Padding(
    padding: EdgeInsets.all(15.0),
    child: Text(
      "Summary",
      style: TextStyle(
          color: MColor.colorPrimary, fontSize: 20, letterSpacing: 0.67),
    ),
  );

  void getList() {
    itemList.add(heading);

    for (int i = 0; i < 10; i++) {
      TcStatus status = TcStatus(
          status: i == 0
              ? "Connected"
              : i == 1
                  ? "Not Connected"
                  : "Call Back",
          attempt: i,
          time: "12:15 PM",
          summery:
              "Lorem Ipsum is simply dummy text of the printing and typesetting lorem ops industry.");

      itemList.add(TCStatusWidget(
        status: status,
      ));
    }

    setState(() {});
  }
}

class TCStatusWidget extends StatelessWidget {
  final TcStatus status;

  const TCStatusWidget({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xffC5C5C5), width: 0.5))),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Attempt Number: ${status.attempt}",
                style: TextStyle(
                    color: MColor.textColor, fontSize: 14, letterSpacing: 0.67),
              ),
              Text(
                "${status.status}",
                style: TextStyle(
                    color: MColor.textColor, fontSize: 14, letterSpacing: 0.67),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Attempt Number: ${status.summery}",
            style: const TextStyle(
                color: MColor.textColor, fontSize: 14, letterSpacing: 0.67),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                status.time,
                style: const TextStyle(
                    color: MColor.textColor, fontSize: 14, letterSpacing: 0.67),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TcStatus {
  String status;
  int attempt;
  String time;
  String summery;

  TcStatus(
      {required this.status,
      required this.attempt,
      required this.time,
      required this.summery});
}
