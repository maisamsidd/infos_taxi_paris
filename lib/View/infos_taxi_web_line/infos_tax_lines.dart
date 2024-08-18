import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/BottomNavBar/bottomnavbar.dart';
import 'package:taxiassist/Utils/Buttons/round_button.dart';
import 'package:taxiassist/Utils/textfield/text_fields.dart';

class NoOfLines extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;
  const NoOfLines({
    Key? key,
    required this.userModel,
    required this.targetUser,
  }) : super(key: key);

  @override
  State<NoOfLines> createState() => _NoOfLinesState();
}

class _NoOfLinesState extends State<NoOfLines> {
  final fireStore = FirebaseFirestore.instance.collection("No_of_lines");
  final fireStoreStream = FirebaseFirestore.instance.collection("No_of_lines").snapshots();
  final noOfLinesController = TextEditingController();
  final phoneNumberController = TextEditingController();
  File? _imageFile;
  String? selectedAirport;
  String? selecteLines;
  User user = FirebaseAuth.instance.currentUser!;

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
              color: Get.isDarkMode ? Colors.black : Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Center(
                        child: Text(
                      "ajouter votre annonce".tr,
                      style: TextStyle(
                        fontSize: 24,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    )),
                    const SizedBox(height: 20),
                   MyTextField(
                      hintText: "2",
                      labelText: 'ajouter votre annonce'.tr,),
                        const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButtonFormField<String>(
                            value: selectedAirport,
                            hint: Text(
                              "CDG / Orly".tr,
                              style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                selectedAirport = newValue;
                              });
                            },
                            items: <String>['CDG', 'Orly'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.tr,
                                  style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      ontap: () async {
                        var currentTime = DateTime.now();
                        var formattedTime = "${currentTime.hour}:${currentTime.minute}";
                        var formattedDate = "${currentTime.day}/${currentTime.month}/${currentTime.year}";

                        final currentAuth = user.displayName ?? 'Unknown User';

                        fireStore.add({
                          "profile_name": currentUser?.displayName ?? 'No display name',
                          "item_name": selecteLines,
                          "current_user": currentAuth,
                          "date": formattedDate,
                          "time": formattedTime,
                          "passengers": selectedAirport,
                        });
                        Get.snackbar("Ad uploaded", "Thanks for listing your ad");
                      },
                      text: "Submit",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title:  Text("ajouter votre annonce".tr),
      ),
      body: Container(
        child: Column(
          children: [
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
                      child: Text("No lines found".tr),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var adData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ajouter votre annonce :${adData['item_name'] ?? 'No item name'}",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          "Nom d'utilisateur : ${adData['current_user'] ?? 'Unknown User'}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "Date: ${adData['date'] ?? 'No date'}",
                                          style: const TextStyle(),
                                        ),
                                        Text(
                                          "Time: ${adData['time'] ?? 'No time'}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "Taper: ${adData['passengers'] ?? 'Airport'}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
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
      bottomNavigationBar: MyBottomNavBar(
        userModel: widget.userModel,
        targetUser: widget.targetUser,
      ),
    );
  }
}
