import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/Appbar/myappbar.dart';
import 'package:taxiassist/Utils/BottomNavBar/bottomnavbar.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';
import 'package:taxiassist/Utils/Drawer/drawer.dart';
import 'package:taxiassist/View/6.Driver%20Details/driver_details.dart';

class CustomerLocationNumbers extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;

  const CustomerLocationNumbers({
    Key? key,
    required this.userModel,
    required this.targetUser,
  }) : super(key: key);

  @override
  _CustomerLocationNumbersState createState() =>
      _CustomerLocationNumbersState();
}

class _CustomerLocationNumbersState extends State<CustomerLocationNumbers> {
  final userAppointments = FirebaseFirestore.instance
      .collection("customers_location_name") .orderBy('time', descending: true)
      .snapshots();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final CollectionReference<Map<String, dynamic>> locationsCollection =
      FirebaseFirestore.instance.collection("marked_locations");

  void resetRequests() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('customers_location_name').get();

    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  late BannerAd bannerAd;
  bool isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    initializeBanner();
    initializeInter();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    if (isInterAd) {
      interstitialAd.dispose();
    }
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

  late InterstitialAd interstitialAd;
  bool isInterAd = false;

  void initializeInter() async {
    await InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          setState(() {
            isInterAd = true;
          });
        },
        onAdFailedToLoad: (error) {
          print(error);
          setState(() {
            isInterAd = false;
          });
        },
      ),
    );
  }

  void updateMarkCount(String docId, bool isVerified) async {
    DocumentReference docRef = locationsCollection.doc(docId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        if (isVerified) {
          transaction.set(docRef, {
            'verified_count': 1,
            'not_verified_count': 0,
            'user_selection': isVerified,
            'user_ids': [auth.currentUser!.uid],
          });
        } else {
          transaction.set(docRef, {
            'verified_count': 0,
            'not_verified_count': 1,
            'user_selection': isVerified,
            'user_ids': [auth.currentUser!.uid],
          });
        }
        return;
      }

      List userIds = List.from(snapshot['user_ids'] ?? []);
      bool? userSelection = userIds.contains(auth.currentUser!.uid);

      if (userSelection != isVerified) {
        if (userSelection == true && isVerified == false) {
        transaction.update(docRef, {
          'verified_count': FieldValue.increment(-1),
          'not_verified_count': FieldValue.increment(1),
          'user_selection': false,
          'user_ids': FieldValue.arrayRemove([auth.currentUser!.uid]),
        });
        transaction.update(docRef, {
          'user_ids': FieldValue.arrayUnion([auth.currentUser!.uid]),
        });
      } else if (userSelection == false && isVerified == true) {
        transaction.update(docRef, {
          'not_verified_count': FieldValue.increment(-1),
          'verified_count': FieldValue.increment(1),
          'user_selection': true,
          'user_ids': FieldValue.arrayRemove([auth.currentUser!.uid]),
        });
        transaction.update(docRef, {
          'user_ids': FieldValue.arrayUnion([auth.currentUser!.uid]),
        });
      }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "Get Your Fare".tr),
      drawer:MyDrawer(targetUser: widget.targetUser,userModel: widget.userModel,),
      body: SafeArea(
        child: Column(
          children: [
            if (isBannerLoaded)
              SizedBox(
                height: 50,
                child: AdWidget(ad: bannerAd),
              ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: userAppointments,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if(snapshot.data == null || snapshot.data!.docs.isEmpty){
                    return Center(child: Text('No Fares yet'.tr));

                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final String infoDriverName = doc["driver_name"];
                      final String profilePic = doc["driver_pfp"] ?? "";
                      final String infoMapLocationAddress = doc["map_location_address"];
                      final String numOfPassengers = doc["num_of_passengers"];
                      final String latitude = doc["latitude"];
                      final String longitude = doc["longitude"];

                      final String docId = doc.id;

                      return StreamBuilder<DocumentSnapshot>(
                        stream: locationsCollection.doc(docId).snapshots(),
                        builder: (context, locationSnapshot) {
                          int verifiedCount = 0;
                          int notVerifiedCount = 0;
                          bool? userSelection;
                          if (locationSnapshot.hasData && locationSnapshot.data!.exists) {
                            verifiedCount = locationSnapshot.data!['verified_count'] ?? 0;
                            notVerifiedCount = locationSnapshot.data!['not_verified_count'] ?? 0;
                            userSelection = locationSnapshot.data!['user_selection'];
                          }

                          return GestureDetector(
                            onTap: () {
                              if (isInterAd) {
                                interstitialAd.show();
                              }

                              Get.to(() => LocationPage(
                                driver_pfp: profilePic,
                                driver_name: infoDriverName,
                                location_adrress: infoMapLocationAddress,
                                number_of_passengers: numOfPassengers,
                                Latitude: latitude,
                                Longitude: longitude,
                                userModel: widget.userModel,
                                targetUser: widget.targetUser,
                              ));
                            },
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Container(
                                    height: 170,
                                    width: 395,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.blackColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 20),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(profilePic),
                                            ),
                                            Text(
                                              infoDriverName,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                infoMapLocationAddress,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Passengers: $numOfPassengers".tr,
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    snapshot.data!.docs[index]['date'],
                                                  ),
                                                  Text("  Time: ".tr + doc['time']),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: userSelection == true ? null : () {
                                                      updateMarkCount(docId, true);
                                                    },
                                                    icon: Icon(
                                                      Icons.check,
                                                      color: userSelection == true ? Colors.green : Colors.grey,
                                                    ),
                                                  ),
                                                  Text('$verifiedCount'),
                                                  IconButton(
                                                    onPressed: userSelection == false ? null : () {
                                                      updateMarkCount(docId, false);
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: userSelection == false ? Colors.red : Colors.grey,
                                                    ),
                                                  ),
                                                  Text('$notVerifiedCount'),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
          userModel: widget.userModel,
          targetUser: widget.targetUser
      ),
    );
  }
}
