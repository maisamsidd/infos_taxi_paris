// ignore_for_file: unused_import, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/View/2.Authentication/OTP/phone.dart';
import 'package:taxiassist/View/2.Authentication/Register/moredetails.dart';
import 'package:taxiassist/View/3.%20Home_screen/events.dart';
import 'package:taxiassist/View/infos_taxi_web_line/infos_paris_taxi.dart';

class AuthServiceUserLogin {
  final UserModel userModel;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final UserModel targetUser;

  AuthServiceUserLogin(this.targetUser,  {required this.userModel});

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the Google Sign In process
        return;
      }

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

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

        Get.to(() => TaxiInfoPage(userModel: userModel, targetUser: targetUser,));
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }
}

// class AuthServiceUserRegister {
//   final UserModel userModel;
//   final firebaseUser = FirebaseAuth.instance.currentUser;
//   final UserModel targetUser;

//   AuthServiceUserRegister(this.targetUser, 
//       {required this.userModel, });

//   void signInWithGoogle() async {
//     try {
//       GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       if (googleUser == null) {
//         // User canceled the Google Sign In process
//         return;
//       }

//       GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

//       AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);

//       if (userCredential.user != null) {
//         String uid = userCredential.user!.uid;
//         UserModel newUser = UserModel(
//           uid: firebaseUser?.uid ?? '',
//           email: FirebaseAuth.instance.currentUser?.email ?? '',
//           fullname: FirebaseAuth.instance.currentUser?.displayName ?? '',
//           profilePic: FirebaseAuth.instance.currentUser?.photoURL ?? '',
//         );
//         await FirebaseFirestore.instance
//             .collection("Registered Users")
//             .doc(uid)
//             .set(newUser.tomap())
//             .then((value) {
//           print("New User Created!");
//         });

//         print("Log In Successful!");

//         Get.to(() => Home_Page(
//           userModel: userModel, 
//           targetUser: targetUser
//         )
//        );
//       }
//     } catch (error) {
//       print("Error signing in with Google: $error");
//     }
//   }
// }

class AuthServiceUserRegister {
  final UserModel userModel;
  final UserModel targetUser;

  AuthServiceUserRegister(this.targetUser, {required this.userModel});

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
        UserModel newUser = UserModel(
          uid: uid,
          email: userCredential.user!.email!,
        );

        // Set user data in Firestore
        await FirebaseFirestore.instance
            .collection("Registered Users")
            .doc(uid)
            .set(newUser.tomap(), SetOptions(merge: true))
            .then((value) {
          print("New User Created with Email Only!");
        });

        print("Log In Successful!");

        Get.to(() => DetailsPage(
          targetUser: targetUser,
          userModel: newUser, 
        ));
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }
}
