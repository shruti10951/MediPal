import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

                  User? user = FirebaseAuth.instance.currentUser;

                  await user?.linkWithCredential(credential).then((value) async {
                    Map<String, dynamic> userMap = userModel.toMap();
                    await collectionReference.doc(auth.currentUser?.uid).set(userMap).then((value) => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardScreen()),
                      ),
                    });
                  });

                } catch (e) {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      duration:
                          Duration(seconds: 3), // Adjust the duration as needed
                    ),
                  );
                }
              },
              child: Text('Verify'))
        ],
      ),
    );
  }
}
