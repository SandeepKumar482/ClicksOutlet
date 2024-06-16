import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceKey {
  static String packageInfo = 'packageInfo';
  static String userData = 'userData';
  static String seedColor = 'seedColor';
  static String isLight = 'isLight';
}

class SharedPreference {
  static SharedPreferences? _sharedPreferences;

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> clearData({String? key}) async {
    if (_sharedPreferences == null) {
      await SharedPreference.init();
    }

    if (key != null) {
      return _sharedPreferences!.remove(key);
    } else {
      return _sharedPreferences!.clear();
    }
  }

  static Future<bool> setData(
      {required String key, required dynamic data, bool isBool = false}) async {
    if (_sharedPreferences == null) {
      await SharedPreference.init();
    }

    if (isBool) {
      return _sharedPreferences!.setBool(key, data);
    }

    return _sharedPreferences!.setString(key, data);
  }

  static Object? getData({required String key}) {
    return _sharedPreferences?.get(key);
  }

  static bool isKeyExits({required String key}) {
    Object? data = _sharedPreferences?.get(key);
    return data != null;
  }

  // Example method to get a string value from SharedPreferences.
  static Map<String, dynamic> getJson({required String key}) {
    Map<String, dynamic> data = {};

    String? rawData = _sharedPreferences?.getString(key);
    if (rawData != null && rawData.isNotEmpty) {
      data = jsonDecode(rawData);
    }
    return data;
  }

  // Example method to set a string value in SharedPreferences.
  static Future<bool> setJson(
      {required String key, required Map<String, dynamic> value}) async {
    return _sharedPreferences!.setString(key, jsonEncode(value));
  }

  static Future<bool> clear() async {
    return _sharedPreferences!.clear();
  }
}
