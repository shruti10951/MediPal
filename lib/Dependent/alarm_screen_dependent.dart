// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:medipal/Individual/bottom_navigation_individual.dart';
// import 'package:medipal/models/AlarmModel.dart';
//
// import '../main.dart';
//
// class AlarmScreen extends StatefulWidget {
//   final String alarmId;
//
//   AlarmScreen({required this.alarmId});
//
//   @override
//   _AlarmScreenState createState() => _AlarmScreenState();
// }
//
// class _AlarmScreenState extends State<AlarmScreen> {
//   late AlarmModel alarm;
//   Map<String, dynamic> alarmMap = {};
//   final user = FirebaseAuth.instance.currentUser;
//   @override
//   void initState() {
//     super.initState();
//     loadAlarmData();
//   } // Dynamic data
//
//   String time = '10:00 AM'; // Replace with your time
//   String medicineType = 'Liquid'; // Replace with your medicine type
//   String description =
//       'Hello take you medicine'; // Replace with your description
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Large Alarm Icon
//               AlarmIcon(),
//               const SizedBox(height: 10),
//
//               // Dynamic Time
//               Text(
//                 time,
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Medicine Type Icon
//               MedicineTypeIcon(medicineType: medicineType),
//               const SizedBox(height: 10),
//
//               // Medicine Description
//               Container(
//                 height: 300, // Fixed height for the description container
//                 child: MedicineDescription(description: description),
//               ),
//               // Action Buttons
//               ActionButtons(alarmId: widget.alarmId, alarmMap: alarmMap),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void loadAlarmData() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('alarms')
//         .where('alarmId', isEqualTo: widget.alarmId)
//         .get();
//     for (QueryDocumentSnapshot s in snapshot.docs) {
//       alarm = AlarmModel.fromDocumentSnapshot(s);
//       alarmMap = alarm.toMap();
//     }
//   }
// }
//
// class AlarmIcon extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Replace 'image_path' with the actual path to your image asset.
//     return Image.asset(
//       'assets/images/medipal.png',
//       width: 120,
//       height: 120,
//     );
//   }
// }
//
// class MedicineTypeIcon extends StatelessWidget {
//   final String medicineType;
//
//   MedicineTypeIcon({required this.medicineType});
//
//   @override
//   Widget build(BuildContext context) {
//     String imagePath;
//     if (medicineType == 'Pills') {
//       imagePath = 'assets/images/pill_icon.png';
//     } else if (medicineType == 'Liquid') {
//       imagePath = 'assets/images/liquid_icon.png';
//     } else if (medicineType == 'Injection') {
//       imagePath = 'assets/images/injection_icon.png';
//     } else {
//       imagePath =
//           'assets/images/default.png'; // Default image for unknown medicine type
//     }
//
//     return Image.asset(
//       imagePath,
//       width: 50, // Adjust the width as needed
//       height: 50, // Adjust the height as needed
//     );
//   }
// }
//
// class MedicineDescription extends StatelessWidget {
//   final String description;
//
//   MedicineDescription({required this.description});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Text(
//         description,
//         style: const TextStyle(fontSize: 16, color: Colors.black),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }
//
// class ActionButtons extends StatelessWidget {
//   final String alarmId;
//   Map<String, dynamic> alarmMap;
//
//   ActionButtons({required this.alarmId, required this.alarmMap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         CircularButton(
//           icon: Icons.cancel,
//           label: 'Cancel',
//           onPressed: () {
//             // Show Cancel Popup
//             _showCancelDialog(context);
//           },
//           color: Colors.red,
//         ),
//         const SizedBox(width: 80), // Add space between icons
//         CircularButton(
//           icon: Icons.check,
//           label: 'Take',
//           onPressed: () async {
//             alarmMap['status'] = 'taken';
//             await FirebaseFirestore.instance
//                 .collection('alarms')
//                 .doc(alarmId)
//                 .update(alarmMap)
//                 .then((value) {
//               navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
//                   builder: (context) => BottomNavigationIndividual()));
//             });
//           },
//           color: Colors.green,
//         ),
//       ],
//     );
//   }
//
//   void _showCancelDialog(BuildContext context) {
//     TextEditingController reasonController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Cancel Medication'),
//           content: SingleChildScrollView(
//             // Wrap the content with SingleChildScrollView
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text('Why are you canceling this medication?'),
//                 TextFormField(
//                   maxLines: 2,
//                   decoration: const InputDecoration(
//                     hintText: 'Enter reason here',
//                   ),
//                   controller: reasonController,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle cancellation here
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Submit'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class CircularButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onPressed;
//   final Color color;
//
//   CircularButton({
//     required this.icon,
//     required this.label,
//     required this.onPressed,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: onPressed,
//           child: CircleAvatar(
//             radius: 28,
//             backgroundColor: color,
//             child: Icon(
//               icon,
//               size: 28,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: const TextStyle(color: Colors.black),
//         ),
//       ],
//     );
//   }
// }
