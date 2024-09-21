import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AxNaviagtion {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static void goTo({
    required String? path,
    Map<String, dynamic>? arguments,
    bool isReplacement = false
  }) {
    if (navigationKey.currentState != null && path != null && path.isNotEmpty) {

      if(isReplacement) {
        navigationKey.currentState!.pushReplacementNamed(path,arguments: arguments);
      } else {
        navigationKey.currentState!.pushNamed(path, arguments: arguments);

      }

    }
  }
}
