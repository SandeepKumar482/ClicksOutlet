import 'package:clicksoutlet/utils/shared_preferrences.util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsModel {
  static const String spKey = 'user_data';

  final String? id;
  final String? name;
  final String? userName;
  final String? profilePicture;
  final bool isDetailsCompleted;

  UserDetailsModel(
      {required this.id,
      required this.name,
      required this.userName,
      this.profilePicture,
      this.isDetailsCompleted = false});

  Map<String, dynamic> toMap() => {
        "user_id": id,
        "name": name,
        "user_name": userName,
        "is_details_completed": isDetailsCompleted,
        "profile_picture": profilePicture
      };

  static UserDetailsModel fromMap({required Map<String, dynamic>? map}) {
    return UserDetailsModel(
      id: map?['user_id'],
      name: map?['name'],
      userName: map?['user_name'],
      isDetailsCompleted: map?['is_details_completed'] ?? false,
      profilePicture: map?['profile_picture'],
    );
  }

  factory UserDetailsModel.fromSP() {
    Map<String, dynamic> data = PreferenceUtils.getJson(UserDetailsModel.spKey);
    return UserDetailsModel.fromMap(map: data);
  }

  Future<bool> setToSP() async {
    return PreferenceUtils.setJson(UserDetailsModel.spKey, toMap());
  }
}
