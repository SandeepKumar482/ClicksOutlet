import 'package:apex_infinity/navigation/naviaftion_data.model.dart';
import 'package:clicks_outlet/View/screens/home.view.dart';
import 'package:clicks_outlet/routers/routes.config.dart';
import 'package:flutter/material.dart';

import '../View/screens/authentication/register.view.dart';

Widget? routeResolver(AxNaviagtionData navigationData) {
  if (navigationData.path == RoutesConfig.initial ||
      navigationData.path == RoutesConfig.home) {
    return Home(
      section: navigationData.fragment,
    );
  } else if (navigationData.path == RoutesConfig.register) {
    return RegisterView(urlPath: navigationData.path,queryParams: navigationData.queryParameters,);
  }
  return null;
}
