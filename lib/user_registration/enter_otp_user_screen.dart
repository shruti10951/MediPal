import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medipal/dashboard_screen.dart';

class OTPForUserPage extends StatelessWidget {
  final String verificationId;

  OTPForUserPage({required this.verificationId});

  final otpController = TextEditingController();

  final auth = FirebaseAuth.instance;

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
                try{
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otpController.text);

                  User? user= FirebaseAuth.instance.currentUser;

                  await user?.linkWithCredential(credential).then((value) =>
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage()))
                  });

                }catch(e){
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Invalid OTP'),
                      duration: Duration(seconds: 3), // Adjust the duration as needed
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
