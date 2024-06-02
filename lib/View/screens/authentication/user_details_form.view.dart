import 'package:clicksoutlet/FirebaseService/user_collection.service.dart';
import 'package:clicksoutlet/View/screens/home.view.dart';
import 'package:clicksoutlet/View/widgets/input.widget.dart';
import 'package:clicksoutlet/constants/style.dart';
import 'package:clicksoutlet/model/user_details.dart';
import 'package:clicksoutlet/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/custom_app_bar.widget.dart';

class UserDetailsForm extends StatelessWidget {
  const UserDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    UserCollectionService userCollectionService = UserCollectionService();

    final _formKey = GlobalKey<FormState>();
    TextEditingController _name = TextEditingController();
    TextEditingController _userName = TextEditingController();

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
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InputWidget(
                            label: "User Name",
                            controller: _userName,
                            validator: (value) {
                              if (value!
                                      .isEmpty /*||
                                    userCollectionService
                                        .isUserNameAlreadyExist(
                                            UserDetailsModel(
                                                userName: value,
                                                labelName: "")) as bool*/
                                  ) {
                                return 'Please Enter a Valid user_name ';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20.0),
                          InputWidget(
                            label: "Name",
                            controller: _name,
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
                          const SizedBox(height: 20.0),
                          SizedBox(height: deviceHeight * 0.02),
                          SizedBox(
                            width: deviceWidth * 0.65, // 60% of device width
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  try {
                                    bool isAlreadyExist =
                                        false; /*userCollectionService
                                        .isUserNameAlreadyExist(
                                            UserDetailsModel(
                                                userName: _userName,
                                                labelName: _labelName)) as bool;*/
                                    if (isAlreadyExist) {
                                      Utils.getSnacbar(
                                          "User Name Already Exist",
                                          "Try another one");
                                    } else {
                                      Future<bool> isAdded =
                                          userCollectionService.addUpdateData(
                                              UserDetailsModel(
                                                  id: "sd",
                                                  name: _name.text,
                                                  userName: _userName.text));
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
                              ),
                              child: const Text('Submit'),
                            ),
                          )
                        ])))));
  }
}
