import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Fluttertoast.showToast(msg: message);
  }

  static hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
