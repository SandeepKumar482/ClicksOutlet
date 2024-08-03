import 'package:apex_infinity/apex_infinity.app.dart';
import 'package:apex_infinity/apex_infinity.dart';
import 'package:clicks_outlet/config/config.dart';
import 'package:clicks_outlet/firebase_options.dart';
import 'package:clicks_outlet/model/package.model.dart';
import 'package:clicks_outlet/routers/router.dart';
import 'package:clicks_outlet/utils/shared_preferrences.util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final Config config = Config(
  baseUrl: "http://192.168.208.134:120",
  apiKey: 'adba4a4c24b866fa7a997f65009b0e255683f5f7'
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await SharedPreference.init();

await Ax.httpRequest.configRequest(
    baseUrl: config.baseUrl,
    headers: {
      'Content-Type': 'application/json',
      'api-key': config.apiKey,
    },
  );

  try {
    PackageInfoModel.init();
  } catch (e) {
    debugPrint("Package Info Error : $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance
        .getToken()
        .then((value) => debugPrint("token---->$value"));

    return AxApp(
      routeResolver: routeResolver,
      themeData: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
    );
  }
}
