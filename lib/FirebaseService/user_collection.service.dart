import 'package:clicks_outlet/main.dart';
import 'package:clicks_outlet/model/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCollectionService {
  final collectionReference =
      FirebaseFirestore.instance.collection(config.userCollection);

  Future<bool> addUpdateData(UserDetailsModel userDetailsModel) async {
    try {
      collectionReference.snapshots();
      await collectionReference
          .doc(userDetailsModel.id)
          .set(userDetailsModel.toMap());
      debugPrint(
          '#####################################Data Added Successfully#####################################');
      return userDetailsModel.setToSP();
    } catch (e) {
      debugPrint(
          "#####################################Operation Failed#############################################");
    }
    return false;
  }

  Future<UserDetailsModel?> fetchData({required String? userId}) async {
    if (userId != null && userId.isEmpty) {
      return null;
    }
    final document = await collectionReference.doc(userId).get();
    if (document.exists) {
      return UserDetailsModel.fromMap(map: document.data());
    }
    return null;
  }

  Future<bool> isUserNameAlreadyExist(UserDetailsModel userDetailsModel) async {
    if (userDetailsModel.userName != null &&
        userDetailsModel.userName!.isEmpty) {
      return false;
    }
    final documentReference =
        collectionReference.doc(userDetailsModel.userName);
    final snapshot = await documentReference.get();
    if (snapshot.exists) {
      return true;
    }
    return false;
  }
}
