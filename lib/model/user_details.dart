import 'package:apex_infinity/apex_infinity.dart';
import 'package:clicks_outlet/config/api_cache.config.dart';
import 'package:clicks_outlet/main.dart';

class UserDetailsModel {
  final String? id;
  final String? labelName;
  final String? userName;
  final String? emailId;
  final String? mobile;
  final String? profilePicture;

  UserDetailsModel(
      {required this.id,
      required this.labelName,
      required this.userName,
      required this.emailId,
      required this.mobile,
      required this.profilePicture});

  Map<String, dynamic> toMap() => {
        "id": id,
        "label_name": labelName,
        "user_name": userName,
        "emailId": userName,
        "mobile": mobile,
        "profile_picture": profilePicture
      };

  static UserDetailsModel fromMap({required Map<String, dynamic>? map}) {
    return UserDetailsModel(
      id: map?['id']?.toString(),
      labelName: map?['label_name'],
      userName: map?['user_name'],
      emailId: map?['emailId'],
      mobile: map?['mobile'],
      profilePicture: map?['profile_picture'] ?? config.previewImageUrl,
    );
  }

  factory UserDetailsModel.fromSP() {
    Map<String, dynamic> data =
    Ax.sharedPreference.getJson(key: CacheKeys.userData);
    return UserDetailsModel.fromMap(map: data);
  }

  Future<bool> setToSP() async {
    return Ax.sharedPreference.setJson(
        key: CacheKeys.userData, value: toMap());
  }
}
