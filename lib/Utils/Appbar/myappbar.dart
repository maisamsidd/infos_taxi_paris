// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxiassist/Controller/Themes/Themes.dart';

class MyAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  MyAppbar({super.key, required this.title});

  @override
  State<MyAppbar> createState() => _MyAppbarState();
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppbarState extends State<MyAppbar> {
  final ThemeController themeController = Get.find<ThemeController>();
  
  // String selectedLanguage = 'French';
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      automaticallyImplyLeading: true,
      elevation: 1,
      centerTitle: true,
      title: Text(
        widget.title.tr,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      actions: [

        IconButton(
          onPressed: () {
            setState(() {
              if (selectedLanguage == 'English') {
                selectedLanguage = 'French';
                Get.updateLocale(Locale('fr', 'FR'));
              } else {
                selectedLanguage = 'English';
                Get.updateLocale(Locale('en', 'US'));
              }
              print('Selected Language: $selectedLanguage');
            });
          },
          icon: Icon(Icons.language),
        ),

        IconButton(
          onPressed: () {
            themeController.toggleTheme();
          },
          icon: Icon(Icons.light_mode_outlined),
        ),
      ],
    );
  }
}
