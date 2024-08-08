import 'package:apex_infinity/navigation/navigation_data.model.dart';
import 'package:clicks_outlet/View/screens/home.view.dart';
import 'package:clicks_outlet/routers/routes.config.dart';
import 'package:flutter/material.dart';

import '../View/screens/authentication/register.view.dart';

Widget? routeResolver(AxNavigationData navigationData) {
  if (navigationData.path == RoutesConfig.initial ||
      navigationData.path == RoutesConfig.home ||
      navigationData.path == RoutesConfig.trending ||
      navigationData.path == RoutesConfig.liked ||
      navigationData.path == RoutesConfig.myUploads ||
      navigationData.path == RoutesConfig.myAccount
  ) {
    return Home(navigationData: navigationData,);
  } else if (navigationData.path == RoutesConfig.register) {
    return RegisterView(urlPath: navigationData.path,queryParams: navigationData.queryParameters,);
  }
  return null;
}
