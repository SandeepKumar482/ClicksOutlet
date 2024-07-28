import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AxThemeData {

  final AxShimmerThemeData shimmerThemeData;

  const AxThemeData({
    this.shimmerThemeData = const AxShimmerThemeData()
  });

}

class AxShimmerThemeData {

  final LinearGradient linearGradient;
  final Color backgroundColor;

  const AxShimmerThemeData(
  {
    this.linearGradient = const LinearGradient(
      colors: [
        Color(0xFFEBEBF4),
        Color(0xFFF4F4F4),
        Color(0xFFEBEBF4),
      ],
      stops: [
        0.1,
        0.3,
        0.4,
      ],
      begin: Alignment(-1.0, -0.3),
      end: Alignment(1.0, 0.3),
      tileMode: TileMode.clamp,
    ),
    this.backgroundColor = Colors.black
  });

}