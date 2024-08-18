// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';
import 'package:taxiassist/Utils/Buttons/round_button.dart';
import 'package:taxiassist/View/2.Authentication/OTP/otp.dart';

Widget loginWidget(CountryCode countryCode, Function onCountryChange, Function onSubmit) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
               Text(
                  "Add Phone Number",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor
                  ),
                ),
      
                const SizedBox(
                  height: 10,
                ),
      
                Text(
                  "We need to register your phone without getting started!",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
      
                const SizedBox(
                  height: 30,
                ),
      
                Container(
                  width: double.infinity,
                  height: 55,
      
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        spreadRadius: 3,
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
      
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () => onCountryChange(),
    
                          child: Container(
                            child: Row(
                              children: [
                          
                                Expanded(
                                  child: Container(
                                    child: countryCode.flagImage(),
                                  ),
                                ),
                          
                                Text(
                                  countryCode.dialCode,
                                ),
                          
                                const Icon(Icons.keyboard_arrow_down_rounded),
                          
                          
                              ],
                            ),
                          ),
                        ),
                      )  ,
      
                      Container(
                        width: 1,
                        height: 55,
                        color: AppColors.blackColor.withOpacity(0.2 ),
                      ),
      
                      Expanded(
                        flex: 3,
                        child: TextField(
                          onSubmitted: (String? input)=> onSubmit(input),
                            style: TextStyle(
                              color: AppColors.whiteColor,
                            ),
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.black
                          ),
                        )
                      )  
      
      
      
                    ]
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                
        ]
      ),
    ),
  );
}