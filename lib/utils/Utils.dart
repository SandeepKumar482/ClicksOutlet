import 'package:clicks_outlet/constants/style.dart';
import 'package:flutter/material.dart';

class Utils {
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
}
