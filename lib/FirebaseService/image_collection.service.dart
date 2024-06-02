import 'package:clicksoutlet/main.dart';
import 'package:clicksoutlet/model/click.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
}
