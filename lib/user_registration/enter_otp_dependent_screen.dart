import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Dependent/dashboard_screen_dependent.dart';
import 'package:medipal/models/DependentModel.dart';

class OTPForDependentPage extends StatelessWidget {
  final String verificationId;
  final String name;
  final String phoneNo;

  OTPForDependentPage({required this.verificationId, required this.name, required this.phoneNo});

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
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text);

                await auth.signInWithCredential(credential).then((value) async {
                  User? user = FirebaseAuth.instance.currentUser;

                  // Check if the user already exists as a dependent
                  final userDoc = await collectionReference.doc(user?.uid).get();
                  if (!userDoc.exists) {
                    // The user doesn't exist, create a new dependent

                    DependentModel dependentModel= DependentModel(
                      userId: user!.uid,
                      name: name,
                      phoneNo: phoneNo,
                    );

                    Map<String, dynamic> dependent= dependentModel.toMap();
                    await collectionReference.doc(user?.uid).set(dependent);
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreenDependent(),
                    ),
                  );
                });
              } catch (e) {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Invalid OTP'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            child: Text('Verify'),
          )

        ],
      ),
    );
  }
}
