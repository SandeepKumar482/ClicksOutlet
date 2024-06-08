import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  static SharedPreferences? _prefsInstance;

  // Call this method from the `initState()` function of your main app.
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  // Example method to get a string value from SharedPreferences.
  static String getString(String key) {
    return _prefsInstance?.getString(key) ?? "";
  }

  // Example method to set a string value in SharedPreferences.
  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }

  // Example method to get a string value from SharedPreferences.
  static Map<String, dynamic> getJson(String key) {
    Map<String, dynamic> data = {};

    String? rawData = _prefsInstance?.getString(key);
    if (rawData != null && rawData.isNotEmpty) {
      data = jsonDecode(rawData);
    }
    return data;
  }

  // Example method to set a string value in SharedPreferences.
  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    var prefs = await _instance;
    return prefs.setString(key, jsonEncode(value));
  }

  static Future<bool> clear() async {
    var prefs = await _instance;
    return prefs.clear();
  }
}
