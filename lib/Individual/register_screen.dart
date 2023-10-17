import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Individual/dashboard_screen.dart';
import 'package:medipal/Individual/login_screen.dart';
import 'package:medipal/models/UserModel.dart';
import 'package:medipal/user_registration/enter_otp_user_screen.dart';
import 'package:medipal/user_registration/sign_up_screen.dart';

import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Curved Middle
          Positioned(
            left: 0,
            child: ClipPath(
              clipper: WaveClipper(), // Custom clipper for curved shape
              child: Image.asset(
                'assets/images/welcome_background.png', // Replace with your image path
                height: 800.0,
                width: 500.0,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 40.0,
            left: 17.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.3), // Transparent white background
                shape: BoxShape.circle, // Circular shape
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Navigate back to the previous screen
                },
              ),
            ),
          ),

          // Register Text and Circular Medipal Image
          Positioned(
            top: 0.0, // Align to the top
            left: 0.0,
            right: 0.0,
            child: Column(
              children: [
                SizedBox(
                  width: 350.0, // Set the width of the circular image
                  height: 350.0, // Set the height of the circular image
                  child: Image.asset(
                    'assets/images/medipalcircular.png', // Replace with your image path
                  ),
                ),
                // const SizedBox(
                //     height: 8.0), // Add some spacing between the image and text
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Registration Form (Positioned at the bottom)
          Positioned(
            left: 16.0,
            right: 16.0,
            bottom: 150.0,
            child: SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  side: const BorderSide(color: Colors.white, width: 2.0),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),

          // Create Account Button (Transparent without Border)
          Positioned(
            left: 16.0,
            right: 16.0,
            bottom: 80.0,
            child: SizedBox(
              height: 50.0,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ));
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(72, 0, 0, 0),
                ),
                child: const Text(
                  'Create an Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hintText) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255)
            .withOpacity(0.8), // Light blue with opacity
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
      ),
      child: TextField(
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          prefixIcon: Icon(
            icon,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(IconData icon, String hintText) {
    bool _isPasswordVisible = false;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255)
            .withOpacity(0.8), // Light blue with opacity
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
      ),
      child: TextField(
        obscureText: !_isPasswordVisible,
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          prefixIcon: Icon(
            icon,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            onPressed: () {
              _isPasswordVisible = !_isPasswordVisible;
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  verify(context, phoneNumber) async {
    await auth.verifyPhoneNumber(
        phoneNumber: '+91' + phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          UserModel userModel = UserModel(
              userId: auth.currentUser!.uid,
              email: emailController.text,
              phoneNo: phoneNumber,
              name: nameController.text,
              role: 'Individual',
              noOfDependents: 0,
              dependents: []);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPForUserPage(
                      verificationId: verificationId, userModel: userModel)));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 100);
    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2.25, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    final secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}
