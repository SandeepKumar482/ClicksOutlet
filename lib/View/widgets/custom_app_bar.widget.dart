import 'package:flutter/material.dart';

final Widget brandName = RichText(
  textAlign: TextAlign.center,
  text: const TextSpan(
    text: "Clicks",
    style: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    children: [
      TextSpan(
        text: " Outlet",
        style: TextStyle(
            color: Colors.orangeAccent,
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
    ],
  ),
);

class CustomAppBar extends StatelessWidget {
  final String word1;
  final String word2;
  const CustomAppBar({super.key, required this.word1, required this.word2});

  @override
  Widget build(BuildContext context) {
    return brandName;
  }
}
