


import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/View/2.Authentication/Login/login.dart';


class SplashScreenController  {

final UserModel userModel;
final UserModel targetUser;


  SplashScreenController(this.targetUser, this.userModel,);

  void splashTimer() {
    
     Future.delayed(const Duration(seconds: 3), () async {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
          Get.to(() => Login_Page(
          userModel: userModel,
          targetUser: targetUser,
        ));
    // if (firebaseUser != null) {
    //     // User is logged in, navigate to homepage
    //     Get.to(() => TaxiInfoPage(
    //       userModel: userModel, 
    //       targetUser: targetUser,
    //     ));
    //   } else {
    //     // User is not logged in, navigate to login page
    //     Get.to(() => Login_Page(
    //       userModel: userModel,
    //       targetUser: targetUser,
    //     ));
    //   }
      
    });
  }
  
}