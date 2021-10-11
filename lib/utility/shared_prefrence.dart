import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrence {
  static Future<bool> setStringPreference(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
