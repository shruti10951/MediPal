import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Individual/bottom_navigation_individual.dart';

import 'package:medipal/models/UserModel.dart';
import 'package:medipal/Individual/dashboard_screen.dart';

class OTPForUserPage extends StatelessWidget {
  final String verificationId;
  final UserModel userModel;

  OTPForUserPage({required this.verificationId, required this.userModel});

  final otpController = TextEditingController();

  final auth = FirebaseAuth.instance;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'OTP',
            ),
            controller: otpController,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
              onPressed: () async {
                // Create a PhoneAuthCredential with the code
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otpController.text);

                  User? user = FirebaseAuth.instance.currentUser;

                  //DO SOMETHING ABOUT THIS!!!
                  //BACK BUTTON
                  await user?.linkWithCredential(credential).then((value) async {
                    Map<String, dynamic> userMap = userModel.toMap();
                    await collectionReference.doc(auth.currentUser?.uid).set(userMap).then((value) => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const BottomNavigationIndividual()),
                      ),
                    });
                  });

                } catch (e) {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      duration:
                          const Duration(seconds: 3), // Adjust the duration as needed
                    ),
                  );
                }
              },
              child: const Text('Verify'))
        ],
      ),
    );
  }
}
