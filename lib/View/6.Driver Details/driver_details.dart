// ignore_for_file: unused_import, unnecessary_import, non_constant_identifier_names, avoid_print, prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/Appbar/myappbar.dart';
import 'package:taxiassist/Utils/BottomNavBar/bottomnavbar.dart';
import 'package:taxiassist/Utils/Buttons/map_button.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';
import 'package:taxiassist/Utils/Drawer/drawer.dart';
import 'package:taxiassist/Utils/textfield/text_fields.dart';
import 'package:taxiassist/View/5.Get_Your_Fair/get_your_fare.dart';

class LocationPage extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;
  final String driver_name;
  final String driver_pfp;
  final String location_adrress;
  final String number_of_passengers;
  final String Latitude;
  final String Longitude;

  const LocationPage({
    Key? key,
    required this.driver_name,
    required this.location_adrress,
    required this.number_of_passengers,
    required this.Latitude,
    required this.Longitude,
    required this.userModel,
    required this.targetUser,
    required this.driver_pfp, 
  }) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(24.8846, 67.1754),
    zoom: 16,
  );
  final List<Marker> _marker = [];

  final List<Marker> _list = [
    const Marker(
      markerId: MarkerId("1"),
      position: LatLng(24.8846, 70.1754),
      infoWindow: InfoWindow(title: "Current Location"),
    )
  ];
  String stAddress = '';

  TextEditingController num_of_passengers = TextEditingController();
  var dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
    // Convert latitude and longitude strings to double
    double latitude = double.parse(widget.Latitude);
    double longitude = double.parse(widget.Longitude);
    // Define the new camera position
    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 16,
    );
    // Animate the camera to the new position
    _animateCameraToPosition(initialCameraPosition);
  }

  Future<void> _animateCameraToPosition(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "Driver's Location".tr),
      
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: kGooglePlex,
          markers: Set<Marker>.of(_marker),
          myLocationEnabled: true,
          trafficEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: MapButton(
          text: "Driver Details".tr,
          ontap: () async {
            getUserCurrentLocation().then((value) async {
              print("My Location");
              print(dateTime);
              print("${value.latitude} ${value.longitude}");
              _marker.add(Marker(
                markerId: const MarkerId("2"),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: const InfoWindow(title: "My Location"),
              ));

              List<Placemark> placemarks = await placemarkFromCoordinates(
                  value.latitude, value.longitude);
              stAddress =
                  "${placemarks.reversed.last.country} ${placemarks.reversed.last.locality} ${placemarks.reversed.last.street}";
              CameraPosition cameraPosition = CameraPosition(
                zoom: 16,
                target: LatLng(
                  value.latitude,
                  value.longitude,
                ),
              );
              final GoogleMapController controller =
                  await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});
            });
            Get.bottomSheet(
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 800,
                  width: MediaQuery.of(context).size.width,
                  color: Get.isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          
                          Text(
                            "More Details:".tr,
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Text(
                            "Name: ".tr,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),

                          SizedBox(
                            height: 10,
                          ),
                                      
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(widget.driver_pfp),
                              ),
                                      
                              SizedBox(
                                width: 10,
                              ),
                                      
                              Text(
                                widget.driver_name,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ]
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Text(
                            "Location Address: ".tr,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                      
                          Text(
                            widget.location_adrress,
                            style: TextStyle(fontSize: 20),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Row(
                            children: [
                              Text(
                                "Waiting Passengers: ".tr,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),

                              SizedBox(
                                width: 10,
                              ),

                              Text(
                                widget.number_of_passengers,
                                style: TextStyle(fontSize: 20),
                              ),
                            ]
                          )

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        userModel: widget.userModel, 
        targetUser: widget.targetUser
      ),
    );
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) {});
    return await Geolocator.getCurrentPosition();
  }
}
