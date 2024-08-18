// // ignore_for_file: unused_import

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_country_code_picker/fl_country_code_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taxiassist/Model/User_Model/usermodel.dart';
// import 'package:taxiassist/Resources/Widgets/loginwidget.dart';
// import 'package:taxiassist/Utils/app_color/app_colors.dart';
// import 'package:taxiassist/Utils/button/round_button.dart';
// import 'package:taxiassist/View/Home_screen/OTP/otp.dart';

// class Phone extends StatefulWidget {
//   const Phone({Key? key}) : super(key: key);
//   // const Phone({Key? key, required this.userModel, required this.firebaseUser, required this.targetUser}) : super(key: key);

//   // final UserModel userModel;
//   // final User firebaseUser;
//   // final UserModel targetUser;
//   static String verify="";

//   @override
//   State<Phone> createState() => _PhoneState();
// }

// class _PhoneState extends State<Phone> {

//   final countryPicker = const FlCountryCodePicker();

//   CountryCode countryCode = const CountryCode(name: 'pakistan', code: 'PK', dialCode: '+92');

//   onSubmit(String? input){
//     Get.to(() =>MyVerify(countryCode.dialCode+input!));
//   }
//   // TextEditingController countryController = TextEditingController();
  

//   @override
//   // void initState() {
//   //   TODO: implement initState
//   //   countryController.text = "+92";
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.blackColor,
//       body: Container(
//         margin: const EdgeInsets.only(left: 25, right: 25),
//         alignment: Alignment.center,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [

              
//               loginWidget(countryCode, ()async {
//                 final code = await countryPicker.showPicker(context: context);
//                 if (code != null) countryCode = code;
//                 setState(() {
                  
//                 });
//               },onSubmit),


//               // SizedBox(
//               //   width: double.infinity,
//               //   height: 45,
//               //   child: MyButton(
//               //     ontap: () async {
//               //       await FirebaseAuth.instance.verifyPhoneNumber(
//               //         phoneNumber: '${countryController.text + (widget.userModel.phoneNumber ?? '')}',
//               //         verificationCompleted: (PhoneAuthCredential credential) {},
//               //         verificationFailed: (FirebaseAuthException e) {},
//               //         codeSent: (String verificationId, int? resendToken) {
//               //           Phone.verify = verificationId;
//               //           Get.to(() => MyVerify(
//               //             userModel: widget.userModel, 
//               //             firebaseUser: widget.firebaseUser, 
//               //             targetUser: widget.targetUser, 
//               //           ));
//               //         },
//               //         codeAutoRetrievalTimeout: (String verificationId) {},
//               //       );

                    
//               //     }, 
//               //     text: "Send the code",
//               //   ),
//               // )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }