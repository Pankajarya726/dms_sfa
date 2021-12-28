import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const isLogin = "login";
  static const accessToken = "token";
  static const tokenType = "token_type";
  static const password = "password";
  static const mobileNumber = "mobile_number";
  static const userId = "user_id";
  static const confirmEditIcon = "confirm_edit_icon";
  static const isEnable = "is_Enable";
  static const isLeader = "is_Leader";
  static const name = "name";
  static const email = "email";
  static const userDesignation = "user_designation";
  static const userImage = "user_image";
  static const pjpButton = "pjp_button";
  static const startMyDay = "startMyDay";

  static Future<bool> setStringPreference(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String> getStringPreference(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static Future<bool> setBooleanPreference(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  static Future<bool> getBooleanPreference(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<void> clearSharedPreference(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
