import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SelectOtpNumberBottomSheet extends StatefulWidget {
  const SelectOtpNumberBottomSheet({Key? key}) : super(key: key);

  @override
  _SelectOtpNumberBottomSheetState createState() =>
      _SelectOtpNumberBottomSheetState();
}

class _SelectOtpNumberBottomSheetState
    extends State<SelectOtpNumberBottomSheet> {
  Object selectNumberRadio = "";
  TextEditingController otpController = TextEditingController();
  CommonBloc commonBloc = CommonBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => commonBloc,
      child: Container(
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
                otpNumber,
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
              BlocBuilder<CommonBloc, CommonBlocStates>(
                builder: (context, state) {
                  if (state is CommonBlocRetailerRadioState) {
                    selectNumberRadio = state.retailerRadioTag;
                  }
                  return Column(
                    children: [
                      radioButtonWidget(selectNumberRadio, 0, primary),
                      radioButtonWidget(selectNumberRadio, 1, secondary),
                      radioButtonWidget(selectNumberRadio, 2, helper),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buttonWidget(done),
                  buttonWidget(submitAnyway),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonWidget(label) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (label == done) {
            if (selectNumberRadio == "") {
              Fluttertoast.showToast(msg: "Please select number for OTP");
            } else {
              logoutDialog(context);
              // Navigator.pop(context);
            }
          } else {
            Navigator.pop(context);
          }
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(170, 50)),
          backgroundColor: MaterialStateProperty.all(
              label == done ? MColor.colorPrimary : MColor.colorSecondary),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            letterSpacing: 0.67,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget radioButtonWidget(groupValue, value, label) {
    return GestureDetector(
      onTap: () {
        commonBloc.add(CommonBlocRetailerRadioEvent(retailerRadioTag: value));
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
                commonBloc
                    .add(CommonBlocRetailerRadioEvent(retailerRadioTag: value));
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
                pleaseEnterOTP,
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
                hintText: enterHere,
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
                    cancel,
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
                    confirmSmall,
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
