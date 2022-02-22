import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameEditText extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final GlobalKey globalKey;

  final Function(String text) onChange;

  const NameEditText({Key? key, required this.controller, required this.hint, required this.onChange, required this.globalKey})
      : super(key: key);

  @override
  _NameEditTextState createState() => _NameEditTextState();
}

class _NameEditTextState extends State<NameEditText> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return false;
      },
      child: TextFormField(
        onChanged: widget.onChange,
        onTap: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          RenderObject? object = widget.globalKey.currentContext!.findRenderObject();
          object!.showOnScreen();
        },
        autofocus: false,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.67,
          color: MColor.backButton,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[a-z A-Z,.\-]")),
        ],
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(
            color: MColor.backButton,
            letterSpacing: 0.67,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          filled: true,
          fillColor: const Color(0xffF2F2F2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class MobileEditText extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String text) onChange;

  const MobileEditText({Key? key, required this.controller, required this.hint, required this.onChange}) : super(key: key);

  @override
  _MobileEditTextState createState() => _MobileEditTextState();
}

class _MobileEditTextState extends State<MobileEditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      onChanged: widget.onChange,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.67,
        color: MColor.backButton,
      ),
      keyboardType: TextInputType.phone,
      maxLength: 10,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: widget.controller,
      decoration: InputDecoration(
        counterText: "",
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: MColor.backButton,
          letterSpacing: 0.67,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        filled: true,
        fillColor: const Color(0xffF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class GSTEditText extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final GlobalKey globalKey;
  final Function(TextEditingController controller) onTextFieldOpened;

  const GSTEditText({Key? key, required this.controller, required this.hint, required this.globalKey, required this.onTextFieldOpened})
      : super(key: key);

  @override
  _GSTEditTextState createState() => _GSTEditTextState();
}

class _GSTEditTextState extends State<GSTEditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: (value) {
        TextEditingController selectedController = TextEditingController();
        widget.onTextFieldOpened(selectedController);
      },
      onTap: () async {
        widget.onTextFieldOpened(widget.controller);
        await Future.delayed(const Duration(milliseconds: 500));
        RenderObject? object = widget.globalKey.currentContext!.findRenderObject();
        object!.showOnScreen();
      },
      autofocus: false,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.67,
        color: MColor.backButton,
      ),
      maxLength: 15,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[A-Z 0-9]")),
      ],
      controller: widget.controller,
      decoration: InputDecoration(
        counterText: "",
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: MColor.backButton,
          letterSpacing: 0.67,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        filled: true,
        fillColor: const Color(0xffF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
