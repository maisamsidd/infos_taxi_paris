// ignore_for_file: unused_import, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:taxiassist/View/4.Share_Information/google_map.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';
import 'package:taxiassist/View/Rides/rides.dart';
import 'package:taxiassist/View/10.Classified%20Ads/ads_listing.dart';
import 'package:taxiassist/View/5.Get_Your_Fair/get_your_fare.dart';
import 'package:taxiassist/View/3.%20Home_screen/events.dart';
import 'package:taxiassist/View/8.Profile/profile.dart';
import 'package:taxiassist/View/infos_taxi_web_line/infos_paris_taxi.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyBottomNavBar extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;
  MyBottomNavBar({super.key, required this.userModel, required this.targetUser});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      
          showSelectedLabels: true,
          showUnselectedLabels: true,
          // backgroundColor: Get.isDarkMode ? AppColors.blackColor : AppColors.blackColor, 
         
          type: BottomNavigationBarType.shifting,
          iconSize: 30,
          elevation: 2,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.taxi_alert),
              label: 'Infos taxi'.tr,
              
            ),
            
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Events'.tr,
              
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.announcement),
              label: 'Share Info'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_pin),
              label: 'Get Fare'.tr,
            ),
           
            BottomNavigationBarItem(
              icon: Icon(Icons.handshake),
              label: 'Classified ADS'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.car_rental),
              label: 'Rides'.tr,
            ),
            
          ],
          selectedItemColor: AppColors.purpleColor, 
          unselectedItemColor: AppColors.purpleColor, 
          onTap: (index){
            switch (index) {
              case 0:
                Get.to(()=>TaxiInfoPage(userModel: widget.userModel, targetUser: widget.targetUser));
                break;
              case 1:
                Get.to(() => Home_Page(
                  userModel: widget.userModel,
                  targetUser: widget.targetUser,           
                ));
                break;
        
              case 2:
                Get.to(() => GoogleMaps(
                    userModel: widget.userModel,
                    targetUser: widget.targetUser,
                  ));
                break;
        
              case 3:
                 Get.to(() => CustomerLocationNumbers(
                    targetUser: widget.targetUser,
                    userModel: widget.userModel,
                  
                  ));
                break;
        
              case 4: 
             

                Get.to(() => AdsListing(userModel: widget.userModel, targetUser: widget.userModel,));
                break;

                case 5:
                Get.to(() => Rides(userModel: widget.userModel, targetUser: widget.targetUser));
                break;
             
        
              
            }
          },
          
        
        );
  }
}