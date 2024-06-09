import 'dart:io';

import 'package:clicks_outlet/main.dart';
import 'package:clicks_outlet/model/click.model.dart';
import 'package:clicks_outlet/utils/shared_preferrences.util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ImageCollectionService {
  final collectionReference =
      FirebaseFirestore.instance.collection(config.imageCollection);
  static String trendingImgCachekey = 'trendingImage';
  static String myUploadImgCachekey = 'myUploads';

  Future<List<ImageModel>> getImages(
      {String? userId, bool isRefresh = false}) async {
    String cacheKey = userId != null && userId.isNotEmpty
        ? ImageCollectionService.myUploadImgCachekey
        : ImageCollectionService.trendingImgCachekey;
    List<ImageModel> imageList = [];

    Map<String, dynamic> imagesFromSp = PreferenceUtils.getJson(cacheKey);
    List<ImageModel> cacheImageList = [];

    if (imagesFromSp['images'] is List) {
      imagesFromSp['images'].forEach((t) {
        cacheImageList.add(ImageModel.fromMap(map: t));
      });
    }

    if (!isRefresh || cacheImageList.isEmpty) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = userId != null
          ? await collectionReference.where('user_id', isEqualTo: userId).get()
          : await collectionReference.limit(25).get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        imageList.add(ImageModel.fromMap(map: document.data()));
      }

      if (imageList.isNotEmpty) {
        List<Map> imageListMap = [];

        for (ImageModel img in imageList) {
          imageListMap.add(img.toMap());
        }

        await PreferenceUtils.setJson(cacheKey, {'images': imageListMap});
      } else {
        imageList = cacheImageList;
      }
    }

    return imageList;
  }

  Future<bool> addImage(ImageModel imageModel) async {
    try {
      collectionReference.snapshots();
      await collectionReference.doc().set(imageModel.toMap());
      debugPrint(
          '#####################################Data Added Successfully#####################################');
      return true;
    } catch (e) {
      debugPrint(
          "#####################################Operation Failed#############################################");
    }
    return false;
  }

  Future<void> downloadAndSaveImage(String imageUrl) async {
    // final response = await http.get(Uri.parse(imageUrl));
    // if (response.statusCode == 200) {
    //   final appDir = await getApplicationDocumentsDirectory();
    //   final file = File('${appDir.path}/my_image.jpg');
    //   await file.writeAsBytes(response.bodyBytes);
    //   // Show a success message or update UI accordingly
    // } else {
    //   // Handle error (e.g., show an error message)
    // }
  }

  static Future<String?> uploadImage(
      {required File? file, required String path}) async {
    String? donwloadUrl;
    if (file != null) {
      UploadTask uploadTask;

      String fileName = DateTime.now().toString();
      // Create a Reference to the file
      Reference ref =
          FirebaseStorage.instance.ref().child(path).child(fileName);

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path},
      );

      if (kIsWeb) {
        uploadTask = ref.putData(await file.readAsBytes(), metadata);
      } else {
        uploadTask = ref.putFile(File(file.path), metadata);
      }
      donwloadUrl = await uploadTask.then(<String>(TaskSnapshot s) {
        return s.ref.getDownloadURL();
      });
    }

    return donwloadUrl;
  }
}
