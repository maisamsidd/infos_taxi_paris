// ignore_for_file: unused_import, prefer_const_constructors, camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Controller/Themes/Themes.dart';
import 'package:taxiassist/Resources/Widgets/loginwidget.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';
import 'package:taxiassist/Utils/Buttons/round_button.dart';
import 'package:taxiassist/Controller/Authentication/GoogleAuth/auth_service.dart';
import 'package:taxiassist/View/2.Authentication/OTP/otp.dart';
import 'package:taxiassist/View/2.Authentication/OTP/phone.dart';
import 'package:taxiassist/View/2.Authentication/Register/register.dart';

class  Login_Page extends StatefulWidget {
  
  final UserModel userModel;
  final  firebaseUser = FirebaseAuth.instance.currentUser;
  final UserModel targetUser;  
  Login_Page({super.key, required this.userModel,  required this.targetUser,  });

  @override
  State<Login_Page> createState() => _Login_PageState();
}
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class _Login_PageState extends State<Login_Page> {
  // final countryPicker = const FlCountryCodePicker();
  // CountryCode countryCode = const CountryCode(name: 'pakistan', code: 'PK', dialCode: '+92');

  @override
  void initState() {
    // firebaseAuth.authStateChanges().listen((event) {
    //   setState(() {
    //     _user = event;
    //   });
    // })
    super.initState();
  }
  @override
  Widget build(BuildContext context) {   
    return  Scaffold(
      body:  SafeArea(
          child: Center(
            child: Column(
              children: [

                Image.asset("assets/images/Overlay.png"),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Infos ".tr,
                      style: TextStyle(
                        color: AppColors.purpleColor,
                        fontSize: 40, 
                        fontWeight: FontWeight.w900
                      )
                    ),

                   Text("Driver".tr,
                      style: TextStyle(
                        fontSize: 40, 
                        fontWeight: FontWeight.w900
                      )
                    ),
                  ],
                ),

                const SizedBox(height: 50),

               Text("L'Application du ".tr,
                    style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.w800
                  )
                ),

               Text("Taxi Parisien".tr,
                    style: TextStyle(
                    fontSize: 25, 
                    fontWeight: FontWeight.w400
                  )
                ),

                const SizedBox(
                  height: 70,
                ),

                MyButton(
                  ontap: () {
                    AuthServiceUserLogin(
                      widget.targetUser, 
                      userModel:  widget.userModel, 
                    
                    ).signInWithGoogle();
                  },
                  text: "Login with Google".tr,
                ),             

                SizedBox(height: MediaQuery.of(context).size.height*0.02,),

                SizedBox(
                  height: MediaQuery.of(context).size.height*0.04,
                ),

                GestureDetector(
                  onTap: () {
                    Get.to(() => Register_Page(
                      targetUser: UserModel(), 
                      userModel:  UserModel(), 
                      
                    ));
                  },
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),

                  Text("Register Now".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),),
                    ]
                  )
                ),

              ],
            ),
          ),
       ),
      
    );
  }
}