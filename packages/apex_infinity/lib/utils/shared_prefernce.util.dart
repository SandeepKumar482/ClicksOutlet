import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AxSharedPreference {
  SharedPreferences? _sharedPreferences;

  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> clearData({String? key}) async {
    if (_sharedPreferences == null) {
      await init();
    }

    if (key != null) {
      return _sharedPreferences!.remove(key);
    } else {
      return _sharedPreferences!.clear();
    }
  }

  Future<bool> setData(
      {required String key, required dynamic data, bool isBool = false}) async {
    if (_sharedPreferences == null) {
      await init();
    }

    if (isBool) {
      return _sharedPreferences!.setBool(key, data);
    }

    return _sharedPreferences!.setString(key, data);
  }

   Object? getData({required String key}) {
    return _sharedPreferences?.get(key);
  }

   bool isKeyExits({required String key}) {
    Object? data = _sharedPreferences?.get(key);
    return data != null;
  }

  // Example method to get a string value from SharedPreferences.
   Map<String, dynamic> getJson({required String key}) {
    Map<String, dynamic> data = {};

    String? rawData = _sharedPreferences?.getString(key);
    if (rawData != null && rawData.isNotEmpty) {
      data = jsonDecode(rawData);
    }
    return data;
  }

  // Example method to set a string value in SharedPreferences.
   Future<bool> setJson(
      {required String key, required Map<String, dynamic> value}) async {
    return _sharedPreferences!.setString(key, jsonEncode(value));
  }

   Future<bool> clear() async {
    return _sharedPreferences!.clear();
  }
}