import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsModel {
  final String userName;
  final String labelName;

  UserDetailsModel({required this.userName, required this.labelName});

  Map<String, String> toJson() =>
      {"userName": userName, "labelName": labelName};

  static UserDetailsModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserDetailsModel(
        userName: snapshot['userName'], labelName: snapshot['labelName']);
  }
}
