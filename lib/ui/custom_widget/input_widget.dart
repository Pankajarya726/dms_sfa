import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';

class NameEditText extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final GlobalKey globalKey;
  final Function(String text) onChange;

  const NameEditText({
    Key? key,
    required this.controller,
    required this.hint,
    required this.onChange,
    required this.globalKey,
  }) : super(key: key);

  @override
  _NameEditTextState createState() => _NameEditTextState();
}

class _NameEditTextState extends State<NameEditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChange,
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        RenderObject? object =
            widget.globalKey.currentContext!.findRenderObject();
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
    );
  }
}

class MobileEditText extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String text) onChange;
  final GlobalKey globalKey;

  const MobileEditText({
    Key? key,
    required this.controller,
    required this.hint,
    required this.onChange,
    required this.globalKey,
  }) : super(key: key);

  @override
  _MobileEditTextState createState() => _MobileEditTextState();
}

class _MobileEditTextState extends State<MobileEditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        RenderObject? object =
            widget.globalKey.currentContext!.findRenderObject();
        object!.showOnScreen();
      },
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

  const GSTEditText({
    Key? key,
    required this.controller,
    required this.hint,
    required this.globalKey,
  }) : super(key: key);

  @override
  _GSTEditTextState createState() => _GSTEditTextState();
}

class _GSTEditTextState extends State<GSTEditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        RenderObject? object =
            widget.globalKey.currentContext!.findRenderObject();
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

class PANEditText extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final GlobalKey globalKey;
  final Function(String text) onChange;
  const PANEditText(
      {Key? key,
      required this.controller,
      required this.hint,
      required this.globalKey,
      required this.onChange})
      : super(key: key);

  @override
  State<PANEditText> createState() => _PANEditTextState();
}

class _PANEditTextState extends State<PANEditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChange,
      autofocus: false,
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        RenderObject? object =
            widget.globalKey.currentContext!.findRenderObject();
        object!.showOnScreen();
      },
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.67,
        color: MColor.backButton,
      ),
      maxLength: 10,
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

class AadharEditText extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final GlobalKey globalKey;
  final Function(String text) onChange;
  const AadharEditText(
      {Key? key,
      required this.controller,
      required this.hint,
      required this.globalKey,
      required this.onChange})
      : super(key: key);

  @override
  State<AadharEditText> createState() => _AadharEditTextState();
}

class _AadharEditTextState extends State<AadharEditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChange,
      autofocus: false,
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        RenderObject? object =
            widget.globalKey.currentContext!.findRenderObject();
        object!.showOnScreen();
      },
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.67,
        color: MColor.backButton,
      ),
      maxLength: 12,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
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

class DateEditText extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String name;
  final Function(String text) onChange;
  const DateEditText({
    Key? key,
    required this.controller,
    required this.hint,
    required this.onChange,
    required this.name,
  }) : super(key: key);

  @override
  State<DateEditText> createState() => _DateEditTextState();
}

class _DateEditTextState extends State<DateEditText> {
  DateTime? dateTimeBirth;
  DateTime? dateTimeAnniversary;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChange,
      readOnly: true,
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (widget.name == StringConst.birthday) {
          dateTimeBirth ??= await NTP.now();
          dateTimeBirth = await showDatePicker(
            context: context,
            initialDate: dateTimeBirth!,
            firstDate: DateTime(1950),
            lastDate: await NTP.now(),
          );
          if (dateTimeBirth != null) {
            BlocProvider.of<CommonBloc>(context)
                .add(CommonBlocBirthdayEvent(dateTime: dateTimeBirth!));
          }
        }

        if (widget.name == StringConst.anniversary) {
          dateTimeAnniversary ??= await NTP.now();
          dateTimeAnniversary = await showDatePicker(
            context: context,
            initialDate: dateTimeAnniversary!,
            firstDate: DateTime(1950),
            lastDate: await NTP.now(),
          );
          if (dateTimeAnniversary != null) {
            BlocProvider.of<CommonBloc>(context).add(
                CommonBlocAnniversaryEvent(dateTime: dateTimeAnniversary!));
          }
        }
      },
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.67,
        color: MColor.backButton,
      ),
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Align(
            widthFactor: 1,
            alignment: Alignment.centerRight,
            child: Image(
              width: 22,
              image: AssetImage("assets/calendar_icon.png"),
            ),
          ),
        ),
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
