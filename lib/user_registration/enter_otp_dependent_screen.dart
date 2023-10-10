import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medipal/home_screens/dashboard_screen.dart';

class OTPForDependentPage extends StatelessWidget {
  final String verificationId;
  final String name;

  OTPForDependentPage({required this.verificationId, required this.name});

  final otpController = TextEditingController();

  final auth = FirebaseAuth.instance;

  CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('dependent');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'OTP',
            ),
            controller: otpController,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
              onPressed: () async {
                // Create a PhoneAuthCredential with the code
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otpController.text);

                  await auth.signInWithCredential(credential).then((value) {
                    User? user = FirebaseAuth.instance.currentUser;
                    Map<String, dynamic> dependentMap = {'name': name, 'userId': user?.uid};
                    collectionReference.doc(user?.uid).set(dependentMap).then((value) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardScreen()),
                      );
                    });
                  });
                } catch (e) {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Invalid OTP'),
                      duration:
                      Duration(seconds: 3), // Adjust the duration as needed
                    ),
                  );
                }
              },

              // onPressed: () async {
              //   // Create a PhoneAuthCredential with the code
              //   try {
              //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
              //         verificationId: verificationId,
              //         smsCode: otpController.text);
              //
              //     await auth.signInWithCredential(credential).then((value) => () {
              //       User? user = FirebaseAuth.instance.currentUser;
              //       Map<String, dynamic> dependentMap = {'name': name, 'userId': user?.uid};
              //       collectionReference.doc(auth.currentUser?.uid).set(
              //           dependentMap).then((value) =>
              //       {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => DashboardPage()),
              //         ),
              //       });
              //     });
              //
              //   } catch (e) {
              //     final scaffoldMessenger = ScaffoldMessenger.of(context);
              //     scaffoldMessenger.showSnackBar(
              //       SnackBar(
              //         content: Text('Invalid OTP'),
              //         duration:
              //             Duration(seconds: 3), // Adjust the duration as needed
              //       ),
              //     );
              //   }
              // },
              child: Text('Verify'))
        ],
      ),
    );
  }
}
