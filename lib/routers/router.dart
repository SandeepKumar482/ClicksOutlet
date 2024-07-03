import 'package:apex_infinity/navigation/naviaftion_data.model.dart';
import 'package:clicks_outlet/View/screens/home.view.dart';
import 'package:clicks_outlet/routers/routes.config.dart';
import 'package:flutter/material.dart';

Widget? routeResolver(AxNaviagtionData naviagtionData) {
  RoutesConfig routesConfig = RoutesConfig();
  if (naviagtionData.path == routesConfig.initial ||
      naviagtionData.path == routesConfig.home) {
    return Home(
      section: naviagtionData.fragment,
    );
  }
  return null;
}
