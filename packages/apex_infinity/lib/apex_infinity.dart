import 'package:apex_infinity/http/request.dart';
import 'package:apex_infinity/navigation/navigator.dart';
import 'package:apex_infinity/theme/theme.dart';
import 'package:apex_infinity/utils/shared_prefernce.util.dart';

const AxThemeData themeData = AxThemeData();

class Ax {
  static void goBack() {
    if (AxNaviagtion.navigationKey.currentState != null) {
      AxNaviagtion.navigationKey.currentState!.pop();
    }
  }

  static final AxHttpRequest httpRequest = AxHttpRequest();
  static final AxSharedPreference sharedPreference = AxSharedPreference();
}

extension AxE on dynamic {
  double? toDouble(){
    try {
      return double.parse(this.toString());
    } on Exception {
      return null;
    }
  }
}