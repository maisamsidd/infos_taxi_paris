import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taxiassist/Controller/Splash_Screen/splash_screen_controller.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';


class Splash_Screen extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;

  const Splash_Screen({super.key, required this.userModel, required this.targetUser});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  
  @override
  void initState() {
    super.initState();
    final splashScreen = SplashScreenController(widget.userModel, widget.targetUser);
    splashScreen.splashTimer();

    // Check authentication status after a short delay
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildUi(),
    );
  }

  Widget buildUi() {
    return Center(
      child: Lottie.asset("assets/Animations/taxi_loading.json", repeat: true),
    );
  }
}