import 'dart:io';

import 'package:apex_infinity/apex_infinity.dart';
import 'package:apex_infinity/http/response.dart';
import 'package:apex_infinity/layout/future.layout.dart';
import 'package:apex_infinity/navigation/navigator.dart';
import 'package:clicks_outlet/View/widgets/input.widget.dart';
import 'package:clicks_outlet/bloc/main.bloc.dart';
import 'package:clicks_outlet/config/api.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/custom_app_bar.widget.dart';

class RegisterView extends StatefulWidget {
  final String urlPath;
  final Map<String, String> queryParams;

   const RegisterView(
      {super.key, required this.urlPath, this.queryParams = const {}});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  Future<dynamic> Function()?  apiData;

  @override
  void initState() {
    apiData = ()=> Ax.httpRequest.get(url: APIConfig.register,params: widget.queryParams);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final MainCubit mainCubit = context.read<MainCubit>();

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final formKey = GlobalKey<FormState>();
    final ImagePicker _picker = ImagePicker();
    bool isUserNameExists = false;
    XFile? profileImage;

    TextEditingController labelName = TextEditingController();
    TextEditingController userName = TextEditingController();
    TextEditingController email = TextEditingController();

    bool isImageUploading = false;
    bool isSubmitting = false;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const CustomAppBar(
          word1: "Clicks",
          word2: "Outlet",
        ),
      ),
      body: AxFutureBuilder(
        future: apiData,
        childBuilder: (data) {
          return StatefulBuilder(builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                          onTap: () async {
                            profileImage = await _picker.pickImage(
                                source: ImageSource.gallery);
                            state(() {});
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.greenAccent,
                            backgroundImage: profileImage?.path != null
                                ? Image.file(File(profileImage!.path)).image
                                : NetworkImage(
                                    "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-High-Quality-Image.png"),
                            radius: 50.0,
                            child: profileImage?.path != null
                                ? null
                                : const Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 20.0,
                                  ),
                          )),
                      InputWidget(
                        label: "User Name",
                        //initialValue: data['user_name'],
                        controller: userName,
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (value!.isEmpty && value.length < 4) {
                            return "Please Enter a Valid User Name";
                          } else {
                            return null;
                          }
                        },
                        onChange: (value) {
                          if (isUserNameExists) {
                            setState(() {
                              isUserNameExists = false;
                            });
                          }
                        },
                      ),
                      if (isUserNameExists)
                        const Text(
                          "User Name Already Taken",
                          style: TextStyle(color: Colors.red),
                        ),
                      InputWidget(
                        label: "Label Name",
                        // initialValue: data['label_name'],
                        controller: labelName,
                        prefixIcon: const Icon(Icons.label_important_outline),
                        validator: (value) {
                          if (value!.isEmpty && value.length < 4) {
                            return "Please Enter a Valid Label Name";
                          } else {
                            return null;
                          }
                        },
                      ),
                      InputWidget(
                        label: "Email",
                        initialValue: data['email'],
                        controller: data['email'] != null ? null : email,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (value) {
                          if (value!.isEmpty && value.length < 4) {
                            return "Please Enter a Valid Label Name";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20.0),
                      FilledButton(
                        onPressed: isImageUploading || isSubmitting
                            ? null
                            : () async {
                                // TODO : Upload User Image
                                 await Ax
                                    .httpRequest
                                    .post(url: APIConfig.register, body: {
                                  'email_id': data['email'],
                                  'user_name': userName.text,
                                  'label_name': labelName.text,
                                  'profile_picture': profileImage?.path,
                                  'auth_provider': data['auth_provider']
                                },
                                  isFollowRedirect: true
                                );
                                mainCubit.getUserData();
                              },
                        child: Text(isImageUploading
                            ? "Uploading image ..."
                            : isSubmitting
                                ? "Subitting ..."
                                : 'Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
