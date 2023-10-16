import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/user_registration/enter_otp_dependent_screen.dart';

import 'dashboard_screen_dependent.dart';

class LoginScreenDependent extends StatelessWidget {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  LoginScreenDependent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Curved Middle
          Positioned.fill(
            child: ClipPath(
              clipper: CustomShapeClipper(), // Custom clipper for curved shape
              child: Image.asset(
                'assets/images/welcome_background.jpeg', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 17.0,
            left: 17.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.3), // Transparent white background
                shape: BoxShape.circle, // Circular shape
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white), // Set icon color to white
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Navigate back to the WelcomeScreen
                },
              ),
            ),
          ),

          //NO WELCOME PLS!!!
          //NO FORGOT PASSWORD
          //NO PASSWORD INSTEAD NAME
          // Welcome Back Text
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 16.0,
            right: 16.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Welcome Back Dependent!',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Medipal - A medicine reminder app',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 214, 236, 255)
                          .withOpacity(0.6), // Light blue with opacity
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: _buildInputField(Icons.person, 'Name', _nameController),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 244, 255)
                          .withOpacity(0.6), // Light blue with opacity
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: _buildPhoneNoField(Icons.lock, 'Phone Number', _phoneController),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: false, // Change the value as needed
                            onChanged: (bool? value) {
                              // Implement remember me logic
                            },
                          ),
                          const Text(
                            'Remember Me',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement forgot password action
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 120.0),
                  Container(
                    child: _buildSignInButton(context, _phoneController.text, _nameController.text),
                    
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hintText, TextEditingController _nameController) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        border: InputBorder.none,
      ),
      controller: _nameController,
    );
  }

  Widget _buildPhoneNoField(IconData icon, String hintText, TextEditingController _phoneController) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        border: InputBorder.none,
      ),
      controller: _phoneController,
    );
  }

  // Widget _buildPasswordField(IconData icon, String hintText) {
  //   bool _isPasswordVisible = false;
  //
  //   return TextField(
  //     obscureText: !_isPasswordVisible,
  //     style: const TextStyle(color: Colors.white),
  //     decoration: InputDecoration(
  //       hintText: hintText,
  //       hintStyle: const TextStyle(color: Colors.white),
  //       prefixIcon: Icon(
  //         icon,
  //         color: Colors.white,
  //       ),
  //       suffixIcon: IconButton(
  //         icon: Icon(
  //           _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
  //           color: Colors.white,
  //         ),
  //         onPressed: () {
  //           _isPasswordVisible = !_isPasswordVisible;
  //         },
  //       ),
  //       border: InputBorder.none,
  //     ),
  //   );
  // }

  Widget _buildSignInButton(BuildContext context, String number, String name) {
  return SizedBox(
    width: double.infinity, // Set width to match the parent
    child: ElevatedButton(
      onPressed: () {
        verify(context, number, name);
      },
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 0, 0, 0), // Contrasting color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
    ),
  );
}

  void verify(BuildContext context, String phoneNumber, String name) async{
    await auth.verifyPhoneNumber(
        phoneNumber: '+91' + phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OTPForDependentPage(verificationId: verificationId, name: name, phoneNo: phoneNumber)));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0); // Start from the top-left corner
    path.lineTo(size.width, 0); // Move to the top-right corner
    path.lineTo(size.width, size.height * 0.7); // Curve starting point
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.8,
      0,
      size.height * 0.7,
    ); // Curve
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
