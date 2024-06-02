import 'package:clicksoutlet/main.dart';
import 'package:clicksoutlet/model/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCollectionService {
  final collectionReference =
      FirebaseFirestore.instance.collection(config.userCollection);

  Future<bool> addUpdateData(UserDetailsModel userDetailsModel) async {
    try {
      collectionReference.snapshots();
      await collectionReference
          .doc(userDetailsModel.userName)
          .set(userDetailsModel.toMap());
      print(
          '#####################################Data Added Successfully#####################################');
      return true;
    } catch (e) {
      print(
          "#####################################Operation Failed#############################################");
    }
    return false;
  }

  Future<UserDetailsModel?> fetchData(UserDetailsModel userDetailsModel) async {
    if (userDetailsModel.userName != null &&
        userDetailsModel.userName!.isEmpty) {
      return null;
    }
    final documentReference =
        collectionReference.doc(userDetailsModel.userName);
    final snapshot = await documentReference.get();
    if (snapshot.exists) {
      return UserDetailsModel.fromMap(map: snapshot.data());
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
