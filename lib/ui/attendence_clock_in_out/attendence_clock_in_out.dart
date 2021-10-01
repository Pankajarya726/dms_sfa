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
          clockInOutTextField(),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Clock In Selfie",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 150,
            height: 150,
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
            child: Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(55),
              child: const Image(
                image: AssetImage("assets/camera.png"),
                fit: BoxFit.cover,
              ),
            ),
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
          // Theme(
          //   data: ThemeData(unselectedWidgetColor: Colors.black),
          //   child: Checkbox(
          //     shape: const CircleBorder(),
          //     value: true,
          //     activeColor: colorPrimary,
          //     checkColor: Colors.white,
          //     onChanged: (value) {
          //       setState(() {});
          //     },
          //   ),
          // ),
          const Text(
            "GPS location",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          roundedButton(context),
        ],
      ),
    );
  }
}

Widget clockInOutTextField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Clock In Selfie",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      TextFormField(
        maxLines: 4,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: Color(0xff303030),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Color(0xff555555),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget roundedButton(context) {
  return Center(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.40,
      child: MaterialButton(
        height: 45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/clock.png",
              width: 25,
              fit: BoxFit.fill,
            ),
            const SizedBox(width: 10),
            const Text(
              "Clock In",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        onPressed: () {},
      ),
    ),
  );
}
