import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrence {
  static const login = "login";
  static const token = "token";
  static const password = "password";
  static const mobileNumber = "mobile_number";
  static const id = "id";

  static Future<bool> setStringPreference(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<bool> setBooleanPreference(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  static Future<bool> getBooleanPreference(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}
