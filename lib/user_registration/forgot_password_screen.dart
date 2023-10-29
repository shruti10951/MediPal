import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        backgroundColor: Color.fromARGB(255, 223, 238, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Color.fromARGB(214, 152, 191, 255),
              Color.fromARGB(255, 223, 238, 255),
              Color.fromARGB(240, 183, 210, 253),
            ],
          ),
        ),
        child: Padding(
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
                onPressed: () async {
                  // Add your forgot password logic here
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: _emailController.text)
                        .then((value) {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => DependentLogin()))
                      navigatorKey.currentState?.pop(context);
                    });
                  } catch (e) {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                  Fluttertoast.showToast(
                        msg: 'Email Sent SuccessFully!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
                        textColor: Colors.white,
                      );

                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Adjust the value for the desired roundness
                  ),
                ),
                child: Text('Reset Password'),
              ), 
            ],
          ),
        ),
      ),
    );
  }
}
