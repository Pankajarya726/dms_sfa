import 'package:dms/ui/change_password/bloc/change_password_bloc.dart';
import 'package:dms/ui/change_password/bloc/change_password_event.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'bloc/change_password_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ChangePasswordBloc changePasswordBloc = ChangePasswordBloc();
  TextEditingController currPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChangePasswordBloc>(
      create: (context) => changePasswordBloc,
      child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccessState) {
            Fluttertoast.showToast(msg: state.response.message);
            currPassword.clear();
            newPassword.clear();
            confPassword.clear();
            Navigator.pop(context, true);
          }
          if (state is ChangePasswordFailureState) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Change Password"),
            centerTitle: true,
            backgroundColor: Colors.red,
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                    child: TextFormField(
                      controller: currPassword,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                      autocorrect: true,
                      enableSuggestions: true,
                      maxLines: 1,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Current Password",
                        hintStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        focusedBorder: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      controller: newPassword,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                      autocorrect: true,
                      enableSuggestions: true,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "New Password",
                        hintStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        focusedBorder: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 60),
                    child: TextFormField(
                      controller: confPassword,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                      autocorrect: true,
                      enableSuggestions: true,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        focusedBorder: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (currPassword.text.isNotEmpty &&
                          newPassword.text.isNotEmpty &&
                          confPassword.text.isNotEmpty) {
                        if (newPassword.text == confPassword.text) {
                          addEvent(currPassword.text, newPassword.text,
                              confPassword.text);
                        } else {
                          Fluttertoast.showToast(msg: "Password can't match");
                        }
                      } else {
                        Fluttertoast.showToast(msg: "Fields can't be empty");
                      }
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(220, 60)),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Update",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addEvent(
      String currentPassword, String newPassword, String confPassword) async {
    var id = await SharedPreference.getStringPreference(SharedPreference.id);
    changePasswordBloc.add(ChangePasswordEvent(
        id: id,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confPassword: confPassword));
  }
}
