import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:taxiassist/View/infos_taxi_web_line/infos_paris_taxi.dart';

class AuthServiceUserLogin {
  final UserModel userModel;
  final UserModel targetUser;

  AuthServiceUserLogin(this.targetUser, {required this.userModel});

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the Google Sign In process
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection("Registered Users")
            .doc(uid)
            .get();

        if (!userData.exists) {
          // User is not registered, display a Get.snackbar with an error message
          Get.snackbar(
            "Login Error",
            "This email is not registered.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );

          return;
        }

        UserModel userModel =
            UserModel.frommap(userData.data() as Map<String, dynamic>);
        // Go to HomePage
        print("Log In Successful!");

        Get.to(() => TaxiInfoPage(userModel: userModel, targetUser: targetUser));
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }
}
