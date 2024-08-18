// ignore_for_file: unused_import, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_print, sort_child_properties_last, must_be_immutable
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxiassist/Models/UI_Helper/uihelper.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/Buttons/round_button.dart';
import 'package:taxiassist/View/3.%20Home_screen/events.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class DetailsPage extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;

  DetailsPage({required this.userModel, required this.targetUser});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  File? imageFile;
    TextEditingController fullNameController = TextEditingController();

  // final _formKey = GlobalKey<FormState>();
  // String fullname = '';

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = (await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 40,
    ));

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture".tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select from Gallery".tr),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a photo".tr),
                ),
              ],
            ),
          );
        });
  }

  void checkValues() {
  String fullname = fullNameController.text.trim();

  if (fullname.isEmpty) {
    print("Please fill all the fields");
    UIHelper.showAlertDialog(context, "Incomplete Data",
        "Please fill all the fields");
  } else {
    print("Uploading data..");
    uploadData();
  }
}

void uploadData() async {
  UIHelper.showLoadingDialog(context, "Uploading data..");

  String? imageUrl;
  if (imageFile != null) {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("Profile Pictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    imageUrl = await snapshot.ref.getDownloadURL();
    
  }

  String? fullname = fullNameController.text.trim();

  widget.userModel.fullname = fullname;
  widget.userModel.profilePic = imageUrl;


  await FirebaseFirestore.instance
      .collection("Registered Users")
      .doc(widget.userModel.uid)
      .set(widget.userModel.tomap(), SetOptions(merge: true))
      .then((value) {
    print("Data uploaded!");
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return Home_Page(
            userModel: widget.userModel, 
            targetUser: widget.targetUser);
      }),
    );
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text("Complete Your Profile".tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              CupertinoButton(
                onPressed: () {
                  showPhotoOptions();
                },
                child: CircleAvatar(
                  backgroundImage:
                      (imageFile != null) ? FileImage(imageFile!) : null,
                  child: (imageFile == null)
                      ? Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                  radius: 50,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name".tr,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyButton(
                  text: "Done!".tr,
                  ontap: () {
                    checkValues();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}