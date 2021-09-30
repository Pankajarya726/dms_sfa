import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sfa/utility/colors.dart';

class AttendenceClockInOut extends StatefulWidget {
  const AttendenceClockInOut({Key? key}) : super(key: key);

  @override
  _AttendenceClockInOutState createState() => _AttendenceClockInOutState();
}

class _AttendenceClockInOutState extends State<AttendenceClockInOut> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 5,
              decoration: const BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            textWidget("Working plan"),
            const SizedBox(
              height: 20,
            ),
            clockInOutTextField(),
            const SizedBox(
              height: 20,
            ),
            textWidget("Clock In Selfie"),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 5,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(
                  color: Colors.grey,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              child: const Icon(Icons.camera),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.orange,
            ),
            const SizedBox(
              height: 20,
            ),
            roundedButton(context),
          ],
        ),
      ),
    );
  }
}

Widget clockInOutTextField() {
  return const TextField(
    maxLines: 3,
  );
}

Widget textWidget(textValue) {
  return Text(
    textValue,
    textAlign: TextAlign.left,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 17,
    ),
  );
}

Widget roundedButton(context) {
  return Center(
    child: SizedBox(
      height: 40,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Material(
          color: Colors.green,
          child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 25,
                ),
                Icon(
                  Icons.lock_clock,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 15,
                ), // icon
                Text("Clock In",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    )),
                SizedBox(
                  width: 25,
                ), // text
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
