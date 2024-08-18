// ignore_for_file: unused_import, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxiassist/Push%20Notifications/messagingservice.dart';
import 'package:taxiassist/View%20Model/localization/localization.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Controller/Themes/Themes.dart';
import 'package:taxiassist/View/1.Splash_screen/splash_screen.dart';
import 'package:taxiassist/firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MobileAds.instance.initialize();
  MessagingService().initialize();
  MessagingService().subscribeToTopic();
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseUser;
  final UserModel? targetUser;

  MyApp({Key? key, this.userModel, this.targetUser, this.firebaseUser}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final lightTheme = ThemeData(
    brightness: Brightness.light,
  );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Language(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: Splash_Screen(
        userModel: widget.userModel ?? UserModel(),
        targetUser: widget.targetUser ?? UserModel(),
      ),
    );
  }
}
