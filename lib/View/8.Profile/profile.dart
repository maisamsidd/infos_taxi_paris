// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taxiassist/View/4.Share_Information/google_map.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/Appbar/myappbar.dart';
import 'package:taxiassist/Utils/BottomNavBar/bottomnavbar.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';
import 'package:taxiassist/Utils/Drawer/drawer.dart';
import 'package:taxiassist/View/10.Classified%20Ads/ads_listing.dart';
import 'package:taxiassist/View/5.Get_Your_Fair/get_your_fare.dart';
import 'package:taxiassist/View/3.%20Home_screen/events.dart';
import 'package:taxiassist/View/1.Splash_screen/splash_screen.dart';
import 'package:taxiassist/View/8.Profile/edit_profile.dart';
import 'package:taxiassist/View/infos_taxi_web_line/infos_paris_taxi.dart';


class SettingsPage extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;

  SettingsPage(
      {Key? key,
      required this.userModel,
      required this.targetUser})
      : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppbar(title: "Profile".tr),
        
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      

                      GestureDetector(
                        onTap: (){
                          Get.to(() => EditProfilePage(userModel: widget.userModel));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.edit,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Edit Profile".tr)
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),

                  

                  SizedBox(
                    height: 5,
                  ),

                   CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      widget.userModel.profilePic.toString(),
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  Text(
                    widget.userModel.fullname ?? 'User',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Text(
                    widget.userModel.email ?? 'Email',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.purpleColor),
                  ),

                  SizedBox(
                    height: 20,
                  ),
 
                  Container(
                    height: 90,
                    width: double.infinity,
                    child: Column(children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Quick Links".tr,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      ListTile(
                        leading: Icon(
                          Icons.event_note_outlined,
                          size: 40,
                        ),
                        title: InkWell(
                          onTap: () {
                            Get.to(() => Home_Page(
                              userModel: widget.userModel, 
                              targetUser: widget.targetUser
                            ));
                          },
                          child: Text(
                            "Events".tr,
                            style: TextStyle(),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                      )
                    ]),
                  ),

                  Container(
                    height: 200,
                    width: double.infinity,
                    child: Column(children: [
                      Column(
                        children: [

                          ListTile(
                            onTap: (){
                              Get.to(() => GoogleMaps(
                                userModel: widget.userModel,
                                targetUser: widget.targetUser,
                              ));
                            },
                            leading: Icon(
                              Icons.share_location_outlined,
                              size: 40,
                            ),
                            title: Text(
                              "Share Information".tr,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                          ),

                          SizedBox(
                            height: 7,
                          ),

                          ListTile(
                            onTap: (){
                              Get.to(() => CustomerLocationNumbers(
                                targetUser: widget.targetUser,
                                userModel: widget.userModel,
                              ));
                            },
                            leading: Icon(
                              Icons.policy_outlined,
                              size: 40,
                            ),
                            title: Text(
                              "Get Fare".tr,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                          ),

                          SizedBox(
                            height: 7,
                          ),
                          ListTile(
                            onTap: () async {
                              await GoogleSignIn().signOut();

                              await FirebaseAuth.instance.signOut();

                              _auth.signOut();

                              Get.to(() => Splash_Screen(
                                userModel: UserModel(),
                                targetUser: UserModel(),
                              ));
                            },
                            leading: Icon(
                              Icons.logout,
                              size: 40,
                            ),
                            title: Text(
                              "Logout".tr,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                          )
                        ],
                      )
                    ]),
                  ),

                  Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.purpleColor),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    height: 90,
                    width: double.infinity,
                    child: Column(children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Infos taxi".tr,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Get.to(() => TaxiInfoPage(userModel: widget.userModel, targetUser: widget.userModel,));
                        },
                        leading: Icon(
                          Icons.contacts,
                          size: 40,
                        ),
                        title: Text(
                          "Taxir information".tr,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: MyBottomNavBar(
          userModel: widget.userModel,
          targetUser: widget.targetUser
          ),
      ),
    );
  }
}
