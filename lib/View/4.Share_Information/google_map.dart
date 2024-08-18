// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/BottomNavBar/bottomnavbar.dart';
import 'package:taxiassist/Utils/Buttons/map_button.dart';
import 'package:taxiassist/Utils/Buttons/round_button.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';
import 'package:taxiassist/View/5.Get_Your_Fair/get_your_fare.dart';

class GoogleMaps extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;
  GoogleMaps({super.key, required this.userModel, required this.targetUser});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(48.86, 2.3514),
    zoom: 16,
  );
  final List<Marker> _marker = [];
  final List<Marker> _list = [
    Marker(
        markerId: const MarkerId("1"),
        position: const LatLng(48.86, 2.3514),
        infoWindow: InfoWindow(title: "Current Location".tr))
  ];
  String stAddress = '';
  String Latitude = " ";
  String Longitude = " ";  
  String? selectedPassengers;
  TextEditingController location_name = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection("customers_location_name");
  var time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
  }

  Future<Position> getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, prompt user to enable it.
      Get.defaultDialog(
        title: "Location Services Disabled",
        middleText: "Please enable location services.",
        onConfirm: () => Geolocator.openLocationSettings(),
        onCancel: () => Get.back(),
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, prompt user to enable it.
        Get.defaultDialog(
          title: "Location Permission Denied",
          middleText: "Please enable location permissions in settings.",
          onConfirm: () => Geolocator.openAppSettings(),
          onCancel: () => Get.back(),
        );
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, prompt user to enable it.
      Get.defaultDialog(
        title: "Location Permission Permanently Denied",
        middleText: "Please enable location permissions in settings.",
        onConfirm: () => Geolocator.openAppSettings(),
        onCancel: () => Get.back(),
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: kGooglePlex,
          markers: Set<Marker>.of(_marker),
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: MapButton(
          text: "Let others know".tr,
          ontap: () async {
            try {
              Position position = await getUserCurrentLocation();
              print("My Location".tr);
              print(time);
              print("${position.latitude} ${position.longitude}");
              _marker.add(Marker(
                markerId: const MarkerId("2"),
                position: LatLng(position.latitude, position.longitude),
                infoWindow: InfoWindow(title: "My Location".tr),
              ));
              Latitude = position.latitude.toString();
              Longitude = position.longitude.toString();

              List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
              stAddress = "${placemarks.reversed.last.country}, ${placemarks.reversed.last.locality}, ${placemarks.reversed.last.street}";

              CameraPosition cameraPosition = CameraPosition(
                zoom: 16,
                target: LatLng(position.latitude, position.longitude),
              );
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});

              Get.bottomSheet(
                Container(
                  height: 800,
                  color: Get.isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Share customer's details".tr,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: DropdownButtonFormField<String>(
                                value: selectedPassengers,
                                hint: Text("Waiting Customers".tr),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedPassengers = newValue;
                                  });
                                },
                                items: <String>['10+', '30+', '50+', '100+'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value.tr),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        MyButton(
                          ontap: () {
                            var currentTime = DateTime.now();
                            var formattedTime = "${currentTime.hour}:${currentTime.minute}";
                            var formattedDate = "${currentTime.day}/${currentTime.month}/${currentTime.year}";
                            var id = DateTime.now().microsecondsSinceEpoch.toString();
                            
                            fireStore.doc(id).set({
                              "driver_name": user!.displayName ?? "User unknown".tr,
                              "driver_pfp": user.photoURL ?? "unable to load image".tr,
                              "num_of_passengers": selectedPassengers ?? 'N/A',
                              "map_location_address": stAddress,
                              "date": formattedDate,
                              "time": formattedTime,
                              "latitude": Latitude,
                              "longitude": Longitude,
                            });

                            Get.snackbar("Success".tr, "Your information has been sent".tr);
                            Get.to(() => CustomerLocationNumbers(
                              userModel: widget.userModel,
                              targetUser: widget.targetUser,
                            ));
                          },
                          text: "SEND".tr,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } catch (e) {
              print(e);
            }
          },
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        userModel: widget.userModel, 
        targetUser: widget.targetUser
      ),
    );
  }
}
