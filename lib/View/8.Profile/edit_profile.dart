// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel userModel;

  EditProfilePage({required this.userModel});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _fullNameController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.userModel.fullname);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _selectProfilePicture() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final croppedFile = (await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 40,
        uiSettings: [
          AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        ]
      ));

      if (mounted && croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path);
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    String? imageUrl;

    if (_imageFile != null) {
      final Reference storageRef = FirebaseStorage.instance.ref()
        .child('Profile Pictures');
      final UploadTask uploadTask = storageRef.putFile(_imageFile!);
      final TaskSnapshot downloadUrl = await uploadTask;
      imageUrl = await downloadUrl.ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('Registered Users').doc(widget.userModel.uid).update({
      'fullname': _fullNameController.text,
      'profilePic': imageUrl,
    });

    widget.userModel.fullname = _fullNameController.text;
    widget.userModel.profilePic = imageUrl;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _selectProfilePicture,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(widget.userModel.profilePic ?? ''),
                child: _imageFile == null ? Icon(Icons.person, size: 60, color: Colors.white) : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
