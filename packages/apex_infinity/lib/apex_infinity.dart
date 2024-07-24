import 'package:apex_infinity/http/request.dart';
import 'package:apex_infinity/navigation/navigator.dart';
import 'package:apex_infinity/theme/theme.dart';

const AxThemeData themeData = AxThemeData();

class Ax {
  static void goBack() {
    if (AxNaviagtion.navigationKey.currentState != null) {
      AxNaviagtion.navigationKey.currentState!.pop();
    }
  }

  static final AxHttpRequest httpRequest = AxHttpRequest();
}
