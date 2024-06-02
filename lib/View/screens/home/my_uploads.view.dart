import 'dart:io';

import 'package:clicksoutlet/FirebaseService/image_collection.service.dart';
import 'package:clicksoutlet/View/screens/authentication/auth.view.dart';
import 'package:clicksoutlet/View/widgets/input.widget.dart';
import 'package:clicksoutlet/main.dart';
import 'package:clicksoutlet/model/click.model.dart';
import 'package:clicksoutlet/model/user_details.dart';
import 'package:clicksoutlet/utils/floating_msg.util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class MyUploads extends StatefulWidget {
  const MyUploads({super.key});

  @override
  State<MyUploads> createState() => _MyUploadsState();
}

class _MyUploadsState extends State<MyUploads> {
  List<ImageModel> imageList = [];

  late Widget addPhotoIcon;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    addPhotoIcon = FloatingActionButton(
      onPressed: () async {
        UserDetailsModel userDetailsModel = UserDetailsModel.fromSP();

        if (userDetailsModel.id == null) {
          showDialog(
              context: context,
              builder: (ctx) {
                return const Auth();
              });
        } else {
          await selectAnduploadImage();
        }
      },
      child: const Icon(
        Icons.add_a_photo_outlined,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (imageList.isEmpty) {
      return Center(
        child: addPhotoIcon,
      );
    } else {
      return const Text("sds");
    }
  }

  Future<void> selectAnduploadImage() async {
    PermissionStatus status = await Permission.photos.status;
    if (status.isGranted) {
      XFile? selectedImage =
          await _picker.pickImage(source: ImageSource.gallery);

      if (selectedImage != null) {
        openAddClickBottomSheet(
            context: context, imagePath: selectedImage.path);
      } else {
        FloatingMsg.show(
            context: context,
            msg: "Please Select A Image",
            msgType: MsgType.error);
      }
    } else {
      PermissionStatus requestStatus = await Permission.photos.request();
      if (requestStatus.isGranted) {
      } else {
        FloatingMsg.show(
            context: context,
            msg: "Please Allow Photos First",
            msgType: MsgType.error);
      }
    }
  }

  Future<void> openAddClickBottomSheet({
    required BuildContext context,
    required String imagePath,
  }) {
    File file = File(imagePath);
    final formKey = GlobalKey<FormState>();

    final TextEditingController caption = TextEditingController();
    final TextEditingController tags = TextEditingController();
    double? uploadPercentage;

    return showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        useSafeArea: true,
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (context, bottomSheetSate) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.file(file),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      InputWidget(
                        label: "Caption",
                        controller: caption,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      InputWidget(
                        label: "Tags",
                        controller: tags,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      if (uploadPercentage != null)
                        LinearProgressIndicator(
                          value: uploadPercentage,
                        ),
                      FilledButton(
                        onPressed: () async {
                          final UploadTask uploadTask =
                              await uploadImage(file: file);

                          uploadTask.snapshotEvents
                              .listen((TaskSnapshot snapshotEvents) async {
                            switch (snapshotEvents.state) {
                              case TaskState.paused:
                                uploadPercentage = null;
                                break;
                              case TaskState.running:
                                bottomSheetSate(() {
                                  uploadPercentage =
                                      snapshotEvents.bytesTransferred /
                                          snapshotEvents.totalBytes;
                                });
                                break;
                              case TaskState.success:
                                final String imageUrl =
                                    await snapshotEvents.ref.getDownloadURL();

                                UserDetailsModel userData =
                                    UserDetailsModel.fromSP();
                                ImageModel imageModel = ImageModel(
                                  userId: userData.id,
                                  userName: userData.name,
                                  url: imageUrl,
                                  caption: caption.text,
                                  tags: [tags.text],
                                );

                                bool isUploaded = await ImageCollectionService()
                                    .addImage(imageModel);

                                FloatingMsg.show(
                                  context: context,
                                  msg: isUploaded
                                      ? "Image Uploaded"
                                      : "Unable to Upload Image",
                                  msgType: isUploaded
                                      ? MsgType.success
                                      : MsgType.error,
                                );
                                Get.back();

                                break;
                              case TaskState.canceled:
                                uploadPercentage = null;
                                break;
                              case TaskState.error:
                                uploadPercentage = null;
                                FloatingMsg.show(
                                    context: context,
                                    msg:
                                        "Something went Wrong While Uploading!!!",
                                    msgType: MsgType.error);
                                Get.back();

                                break;
                            }
                          });
                        },
                        child: const Text("Upload"),
                      ),
                      const SizedBox(
                        height: 25.0,
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<UploadTask> uploadImage({required File file}) async {
    UploadTask uploadTask;

    String fileName = DateTime.now().toString();
    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(config.imageFolder)
        .child(fileName);

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(file.path), metadata);
    }

    return uploadTask;
  }
}
