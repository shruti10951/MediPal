// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:medipal/user_registration/enter_otp_dependent_screen.dart';
// //
// // class DependentLogin extends StatelessWidget {
// //
// //   final nameController = TextEditingController();
// //   final phoneController = TextEditingController();
// //
// //   final auth = FirebaseAuth.instance;
// //
// //   //show loading
// //   bool isSigningUp = false;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // TODO: implement build
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Login'),
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(20.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             TextField(
// //               decoration: InputDecoration(
// //                 labelText: 'Name',
// //               ),
// //               controller: nameController,
// //             ),
// //             SizedBox(height: 20.0),
// //             TextField(
// //               decoration: InputDecoration(
// //                 labelText: 'Phone Number',
// //               ),
// //               controller: phoneController,
// //             ),
// //             SizedBox(height: 20.0),
// //             ElevatedButton(
// //               onPressed: () async {
// //                 // Add your sign-up logic here
// //                 isSigningUp = true;
// //                 verify(context, phoneController.text);
// //               },
// //               child: isSigningUp == true
// //                   ? CircularProgressIndicator(
// //                 color: Colors.black,
// //               )
// //                   : Text('Sign Up'),
// //               style: ButtonStyle(
// //                 fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
// //                 backgroundColor: MaterialStateProperty.all(Colors.cyan),
// //                 foregroundColor: MaterialStateProperty.all(Colors.white),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   verify(context, phoneNumber) async {
// //     isSigningUp = false;
// //     await auth.verifyPhoneNumber(
// //         phoneNumber: '+91' + phoneNumber,
// //         verificationCompleted: (PhoneAuthCredential credential) {},
// //         verificationFailed: (FirebaseAuthException e) {},
// //         codeSent: (String verificationId, int? resendToken) {
// //           Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                   builder: (context) =>
// //                       OTPForDependentPage(verificationId: verificationId, name: nameController.text, phoneNo: phoneController.text,)));
// //         },
// //         codeAutoRetrievalTimeout: (String verificationId) {});
// //   }
// // }
//
// Widget _buildLoadingIndicator() {
// return const Center(
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(
//           Color.fromARGB(255, 71, 78, 84),
//         ),
//       ),
//       SizedBox(height: 16.0),
//       Text(
//         'Loading...',
//         style: TextStyle(
//           fontSize: 16.0,
//           fontWeight: FontWeight.bold,
//           color: Colors.grey,
//         ),
//       ),
//     ],
//   ),
// );
// }