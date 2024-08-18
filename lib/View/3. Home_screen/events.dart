import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/Appbar/myappbar.dart';
import 'package:taxiassist/Utils/BottomNavBar/bottomnavbar.dart';
import 'package:taxiassist/Utils/Colors/app_colors.dart';
import 'package:taxiassist/Utils/Drawer/drawer.dart';

class Home_Page extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;

  const Home_Page({Key? key, required this.userModel, required this.targetUser}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: "Events".tr,
      ),
      drawer: MyDrawer(targetUser: widget.targetUser, userModel: widget.userModel),
      body: Column(
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
              stream: FirebaseFirestore.instance.collection('admin_panel_events').snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var event = snapshot.data.docs[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/finalbg.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.event_available_outlined,
                              color: AppColors.whiteColor,
                              size: 25,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Event: ${event['event_name']}".tr,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.whiteColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Date: ${event['event_date']}".tr,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: AppColors.whiteColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Time: ${event['time']}".tr,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: AppColors.whiteColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Passagers attendus: ${event['expected_passengers']}".tr,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.whiteColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    "Emplacement: ${event['location']}".tr,
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar(
        userModel: widget.userModel,
        targetUser: widget.targetUser,
      ),
    );
  }
}
