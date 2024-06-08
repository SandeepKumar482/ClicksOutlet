import 'package:clicksoutlet/utils/shared_preferrences.util.dart';

class UserDetailsModel {
  static const String spKey = 'user_data';

  final String? id;
  final String? email;
  final String? phone;
  final String? name;
  final String? userName;
  final String? profilePicture;
  final bool isDetailsCompleted;

  UserDetailsModel(
      {required this.id,
      required this.email,
      required this.phone,
      required this.name,
      required this.userName,
      this.profilePicture,
      this.isDetailsCompleted = false});

  Map<String, dynamic> toMap() => {
        "user_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "user_name": userName,
        "is_details_completed": isDetailsCompleted,
        "profile_picture": profilePicture
      };

  static UserDetailsModel fromMap({required Map<String, dynamic>? map}) {
    return UserDetailsModel(
      id: map?['user_id'],
      email: map?['email'],
      phone: map?['phone'],
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
