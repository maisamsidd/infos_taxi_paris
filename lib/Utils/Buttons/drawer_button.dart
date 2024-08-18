import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';


class MyDrawerButton extends StatelessWidget {
  final void Function()? ontap;
  final String text1;
   const MyDrawerButton({super.key, required this.ontap, required this.text1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: ontap,
      
        
        child: Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.purpleColor,
            borderRadius: BorderRadius.circular(30),
            
          ),
          child: Center(
            child: Text(text1.tr ,style: TextStyle(color: AppColors.whiteColor),) ,
          ),
        ),
      ),
    );
  }
}