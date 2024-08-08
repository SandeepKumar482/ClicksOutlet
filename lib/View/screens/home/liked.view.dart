import 'package:apex_infinity/navigation/navigation_data.model.dart';
import 'package:flutter/material.dart';

class LikedClicks extends StatelessWidget {

  final AxNavigationData navigationData;

  const LikedClicks({super.key,required this.navigationData});

  @override
  Widget build(BuildContext context) {
    return const Text("Liked");
  }
}
