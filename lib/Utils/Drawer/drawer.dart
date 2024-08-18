// ignore_for_file: unused_import

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:taxiassist/Models/User_Model/usermodel.dart";
import "package:taxiassist/Controller/Themes/Themes.dart";
import "package:taxiassist/Utils/Colors/app_colors.dart";
import "package:taxiassist/Utils/Buttons/drawer_button.dart";
import "package:taxiassist/Utils/Buttons/round_button.dart";
import "package:taxiassist/View/1.Splash_screen/splash_screen.dart";
import "package:taxiassist/View/3.%20Home_screen/events.dart";
import "package:taxiassist/View/4.Share_Information/google_map.dart";
import "package:taxiassist/View/5.Get_Your_Fair/get_your_fare.dart";
import "package:taxiassist/View/8.Profile/profile.dart";
import "package:taxiassist/View/Rides/rides.dart";
import "package:taxiassist/View/10.Classified%20Ads/ads_listing.dart";
import "package:taxiassist/View/infos_taxi_web_line/infos_paris_taxi.dart";


class MyDrawer extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;
  
 const MyDrawer({super.key, required this.userModel,  required this.targetUser});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  
  get _auth => FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: DrawerHeader(child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 70),

            CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      widget.userModel.profilePic.toString(),
                    ),
                  ),

            
            SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

                 Text(
                    widget.userModel.fullname ?? 'User',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),

            const SizedBox(height: 30),
            MyDrawerButton(ontap: (){
              Get.to(() => SettingsPage(
                  userModel: widget.userModel, 
                  targetUser: widget.targetUser
                  ));
            }, text1: "Profile".tr),

            MyDrawerButton(ontap: (){
              Get.to(() => GoogleMaps(
                userModel: widget.userModel,
                targetUser: widget.targetUser,
              ));

            }, text1: "Share Information".tr),


            MyDrawerButton(ontap: (){
              Get.to(() => CustomerLocationNumbers(
                targetUser: widget.targetUser,
                userModel: widget.userModel,
                

              ));
            }, text1: "Get fare".tr),

            MyDrawerButton(ontap: (){
              Get.to(() => AdsListing(userModel: widget.userModel, targetUser: widget.targetUser));

            }, text1: "Classified ADS".tr),
            MyDrawerButton(ontap: (){
              Get.to(() => TaxiInfoPage(userModel: widget.userModel, targetUser: widget.targetUser));
            }, text1: "Infos taxi".tr),
            MyDrawerButton(ontap: (){
              Get.to(() => Home_Page(userModel: widget.userModel, targetUser: widget.targetUser));
            }, text1: "Events".tr),
            
            MyDrawerButton(ontap: (){
              Get.to(() => Rides(userModel: widget.userModel, targetUser: widget.targetUser));
            }, text1: "Rides".tr)

           

            
          ],
        ),),
        
      
    );
  }
}