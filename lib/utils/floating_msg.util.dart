import 'package:flutter/material.dart';

enum MsgType { success, error, warning }

class FloatingMsg {
  static void show(
      {required BuildContext context,
      required String? msg,
      required MsgType msgType}) {
    Color? color;
    switch (msgType) {
      case MsgType.success:
        color = Colors.green;
        break;
      case MsgType.error:
        color = const Color.fromARGB(141, 244, 67, 54);
        break;
      case MsgType.warning:
        color = Colors.yellow;
        break;
    }

    if (msg != null && msg.isNotEmpty) {
      var snackBar = SnackBar(
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        padding: EdgeInsets.zero,
        clipBehavior: Clip.none,
        content: Container(
          constraints: const BoxConstraints(minHeight: 50.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Center(
            child: Text(msg),
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
