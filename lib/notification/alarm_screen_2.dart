// import 'package:flutter/material.dart';
//
// class AlarmScreen2 extends StatefulWidget {
//   @override
//   _AlarmScreenState createState() => _AlarmScreenState();
// }
//
// class _AlarmScreenState extends State<AlarmScreen2> {
//   // Dynamic data
//   String time = '9:00 AM';
//   String date = '21 SEPT';
//   String medicationName = 'Medicine Name';
//   String quantity = '2 pills';
//   String description = 'मराठी भाषेला महाराष्ट्राची मातृभाषा म्हणता येते. या भाषेला महाराष्ट्राच्या संस्कृती, साहित्य, व कलेच्या क्षेत्रातल्या निरंतर विकासाच्या साथीची महत्त्वाची भाषा म्हणताना योग्य आहे. मराठीत सुंदर कविता, गोष्टी, व किंवा नाटकाच्या रूपातल्या श्रेष्ठ चरित्रे आहेत.';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 35, 35, 35),
//       body: Center(
//         child: Card(
//           elevation: 6.0,
//           margin: const EdgeInsets.all(24.0),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Header
//                 Text(
//                   '$date | $time',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const Divider(
//                   color: Colors.black,
//                   thickness: 1,
//                   height: 20,
//                 ),
//                 // Medication Name
//                 Text(
//                   medicationName,
//                   style: const TextStyle(
//                     fontSize: 20, // Increased font size
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 // Quantity to Take
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10), // Added padding
//                   child: Text(
//                     'Quantity to Take: $quantity',
//                     style: const TextStyle(fontSize: 16, color: Colors.black),
//                   ),
//                 ),
//                 // Description
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10), // Added padding
//                   child: Text(
//                     description,
//                     style: const TextStyle(fontSize: 16, color: Colors.black),
//                   ),
//                 ),
//                 const Divider(
//                   color: Colors.black,
//                   thickness: 1,
//                 ),
//                 // Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     CircularButton(
//                       icon: Icons.cancel,
//                       label: 'Cancel',
//                       onPressed: () {
//                         _showCancelDialog(context);
//                       },
//                       color: Colors.red,
//                     ),
//                     CircularButton(
//                       icon: Icons.check,
//                       label: 'Take',
//                       onPressed: () {
//                         // Handle medication taken
//                       },
//                       color: Colors.green,
//                     ),
//                     CircularButton(
//                       icon: Icons.snooze,
//                       label: 'Snooze',
//                       onPressed: () {
//                         // Handle snooze
//                       },
//                       color: Colors.blue,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showCancelDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Cancel Medication'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Why are you canceling this medication?'),
//               TextFormField(
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter reason here',
//                 ),
//               ),
//             ],
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
//                 // Handle cancelation here
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
