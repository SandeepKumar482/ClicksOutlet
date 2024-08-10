import 'package:apex_infinity/apex_infinity.dart';
import 'package:clicks_outlet/config/shared_preferences.Config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoModel {
  String? version;
  String? build;

  PackageInfoModel({this.version, this.build});

  static Future<void> init() async {
    await PackageInfo.fromPlatform().then((value) async {
      PackageInfoModel packageInfoModel =
          PackageInfoModel(version: value.version, build: value.buildNumber);
      if (!Ax.sharedPreference.isKeyExits(key: SharedPreferenceKey.packageInfo)) {
        await Ax.sharedPreference.clearData();
      }
      await Ax.sharedPreference.setJson(
          key: SharedPreferenceKey.packageInfo,
          value: packageInfoModel.toJson());
    });
  }

  PackageInfoModel.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    build = json['build'];
  }

  static PackageInfoModel fromSP() {
    Map<String, dynamic> parseData =
    Ax.sharedPreference.getJson(key: SharedPreferenceKey.packageInfo);

    return PackageInfoModel.fromJson(parseData);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['version'] = version;
    data['build'] = build;
    return data;
  }
}
