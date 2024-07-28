import 'package:apex_infinity/layout/future.layout.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.widget.dart';

class RegisterView extends StatelessWidget {
  final String urlPath;
  final Map<String,String> queryParams;
  const RegisterView({
    super.key,
    required this.urlPath,
    this.queryParams = const {}
});

  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const CustomAppBar(
          word1: "Clicks",
          word2: "Outlet",
        ),
      ),
      body: AxFutureBuilder(
        url: urlPath,
        queryParameters: queryParams,
        childBuilder: (data) {
          return Text(data.toString());
        },
      ),
    );
  }
}
