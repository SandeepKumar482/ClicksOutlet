import 'package:apex_infinity/navigation/navigation_data.model.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatelessWidget {
  final AxNavigationData navigationData;

  const MyAccount({super.key,
    required this.navigationData
});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
  }
}
