import 'package:clicksoutlet/View/screens/home.view.dart';
import 'package:clicksoutlet/config/config.dart';
import 'package:clicksoutlet/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final Config config = Config(userCollection: 'Dev Users', imageFolder: 'Dev');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  //_createNotificationChannel(id, name, description)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance
        .getToken()
        .then((value) => printInfo(info: "token---->$value"));
    return GetMaterialApp(
      title: 'Clicks Outlet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const Home(),
    );
  }
}
