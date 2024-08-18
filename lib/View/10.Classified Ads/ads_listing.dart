// ignore_for_file: prefer_const_constructors, avoid_print, sized_box_for_whitespace

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';

import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/Appbar/myappbar.dart';
import 'package:taxiassist/Utils/BottomNavBar/bottomnavbar.dart';
import 'package:taxiassist/Utils/Buttons/round_button.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';
import 'package:taxiassist/Utils/Drawer/drawer.dart';
import 'package:taxiassist/Utils/textfield/text_fields.dart';
import 'package:taxiassist/View/3.%20Home_screen/events.dart';

class AdsListing extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;
  const AdsListing({
    Key? key,
    required this.userModel,
    required this.targetUser,
  }) : super(key: key);

  @override
  State<AdsListing> createState() => _AdsListingState();
}

class _AdsListingState extends State<AdsListing> {
  final fireStore = FirebaseFirestore.instance.collection("Classified_Ads");
  final fireStoreStream = FirebaseFirestore.instance.collection("Classified_Ads").orderBy('id' , descending: true).snapshots();
  final itemNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File? image) async {
    if (image == null) return null;
    final storageRef = FirebaseStorage.instance.ref().child('ads_images/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => {});
    return await snapshot.ref.getDownloadURL();
  }

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

  Future<void> _deleteAd(String adId) async {
    await fireStore.doc(adId).delete();
    Get.snackbar("Ad update".tr, "Deleted Successfully".tr);
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
                    'ajouter votre annonce'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                  )),
                  const SizedBox(height: 20),
                  MyTextField(
                      hintText: "023232",
                      labelText: 'Phone number'.tr,
                      controller: phoneNumberController),
                  MyTextField(
                      hintText: 'Car, wheels',
                      labelText: "Items".tr,
                      controller: itemNameController),
                  IconButton(
                      icon: Icon(Icons.add_a_photo, 
                      ),
                      onPressed: _pickImage),
                  _imageFile != null
                      ? Image.file(_imageFile!, height: 150)
                      : Container(
                        child : Center(
                          child: Text("No Image")
                        ),
                      ),
                  MyButton(
                      ontap: () async {
                        var currentTime = DateTime.now();
                        var formattedTime = "${currentTime.hour}:${currentTime.minute}";
                        var formattedDate = "${currentTime.day}/${currentTime.month}/${currentTime.year}";
                        String? imageUrl = await _uploadImage(_imageFile);
                        var id = DateTime.now().microsecondsSinceEpoch.toString();
                        fireStore.add({
                          "id": id,
                          "profile_name": currentUser!.displayName,
                          "user_id": currentUser.uid,
                          "item_name": itemNameController.text,
                          "phone_number": phoneNumberController.text,
                          "image_url": imageUrl ?? '',
                          "date": formattedDate,
                          "time": formattedTime
                        });
                        Get.snackbar("Ad uploaded", "Thanks for listing your ad");
                        Get.to(() => Home_Page(userModel: widget.userModel, targetUser: widget.targetUser));
                      },
                      text: "Submit"),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: MyAppbar(
        title: "Classified ADS".tr,
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
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return  Center(
                      child: Text("No ads found".tr),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var adData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        String adId = snapshot.data!.docs[index].id;
                        String imageUrl = adData.containsKey('image_url') && adData['image_url'].isNotEmpty ? adData['image_url'] : 'default_image_url';
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 350,
                              height: 230,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: 120,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          image: imageUrl != 'default_image_url'
                                              ? DecorationImage(
                                                  image: NetworkImage(imageUrl),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(adData['item_name'] ?? 'No item name',
                                            style: const TextStyle(fontSize: 18)),
                                        Text(adData['phone_number'] ?? 'No phone number',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Text(adData['date'] ?? 'No date',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Text(adData['time'] ?? 'No time',
                                            style: const TextStyle(fontSize: 16)),
                                        if (currentUser!.uid == adData['user_id'])
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => _deleteAd(adId),
                                          ),
                                      ],
                                    ),
                                  )
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
