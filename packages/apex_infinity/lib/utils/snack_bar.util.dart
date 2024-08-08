import 'package:flutter/material.dart';

enum AxSnackBarMsgType { success, error, warning }

class AxSnackBar {
  final BuildContext context;
  final String? message;
  final AxSnackBarMsgType msgType;

  AxSnackBar({
    required this.context,
    required this.message,
    required this.msgType
  });

   void show() {
     Color? color;
     switch (msgType) {
       case AxSnackBarMsgType.success:
         color = Colors.green;
         break;
       case AxSnackBarMsgType.error:
         color = const Color.fromARGB(141, 244, 67, 54);
         break;
       case AxSnackBarMsgType.warning:
         color = Colors.yellow;
         break;
     }

     if (message != null && message!.isNotEmpty) {
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
             child: Text(message!),
           ),
         ),
       );

       ScaffoldMessenger.of(context).showSnackBar(snackBar);
     }
   }
}
