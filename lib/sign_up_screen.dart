import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medipal/login_screen.dart';
import 'package:medipal/user_selection_screen.dart';

class SignUpPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //show loading
  bool isSigningUp = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Noo'),
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
              controller: emailController,
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              controller: passwordController,
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Add your sign-up logic here
                isSigningUp = true;
                final auth = FirebaseAuth.instance;
                await auth
                    .createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text)
                    .then((value) => {
                isSigningUp= false,
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserSelection()))
              });
              },
              child: isSigningUp == true
                  ? CircularProgressIndicator(
                color: Colors.black,
              )
                  : Text('Sign Up'),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.cyan),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
