import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

const ShapeBorder bottomSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15), topRight: Radius.circular(15)));

class BottomSheetHeading extends StatelessWidget {
  final String heading;

  const BottomSheetHeading(this.heading, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        heading,
        style: const TextStyle(
          color: MColor.colorPrimary,
          fontSize: 20,
          letterSpacing: 0.67,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DoneButton extends StatelessWidget {
  final Function() onPressed;
  final String title;

  const DoneButton({Key? key, required this.onPressed, this.title = "Done"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: MColor.colorPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
