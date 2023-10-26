// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:medipal/user_registration/dependent_login.dart';
// import 'package:medipal/user_registration/login_screen.dart';
//
// class UserSelection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(title: Text('MediPal'), backgroundColor: Colors.pink),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Join As',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 //dependent logic page
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DependentLogin(),
//                   ),
//                 );
//               },
//               child: Text('Dependent'),
//               style: ButtonStyle(
//                 fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 //user login page
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => LoginPage(),
//                   ),
//                 );
//               },
//               child: Text('User'),
//               style: ButtonStyle(
//                 fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
