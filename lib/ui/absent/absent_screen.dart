import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/ui/absent/bloc/absent_bloc.dart';
import 'package:sfa/ui/absent/bloc/absent_events.dart';
import 'package:sfa/ui/absent/bloc/absent_states.dart';
import 'package:sfa/utility/colors.dart';

class AbsentScreen extends StatefulWidget {
  const AbsentScreen({Key? key}) : super(key: key);

  @override
  State<AbsentScreen> createState() => _AbsentScreenState();
}

class _AbsentScreenState extends State<AbsentScreen> {
  final absentReason = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Reason",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          TextFormField(
            maxLines: 4,
            controller: absentReason,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Color(0xff303030),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorPrimary),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xff555555),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          BlocProvider(
            create: (context) => AbsentBloc(),
            child: BlocConsumer<AbsentBloc, AbsentStates>(
              listener: (context, state) {
                if (state is AbsentSuccessState) {
                  Fluttertoast.showToast(
                      msg: state.markAbsentByUserResponse.message);
                }
                if (state is AbsentFailureState) {
                  Fluttertoast.showToast(msg: state.failureMessage);
                }
              },
              builder: (context, state) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AbsentBloc>(context).add(
                          AbsentSuccessEvent(absentReason: absentReason.text));
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(180, 50)),
                      backgroundColor: MaterialStateProperty.all(colorPrimary),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
