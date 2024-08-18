// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';

class MyButton extends StatelessWidget {
  void Function()? ontap;
  final String text;
   MyButton({super.key, required this.ontap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,

      
      child: Container(
        width: 350,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.purpleColor,
          borderRadius: BorderRadius.circular(30),
          
        ),
        child: Center(
          child: Text(text.tr,style: TextStyle(color: AppColors.whiteColor),) ,
        ),
      ),
    );
  }
}