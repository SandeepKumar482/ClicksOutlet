import 'package:apex_infinity/apex_infinity.dart';

class AxRequestCacheRule {
  final String key;
  final Duration duration;

  AxRequestCacheRule({
    required this.key,
    required this.duration
  });

  bool isDataExists() {
    return Ax.sharedPreference.isKeyExits(key: key);
  }

  bool isDataExpired() {

    bool isExpired =  true;
    if(Ax.sharedPreference.isKeyExits(key: key)) {
     final  Map<String,dynamic> data = Ax.sharedPreference.getJson(key: key);

     if(data['expiry'] != null) {
       isExpired = DateTime.parse(data['expiry']).isBefore(DateTime.now());
     }
    }


    return isExpired;
  }

  Future<bool> setData({required Map<String,dynamic> data}) {
    return Ax.sharedPreference.setJson(key: key,value: {
      'expiry' : DateTime.now().add(duration).toString(),
      'data' : data
    });
  }

  Map<String,dynamic> getData() {
    return Ax.sharedPreference.getJson(key: key)['data'] ?? {};
  }

  Future<bool> clearData() {
    return Ax.sharedPreference.clearData(key: key);
  }

}