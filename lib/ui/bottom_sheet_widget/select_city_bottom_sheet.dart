import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class SelectCityBottomSheet extends StatefulWidget {
  const SelectCityBottomSheet({Key? key}) : super(key: key);

  @override
  _SelectCityBottomSheetState createState() => _SelectCityBottomSheetState();
}

class _SelectCityBottomSheetState extends State<SelectCityBottomSheet> {
  List<String> names = [
    "Indore",
    "Bhopal",
    "Delhi",
    "Surat",
    "Banglore",
    "Indore",
    "Bhopal",
    "Delhi",
    "Surat",
    "Banglore",
    "Indore",
    "Bhopal",
    "Delhi",
    "Surat",
    "Banglore",
    "Indore",
    "Bhopal",
    "Delhi",
    "Surat",
    "Banglore",
    "Indore",
    "Bhopal",
    "Delhi",
    "Surat",
    "Banglore",
    "Indore",
    "Bhopal",
    "Delhi",
    "Surat",
    "Banglore",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      constraints: BoxConstraints(minHeight: 100, maxHeight: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            selectCity,
            style: TextStyle(
              fontSize: 19,
              color: MColor.colorPrimary,
              letterSpacing: 0.67,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              // controller: ScrollController(keepScrollOffset: false),
              itemCount: names.length,
              itemBuilder: (context, index) {
                return radioButtonWidget(index, index, names[index]);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: MaterialButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              color: MColor.colorPrimary,
              // style: ButtonStyle(
              //   fixedSize: MaterialStateProperty.all(const Size(220, 60)),
              //   backgroundColor: MaterialStateProperty.all(MColor.colorPrimary),
              //   elevation: MaterialStateProperty.all(0),
              //   shape: MaterialStateProperty.all(
              //     RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //   ),
              // ),
              child: const Text(
                done,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget radioButtonWidget(groupValue, value, label) {
    return GestureDetector(
      onTap: () {
        // addRadioEvent();
      },
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Radio<dynamic>(
              value: value,
              groupValue: groupValue,
              activeColor: MColor.colorPrimary,
              fillColor: MaterialStateProperty.all(MColor.colorPrimary),
              onChanged: (value) {
                // addRadioEvent();
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 17.0,
              color: MColor.backButton,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
