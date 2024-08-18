// ignore_for_file: prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, unused_import

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/Appbar/myappbar.dart';
import 'package:taxiassist/Utils/BottomNavBar/bottomnavbar.dart';
import 'package:taxiassist/Utils/Buttons/round_button.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';
import 'package:taxiassist/Utils/Drawer/drawer.dart';
import 'package:taxiassist/Utils/textfield/text_fields.dart';
import 'package:taxiassist/View/3.%20Home_screen/events.dart';

class Rides extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;
  const Rides({
    Key? key,
    required this.userModel,
    required this.targetUser,
  }) : super(key: key);

  @override
  State<Rides> createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  final fireStore = FirebaseFirestore.instance.collection("rides");
  final fireStoreStream = FirebaseFirestore.instance.collection("rides").orderBy('id', descending: true).snapshots();
  final arrivalcityController = TextEditingController();
  final departureController = TextEditingController();
  final phoneNumberController = TextEditingController();

  late BannerAd bannerAd;
  bool isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    initializeBanner();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  void initializeBanner() async {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-3940256099942544/9214589741",
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            isBannerLoaded = false;
          });
          print(error);
        },
      ),
      request: const AdRequest(),
    );
    await bannerAd.load();
  }

  void _deleteRide(String docId) {
    fireStore.doc(docId).delete().then((_) {
      Get.snackbar("Deleted", "Your ride has been deleted");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to delete the ride");
    });
  }

  void _submitRide() async {
    if (departureController.text.isEmpty ||
        arrivalcityController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      Get.snackbar("Error", "Fields can't be empty");
      return;
    }

    var currentTime = DateTime.now();
    var formattedTime = "${currentTime.hour}:${currentTime.minute}";
    var formattedDate = "${currentTime.day}/${currentTime.month}/${currentTime.year}";
    var id = DateTime.now().microsecondsSinceEpoch.toString();

    fireStore.doc(id.toString()).set({
      "id": id,
      "phone_number": phoneNumberController.text,
      "profile_name": FirebaseAuth.instance.currentUser!.displayName,
      "ariv": arrivalcityController.text,
      "dep": departureController.text,
      "date": formattedDate,
      "time": formattedTime,
      "user_id": FirebaseAuth.instance.currentUser!.uid,
    });

    Get.snackbar("Ride uploaded".tr, "Thanks for listing your ride".tr);
    Get.to(() => Home_Page(userModel: widget.userModel, targetUser: widget.targetUser));
  }

  @override
  Widget build(BuildContext context) {
    final fireAuth = FirebaseAuth.instance;
    final currentUser = fireAuth.currentUser;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            Container(
              height: 600,
              color: Get.isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      "ajouter votre annonce".tr,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    hintText: "Paris",
                    labelText: "Departure city".tr,
                    controller: departureController,
                  ),
                  MyTextField(
                    hintText: "Paris",
                    labelText: "Arrival city".tr,
                    controller: arrivalcityController,
                  ),
                  MyTextField(
                    hintText: "023232",
                    labelText: "Phone number".tr,
                    controller: phoneNumberController,
                  ),
                  MyButton(
                    ontap: _submitRide,
                    text: "Submit",
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: MyAppbar(
        title: "Rides".tr,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            if (isBannerLoaded)
              SizedBox(
                height: 50,
                child: AdWidget(ad: bannerAd),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fireStoreStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Something went wrong".tr),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("No Rides found".tr),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var adData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        String docId = snapshot.data!.docs[index].id;
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: 350,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Departure city".tr + " :" + (adData['dep'] ?? 'No Departure'),
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Arrival city".tr + ' :' + (adData['ariv'] ?? 'No Location'),
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Phone number".tr + ' :' + (adData['phone_number'] ?? 'No phone number'),
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Date : " + (adData['date'] ?? 'No date'),
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Time : " + (adData['time'] ?? 'No time'),
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (adData['user_id'] == currentUser!.uid)
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteRide(docId),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(targetUser: widget.targetUser, userModel: widget.userModel),
      bottomNavigationBar: MyBottomNavBar(
        userModel: widget.userModel,
        targetUser: widget.targetUser,
      ),
    );
  }
}
