import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class EditStoreScreen extends StatefulWidget {
  const EditStoreScreen({Key? key}) : super(key: key);

  @override
  _EditStoreScreenState createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  Object selectEnrollmentType = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          editStore,
          style: TextStyle(
            color: MColor.backButton,
          ),
        ),
        centerTitle: true,
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
        actions: const [
          Image(
            width: 30,
            image: AssetImage("assets/get_location.png"),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            textWidget(enrollmentType),
            Row(
              children: [
                radioButtonWidget(selectEnrollmentType, 0, "First"),
                radioButtonWidget(selectEnrollmentType, 1, "Second")
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget textWidget(currentText) {
    return Text(
      currentText,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget radioButtonWidget(groupValue, value, label) {
    return Row(
      children: [
        SizedBox(
          width: 15,
          child: Radio<dynamic>(
            value: value,
            groupValue: groupValue,
            onChanged: (value) {
              setState(() {
                selectEnrollmentType = value!;
              });
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }
}
