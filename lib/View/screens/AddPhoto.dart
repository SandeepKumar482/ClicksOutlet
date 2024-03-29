// ignore_for_file: file_names

import 'package:clicksoutlet/View/screens/ImageUploading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddPhoto extends StatelessWidget {
  const AddPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    ImagePicker imagePicker = ImagePicker();
    XFile? image;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 150,
                width: 150,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: const Center(
                        child: Icon(
                      Icons.add_a_photo_outlined,
                      size: 50,
                    )),
                    onPressed: () async {
                      /*var status = await Permission.photos.status;
                  print(status);
                  if (status.isDenied) {
                    // You can request the permission here
                    status = await Permission.photos.request();
                  }*/
                      image = (await imagePicker.pickImage(
                          source: ImageSource.gallery));
                      try {
                        Get.to(() => const ImageUploadScrn());
                      } catch (e) {
                        e.printError();
                      }
                    },
                  ),
                ),
              ),
              const Text(
                'Add Clicks',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              )
            ]),
      ),
    );
  }
}
