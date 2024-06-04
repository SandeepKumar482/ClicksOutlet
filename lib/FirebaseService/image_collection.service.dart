import 'dart:io';

import 'package:clicksoutlet/main.dart';
import 'package:clicksoutlet/model/click.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageCollectionService {
  final collectionReference =
      FirebaseFirestore.instance.collection(config.imageCollection);

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

  Future<QuerySnapshot<Map<String, dynamic>>> getImages() async {
    return collectionReference.get();
  }

  Future<void> downloadAndSaveImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/my_image.jpg');
      await file.writeAsBytes(response.bodyBytes);
      // Show a success message or update UI accordingly
    } else {
      // Handle error (e.g., show an error message)
    }
  }
}
