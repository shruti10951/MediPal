// import 'package:flutter/material.dart';
// import 'package:medipal/credentials/firebase_cred.dart';
// import 'package:medipal/credentials/twilio_cred.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
//
// class SendSms extends StatelessWidget {
//
//   late TwilioFlutter twilioFlutter;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Single Button Screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () async {
//                 final data = await FirebaseCred().getData();
//                 final user = data[0];
//                 final cred = await TwilioCred().readCred();
//                 final guardian = await FirebaseCred().getGuardianData(user.uid.toString());
//
//                 if (guardian != null) {
//                   twilioFlutter = TwilioFlutter(
//                     accountSid: cred[0],
//                     authToken: cred[1],
//                     twilioNumber: cred[2],
//                   );
//
//                   twilioFlutter.sendSMS(
//                     toNumber: '+91' + guardian['phoneNo'],
//                     messageBody: 'Your dependent did not take the medicine!',
//                   );
//                 } else {
//                   // Handle the case where guardian is null (e.g., show an error message).
//                   print('Guardian data is not available.');
//                 }
//               },
//               child: Text('Press Me'),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
