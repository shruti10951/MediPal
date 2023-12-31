// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:medipal/models/UserModel.dart';
// import 'package:medipal/user_registration/enter_otp_user_screen.dart';
//
// class SignUpPage extends StatelessWidget {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//
//   final auth = FirebaseAuth.instance;
//
//   //show loading
//   bool isSigningUp = false;
//
//   SignUpPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign Up'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Name',
//               ),
//               controller: nameController,
//             ),
//             SizedBox(height: 20.0),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Email',
//               ),
//               controller: emailController,
//             ),
//             SizedBox(height: 20.0),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//               ),
//               controller: phoneController,
//             ),
//             SizedBox(height: 20.0),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Password',
//               ),
//               controller: passwordController,
//               obscureText: true,
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () async {
//                 // Add your sign-up logic here
//                 isSigningUp = true;
//                 await auth
//                     .createUserWithEmailAndPassword(
//                     email: emailController.text,
//                     password: passwordController.text)
//                     .then((value) => verify(context, phoneController.text));
//               },
//               child: isSigningUp == true
//                   ? CircularProgressIndicator(
//                 color: Colors.black,
//               )
//                   : Text('Sign Up'),
//               style: ButtonStyle(
//                 fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
//                 backgroundColor: MaterialStateProperty.all(Colors.cyan),
//                 foregroundColor: MaterialStateProperty.all(Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   verify(context, phoneNumber) async {
//     isSigningUp = false;
//     await auth.verifyPhoneNumber(
//         phoneNumber: '+91' + phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) {},
//         verificationFailed: (FirebaseAuthException e) {},
//         codeSent: (String verificationId, int? resendToken) {
//           UserModel userModel = UserModel(userId: auth.currentUser!.uid,
//               email: emailController.text,
//               phoneNo: phoneNumber,
//               name: nameController.text,
//               role: 'Individual',
//               noOfDependents: 0,
//               dependents:[]);
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       OTPForUserPage(verificationId: verificationId, userModel: userModel)));
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {});
//   }
// }
