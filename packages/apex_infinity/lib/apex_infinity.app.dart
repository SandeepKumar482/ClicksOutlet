library apex_infinity;

import 'package:apex_infinity/navigation/naviaftion_data.model.dart';
import 'package:apex_infinity/navigation/navigator.dart';
import 'package:flutter/material.dart';

class AxApp extends StatelessWidget {
  final Widget? unknowPageWidget;
  final String initialRoute;
  final Widget? Function(AxNaviagtionData naviaftionData) routeResolver;
  final ThemeData? themeData;

  const AxApp({
    this.initialRoute = "/",
    required this.routeResolver,
    this.themeData,
    this.unknowPageWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      navigatorKey: AxNaviagtion.navigationKey,
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    Route? route;
    final String? routePath = settings.name;
    if (routePath != null && routePath.isNotEmpty) {
      final Uri uri = Uri.parse(routePath);

      uri.path;

      List<String> pathSegments = [];
      for (String pathsegment in uri.pathSegments) {
        if (pathsegment.isNotEmpty) {
          pathSegments.add(pathsegment);
        }
      }

      AxNaviagtionData naviagtionData = AxNaviagtionData(
          path: uri.path,
          pathSegments: pathSegments,
          query: uri.query,
          queryParameters: uri.queryParameters,
          fragment: uri.fragment,
          extraArguments: settings.arguments == null
              ? const {}
              : settings.arguments as Map<String, dynamic>);

      Widget? page = routeResolver(naviagtionData);

      if (page != null) {
        route = MaterialPageRoute(builder: (ctx) {
          return Center(child: page);
        });
      }
    }
    return route;
  }

  Route<dynamic>? _onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (ctx) {
      return Center(child: unknowPageWidget ?? const Text("Page Not Found"));
    });
  }
}
