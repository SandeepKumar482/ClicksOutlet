import 'package:apex_infinity/apex_infinity.app.dart';
import 'package:apex_infinity/apex_infinity.dart';
import 'package:clicks_outlet/bloc/main.bloc.dart';
import 'package:clicks_outlet/config/config.dart';
import 'package:clicks_outlet/firebase_options.dart';
import 'package:clicks_outlet/model/package.model.dart';
import 'package:clicks_outlet/routers/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final Config config = kReleaseMode
  ? Config(
    baseUrl: "https://api.clicksoutlet.in",
    apiKey: 'adba4a4c24b866fa7a997f65009b0e255683f5f7'
  )
  :  Config(
    baseUrl: "https://slategray-peafowl-388760.hostingersite.com",
    apiKey: 'adba4a4c24b866fa7a997f65009b0e255683f5f7'
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  await Ax.sharedPreference.init();
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

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => MainCubit(),
      child: BlocConsumer<MainCubit,MainCubitState>(
        listener: (n,s){},
        builder: (BuildContext context,MainCubitState state) {
          return  AxApp(
            routeResolver: routeResolver,
            themeData: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.green,
            ),
          );
        },
      ) ,
    );
  }
}
