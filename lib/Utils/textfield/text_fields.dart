// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';


class MyTextField extends StatelessWidget {
  String? hintText;
  String? labelText;
  TextEditingController? controller;
   MyTextField({super.key, @required this.hintText, @required this.labelText, @required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
                      decoration: BoxDecoration(
                        
                        border: Border.all(width: 2), // Adjusted border color
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: TextFormField(    
                            controller: controller,

                            decoration: InputDecoration(
                              
                              labelText: labelText,
                              hintText: hintText, 
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
      ),
    );
  }
}