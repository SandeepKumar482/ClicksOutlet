import 'dart:io';

import 'package:apex_infinity/image/network_image.dart';
import 'package:apex_infinity/navigation/navigation_data.model.dart';
import 'package:apex_infinity/utils/snack_bar.util.dart';
import 'package:clicks_outlet/View/widgets/input.widget.dart';
import 'package:clicks_outlet/constants/style.dart';
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
      children: [
        InkWell(
          child: Container(
            decoration: BoxDecoration(
              color: ColorsConst.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorsConst.secondary,
                // Set your desired border color
                width: 2.0, // Set your desired border width
              ),
            ),
            child: AxNetworkImage(
              imageUrl: '',
            ),
          ),
          onTap: () async {
            // TODO : Change Profile Picture Logic
          },
        ),
        SizedBox(height: deviceHeight * 0.015),
        SizedBox(height: deviceHeight * 0.010),
        SizedBox(height: deviceHeight * 0.010),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0),
          child: InputWidget(
            label: "Email",
            controller: name,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value!.isEmpty) {
                AxSnackBar(
                    context: context,
                    message: "OOPS!! Please Enter a Valid Name" ,
                    msgType: AxSnackBarMsgType.error
                ).show();
                return ' ';
              } else {
                return null;
              }
            },
          ),
        ),
        SizedBox(height: deviceHeight * 0.010),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0),
          child: InputWidget(
            label: "Phone Number",
            controller: name,
            prefixIcon: const Icon(Icons.phone_android_outlined),
            validator: (value) {
              if (value!.isEmpty) {
                AxSnackBar(
                    context: context,
                    message: "OOPS!! Please Enter a Valid Name",
                    msgType: AxSnackBarMsgType.error
                ).show();
                return ' ';
              } else {
                return null;
              }
            },
          ),
        ),
        const SizedBox(height: 20.0),
        SizedBox(height: deviceHeight * 0.02),
        SizedBox(
          width: deviceWidth * 0.65, // 60% of device width
          child: ElevatedButton(
            onPressed: () async {},
            style: ElevatedButton.styleFrom(
                foregroundColor: ColorsConst.secondary,
                backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ),
        SizedBox(
          width: deviceWidth * 0.65, // 60% of device width
          child: ElevatedButton(
            onPressed: () async {},
            style: ElevatedButton.styleFrom(
                foregroundColor: ColorsConst.secondary,
                backgroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        )
      ],
    );
  }
}
