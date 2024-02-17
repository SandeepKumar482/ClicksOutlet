import 'package:clicksoutlet/constants/ColorsConst.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static SnackbarController getSnacbar(String title, String message) {
    return Get.showSnackbar(GetSnackBar(
      title: title,
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      duration: Duration(seconds: 2),
      backgroundColor: ColorsConst.fourth,
    ));
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
}
