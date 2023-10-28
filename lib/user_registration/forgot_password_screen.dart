import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/main.dart';
import 'package:medipal/user_registration/dependent_login.dart';
import 'package:medipal/user_registration/login_screen.dart';

class ForgetPasswordPage extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              controller: _emailController,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async{
                // Add your forgot password logic here
                try{
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text)
                      .then((value) {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => DependentLogin()))
                    navigatorKey.currentState?.pop(context);
                  });
                }catch(e){
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
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
