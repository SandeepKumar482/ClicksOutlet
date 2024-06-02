import 'dart:io';

import 'package:clicksoutlet/FirebaseService/user_collection.service.dart';
import 'package:clicksoutlet/View/screens/home.view.dart';
import 'package:clicksoutlet/View/widgets/input.widget.dart';
import 'package:clicksoutlet/constants/style.dart';
import 'package:clicksoutlet/model/user_details.dart';
import 'package:clicksoutlet/utils/Utils.dart';
import 'package:clicksoutlet/utils/floating_msg.util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/custom_app_bar.widget.dart';

class UserDetailsForm extends StatelessWidget {
  UserDetailsForm({super.key});

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    UserCollectionService userCollectionService = UserCollectionService();

    final formKey = GlobalKey<FormState>();
    TextEditingController name = TextEditingController();
    TextEditingController userName = TextEditingController();

    XFile? profileImage;
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
            child: Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                                          File(profileImage.path),
                                          fit: BoxFit.cover,
                                          width: deviceWidth * 0.1,
                                          // Set your desired width
                                          height: deviceHeight *
                                              0.1, // Set your desired height
                                        ),
                                ),
                              ),
                            ),
                            onTap: () async {
                              PermissionStatus status =
                                  await Permission.photos.status;
                              if (status.isGranted) {
                                profileImage = await _picker.pickImage(
                                    source: ImageSource.gallery);
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
                          SizedBox(
                            height: 25,
                            /*child: Divider(
                              endIndent: deviceWidth * 0.2,
                              indent: deviceWidth * 0.2,
                            ),*/
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 38),
                            child: InputWidget(
                              label: "User Name",
                              controller: userName,
                              prefixIcon: const Icon(Icons.person),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    userCollectionService
                                        .isUserNameAlreadyExist(
                                            UserDetailsModel(
                                                id: userName.text,
                                                name: "",
                                                userName: "")) as bool) {
                                  return 'Please Enter a Valid user_name ';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 38.0),
                            child: InputWidget(
                              label: "Label Name",
                              controller: name,
                              prefixIcon:
                                  const Icon(Icons.label_important_outline),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  Utils.getSnacbar(
                                      "OOPS!!", "Please Enter a Valid Name");
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
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  try {
                                    bool isAlreadyExist = userCollectionService
                                        .isUserNameAlreadyExist(
                                            UserDetailsModel(
                                                id: userName.text,
                                                name: "",
                                                userName: "")) as bool;
                                    if (isAlreadyExist) {
                                      Utils.getSnacbar(
                                          "User Name Already Exist",
                                          "Try another one");
                                    } else {
                                      Future<bool> isAdded =
                                          userCollectionService.addUpdateData(
                                              UserDetailsModel(
                                                  id: "sd",
                                                  name: name.text,
                                                  userName: userName.text));
                                      if (await isAdded) {
                                        Utils.getSnacbar(
                                            "GREAT!!", "Joined Successfully");
                                        Get.off(const Home());
                                      }
                                    }
                                  } catch (e) {
                                    e.printError(
                                        info: "Error in authentication--");
                                    Utils.getSnacbar(
                                        "User Details", e.toString());
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: ColorsConst.secondary,
                                  backgroundColor: ColorsConst.fourth),
                              child: const Text('Submit'),
                            ),
                          )
                        ])))));
  }
}
