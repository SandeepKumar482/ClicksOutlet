import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AxNaviagtion {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static void goTo({required String? path, Map<String, dynamic>? arguments}) {
    if (navigationKey.currentState != null && path != null && path.isNotEmpty) {
      navigationKey.currentState!.pushNamed(path, arguments: arguments);
    }
  }
}
