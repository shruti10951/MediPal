// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:medipal/user_registration/login_screen.dart';
//
// class ForgetPasswordPage extends StatelessWidget {
//   TextEditingController _emailController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Forgot Password'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Email',
//               ),
//               controller: _emailController,
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () async{
//                 // Add your forgot password logic here
//                 await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text)
//                     .then((value) => {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => LoginPage()))
//                 });
//               },
//               child: Text('Reset Password'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
