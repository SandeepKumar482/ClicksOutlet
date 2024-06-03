import 'dart:io';

import 'package:clicksoutlet/FirebaseService/user_collection.service.dart';
import 'package:clicksoutlet/View/widgets/custom_app_bar.widget.dart';
import 'package:clicksoutlet/View/widgets/input.widget.dart';
import 'package:clicksoutlet/constants/style.dart';
import 'package:clicksoutlet/model/user_details.dart';
import 'package:clicksoutlet/utils/Utils.dart';
import 'package:clicksoutlet/utils/floating_msg.util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MyProfile extends StatelessWidget {
  MyProfile({super.key});

  final ImagePicker _picker = ImagePicker();
  XFile? profileImage;
  TextEditingController name = TextEditingController();
  TextEditingController userName = TextEditingController();

  @override
  void initState() async {
    UserDetailsModel? userDetailsModel = await UserCollectionService()
        .fetchData(UserDetailsModel(id: "", name: "", userName: ""));
    if (UserDetailsModel != null) {
      name.text = userDetailsModel!.name!;
      userName.text = userDetailsModel!.userName!;
      profileImage?.path != userDetailsModel!.profilePicture;
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: ColorsConst.primary,
        title: const CustomAppBar(
          word1: "Clicks",
          word2: "Outlet",
        ),
      ),
      body: Center(
        child: Column(
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
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: profileImage == null
                        ? Icon(
                            Icons.add_a_photo_outlined,
                            size: deviceHeight * 0.100,
                          )
                        : Image.file(
                            File(profileImage!.path),
                            fit: BoxFit.cover,
                            width: deviceWidth * 0.1,
                            // Set your desired width
                            height:
                                deviceHeight * 0.1, // Set your desired height
                          ),
                  ),
                ),
              ),
              onTap: () async {
                PermissionStatus status = await Permission.photos.status;
                if (status.isGranted) {
                  profileImage =
                      await _picker.pickImage(source: ImageSource.gallery);
                } else {
                  PermissionStatus requestStatus =
                      await Permission.photos.request();
                  if (requestStatus.isGranted) {
                  } else {
                    FloatingMsg.show(
                        context: context,
                        msg: "Please Allow Photos First",
                        msgType: MsgType.error);
                  }
                }
              },
            ),
            SizedBox(height: deviceHeight * 0.015),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: InputWidget(
                label: "User Name",
                controller: userName,
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            SizedBox(height: deviceHeight * 0.010),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: InputWidget(
                label: "Label Name",
                controller: name,
                prefixIcon: const Icon(Icons.label_important_outline),
                validator: (value) {
                  if (value!.isEmpty) {
                    Utils.getSnacbar("OOPS!!", "Please Enter a Valid Name");
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
                label: "Email",
                controller: name,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (value) {
                  if (value!.isEmpty) {
                    Utils.getSnacbar("OOPS!!", "Please Enter a Valid Name");
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
                    Utils.getSnacbar("OOPS!!", "Please Enter a Valid Name");
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
        ),
      ),
    );
  }
}
