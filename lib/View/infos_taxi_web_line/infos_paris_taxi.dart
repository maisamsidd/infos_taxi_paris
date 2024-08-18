// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:taxiassist/Models/User_Model/usermodel.dart';
import 'package:taxiassist/Utils/Appbar/myappbar.dart';
import 'package:taxiassist/Utils/BottomNavBar/bottomnavbar.dart';
import 'package:taxiassist/Utils/Drawer/drawer.dart';
import 'package:taxiassist/View/infos_taxi_web_line/infos_tax_lines.dart';

class TaxiInfoPage extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;
  
  const TaxiInfoPage({
    Key? key,
    required this.userModel,
    required this.targetUser,
 
  }) : super(key: key);
  @override
  _TaxiInfoPageState createState() => _TaxiInfoPageState();
}

class _TaxiInfoPageState extends State<TaxiInfoPage> {
  final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onHttpError: (HttpResponseError error) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://infotaxi.parisaeroport.fr/?')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://infotaxi.parisaeroport.fr/?'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      floatingActionButton: FloatingActionButton(onPressed: (){
        Get.to(() => NoOfLines(userModel: widget.userModel , targetUser: widget.targetUser,));
      },child: const Icon(Icons.line_style),),
     body: WebViewWidget(controller: controller),
     drawer:MyDrawer(targetUser: widget.targetUser,userModel: widget.userModel,),
     appBar: MyAppbar(
        title: "Info taxi ".tr,
      ),
     
     bottomNavigationBar: MyBottomNavBar(
        userModel: widget.userModel, 
        targetUser: widget.targetUser
      ),
      
      
    );
  }
}
