import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';

class Utility {
  static Future<String> getStringPreference(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? "";
  }

  static Future<int> getIntPreference(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key) ?? 0;
  }

  static Future<bool> getBoolPreference(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }

  static Future<bool> setStringPreference(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  static Future<bool> setIntPreference(String key, int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt(key, value);
  }

  static Future<bool> setBoolPreference(String key, bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(key, value);
  }

  static Future<bool> clearPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.clear();
  }

  static showToast(String message) {
    if (message.trim().isNotEmpty) {
      Fluttertoast.showToast(msg: message);
    }
  }

  static hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static Future<String> findLocalPath() async {
    final directory = Platform.isAndroid ? await getTemporaryDirectory() : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<bool?> showConfirmAlert(
      {required BuildContext context, required String title, String? subTitle, String? confirmText, String? cancelText}) async {
    return await showDialog<bool?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
                SizedBox(
                  height: subTitle == null ? 0 : 5,
                ),
                subTitle == null
                    ? Container()
                    : Text(
                        subTitle,
                        style: const TextStyle(color: Color(0xff303030), fontSize: 16),
                      ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  cancelText ?? "Cancel",
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: Text(
                  confirmText ?? "Ok",
                  style: const TextStyle(color: MColor.colorPrimary, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }
}
