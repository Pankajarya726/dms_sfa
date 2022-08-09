import 'dart:async';

import 'package:dms/model/retailer_form.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';

class SelectOtpNumberBottomSheet extends StatefulWidget {
  final Function(String mobile) onDone;
  final Function onSubmit;
  final RetailerForm form;

  const SelectOtpNumberBottomSheet({Key? key, required this.form, required this.onDone, required this.onSubmit}) : super(key: key);

  @override
  _SelectOtpNumberBottomSheetState createState() => _SelectOtpNumberBottomSheetState();
}

class _SelectOtpNumberBottomSheetState extends State<SelectOtpNumberBottomSheet> {
  int groupValue = -1;
  TextEditingController otpController = TextEditingController();
  CommonBloc commonBloc = CommonBloc();
  StreamController<int> radioStreamController = StreamController();

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
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringConst.otpNumber,
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
            radioButtonWidget(groupValue, 1, StringConst.primary),
            radioButtonWidget(groupValue, 2, StringConst.secondary),
            radioButtonWidget(groupValue, 3, StringConst.helper),
            // RadioListTile<int>(
            //   value: 1,
            //   groupValue: groupValue,
            //   onChanged: (value) {
            //     groupValue = value!;
            //     setState(() {});
            //   },
            //   title: const Text(StringConst.primary),
            // ),
            // RadioListTile<int>(
            //   value: 2,
            //   groupValue: groupValue,
            //   onChanged: (value) {
            //     groupValue = value!;
            //     setState(() {});
            //   },
            //   title: const Text(StringConst.secondary),
            // ),
            // RadioListTile<int>(
            //   value: 3,
            //   groupValue: groupValue,
            //   onChanged: (value) {
            //     groupValue = value!;
            //     setState(() {});
            //   },
            //   title: const Text(StringConst.helper),
            // ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buttonWidget(context, StringConst.done),
                buttonWidget(context, StringConst.submitAnyway),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonWidget(BuildContext context, String label) {
    return Center(
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        onPressed: () {
          if (label == StringConst.done) {
            if (groupValue == -1) {
              Utility.showToast("Please select an option");
              return;
            }
            if (groupValue == 1 && widget.form.primaryMobile.trim().isEmpty) {
              Utility.showToast("Primary mobile number is not entered please select different option");
              return;
            }
            if (groupValue == 2 && widget.form.secondaryMobile.trim().isEmpty) {
              Utility.showToast("Secondary mobile number is not entered please select different option");
              return;
            }
            if (groupValue == 3 && widget.form.helperMobile.trim().isEmpty) {
              Utility.showToast("Helper mobile number is not entered please select different option");
              return;
            }

            String number = groupValue == 1
                ? widget.form.primaryMobile.trim()
                : groupValue == 2
                    ? widget.form.secondaryMobile.trim()
                    : widget.form.helperMobile.trim();

            widget.onDone(number);
            Navigator.pop(context);
          } else {
            widget.onSubmit();
            Navigator.pop(context);
          }
        },
        color: label == StringConst.done ? MColor.colorPrimary : MColor.colorSecondary,
        height: 40,
        minWidth: MediaQuery.of(context).size.width / 2.3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            letterSpacing: 0.67,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget radioButtonWidget(groupValue, value, label) {
    return InkWell(
      onTap: () {
        this.groupValue = value!;
        setState(() {});
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
                this.groupValue = value!;
                setState(() {});
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

  logoutDialog(
    context,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          actionsOverflowButtonSpacing: 10,
          actions: [
            const SizedBox(
              height: 5,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                StringConst.pleaseEnterOTP,
                style: TextStyle(
                  letterSpacing: 0.67,
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: otpController,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.67,
                color: MColor.backButton,
              ),
              decoration: InputDecoration(
                hintText: StringConst.enterHere,
                hintStyle: const TextStyle(
                  color: MColor.backButton,
                  letterSpacing: 0.67,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                filled: true,
                fillColor: const Color(0xffF2F2F2),
                counter: Container(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    StringConst.cancel,
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0.67,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: const Text(
                    StringConst.confirmSmall,
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0.67,
                      color: Color(0xfff4511e),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {},
                ),
              ],
            ),
            const SizedBox(
              width: 30,
            ),
          ],
        );
      },
    );
  }
}
