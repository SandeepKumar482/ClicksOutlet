import 'dart:math';

import 'package:clicks_outlet/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static SnackbarController getSnacbar(String title, String message) {
    return Get.showSnackbar(GetSnackBar(
      title: title,
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 2),
      backgroundColor: ColorsConst.fourth,
    ));
  }

  static double getWidth({required BuildContext context}) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight({required BuildContext context}) {
    return MediaQuery.of(context).size.height;
  }

  static String? generateUserName({required String? username}) {
    return username?.split('@')[0].replaceAll(RegExp(r'[^\w\s]+'), '_');
  }

  static InputDecoration buildInputDecoration(String label, IconData iconData) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(
          color: ColorsConst.primary,
          width: 2.0,
        ),
      ),
      prefixIcon: Icon(iconData, color: ColorsConst.third),
      labelStyle: const TextStyle(color: ColorsConst.third),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(
          color: ColorsConst.primary,
          width: 2.0,
        ),
      ),
    );
  }

  static String generateRandomUserId(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final result = String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
    return result;
  }
}
