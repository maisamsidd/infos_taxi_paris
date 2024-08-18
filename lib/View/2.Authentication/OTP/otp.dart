// // ignore_for_file: unused_import, must_be_immutable

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';
// import 'package:taxiassist/Controller/auth_controller.dart';
// import 'package:taxiassist/Model/User_Model/usermodel.dart';
// import 'package:taxiassist/Resources/Widgets/pinputwidget.dart';
// import 'package:taxiassist/Utils/app_color/app_colors.dart';
// import 'package:taxiassist/Utils/button/round_button.dart';
// import 'package:taxiassist/View/Home_screen/OTP/phone.dart';
// import 'package:taxiassist/View/Home_screen/Home_page.dart';

// class MyVerify extends StatefulWidget {

//   String phoneNumber;
//   MyVerify(this.phoneNumber);

//   @override
//   State<MyVerify> createState() => _MyVerifyState();
// }

// class _MyVerifyState extends State<MyVerify> {

//   final FirebaseAuth auth = FirebaseAuth.instance;
  
//   AuthController authController = Get.put(AuthController());

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     authController.phoneAuth(widget.phoneNumber);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final defaultPinTheme = PinTheme(
//     //   width: 56,
//     //   height: 56,
//     //   textStyle: const TextStyle(
//     //       fontSize: 20,
//     //       color: Color.fromRGBO(30, 60, 87, 1),
//     //       fontWeight: FontWeight.w600),
//     //   decoration: BoxDecoration(
//     //     border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
//     //     borderRadius: BorderRadius.circular(20),
//     //   ),
//     // );

//     // final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//     //   border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
//     //   borderRadius: BorderRadius.circular(8),
//     // );

//     // final submittedPinTheme = defaultPinTheme.copyWith(
//     //   decoration: defaultPinTheme.decoration?.copyWith(
//     //     color: const Color.fromRGBO(234, 239, 243, 1),
//     //   ),
//     // );
//     // var code = "";

//     return Scaffold(
//       backgroundColor: AppColors.blackColor,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: AppColors.blackColor,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios_rounded,
//             color: Colors.black,
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: Container(
//         margin: const EdgeInsets.only(left: 25, right: 25),
//         alignment: Alignment.center,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
              
//               const SizedBox(
//                 height: 25,
//               ),
//               const Text(
//                 "OTP",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text(
//                 "We need to register your phone without getting started!",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 30,
//               ),

//               PinputExample(),
//               // Pinput(
//               //   length: 6,
//               //   showCursor: true,
//               //   onChanged: (value) {
//               //     code = value;
//               //   },
//               //   // onCompleted: (pin) => print(pin),
//               // ),
//               const SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: MyButton(
//                   ontap: () async{
//                     // PhoneAuthCredential credential = PhoneAuthProvider.credential(
//                     //   verificationId: Phone.verify, 
//                     //   smsCode:
//                     //   );

//                     // await auth.signInWithCredential(credential);
//                     Get.to(() => const Home_Page());
//                   }, 
//                   text: "Verify Phone Number",
//                 ),
                
//               ),
//               Row(
//                 children: [
//                   TextButton(
//                       onPressed: () {
//                         Get.to(() => const Phone(
//                           // userModel: widget.userModel, 
//                           // firebaseUser: widget.firebaseUser, 
//                           // targetUser: widget.targetUser,
//                         ));
//                       },
//                       child: Text(
//                         "Edit Phone Number ?",
//                         style: TextStyle(color: AppColors.whiteColor),
//                       ))
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }