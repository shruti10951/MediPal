import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen_dependent.dart';
import 'package:medipal/user_registration/enter_otp_dependent_screen.dart';

class WelcomeScreenDependent extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  WelcomeScreenDependent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Positioned(
            left: 0,
            child: ClipPath(
              clipper: WaveClipper(), // Custom clipper for the wave shape
              child: Image.asset(
                'assets/images/welcome_background.png', // Replace with your image path
                width: 900.0, // Set the width of the image
                height: 700.0, // Set the height of the image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Image (Add your image path)
          // Medipal Circular Image (Position it at the very top)
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Image.asset(
              'assets/images/medipalcircular.png', // Replace with your image path
              width: 400.0,
              height: 400.0,
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

          // Quote Text at the Left Side
          const Positioned(
            left: 30.0,
            top: 270.0,
            child: Text(
              'Your medicine, our responsibility!',
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
                fontWeight: FontWeight.bold, // Make the text bold
                fontStyle: FontStyle.italic, // Make the text italic
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 16.0,
            right: 16.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32.0),
                  const SizedBox(height: 32.0),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 214, 236, 255)
                          .withOpacity(0.6), // Light blue with opacity
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child:
                        _buildInputField(Icons.person, 'Name', _nameController),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(96, 0, 0, 0)
                          .withOpacity(0.6), // Light blue with opacity
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: _buildPhoneNoField(
                        Icons.lock, 'Phone Number', _phoneController),
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
                    child: _buildSignInButton(
                        context, _phoneController.text, _nameController.text),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildSignInButton(BuildContext context, String number, String name) {
  return SizedBox(
    width: double.infinity, // Set width to match the parent
    height: 50.0,
    child: ElevatedButton(
      onPressed: () {
        verify(context, number, name);
      },
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(137, 0, 0, 0), // Contrasting color
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

void verify(BuildContext context, String phoneNumber, String name) async {
  await auth.verifyPhoneNumber(
      phoneNumber: '+91' + phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTPForDependentPage(
                    verificationId: verificationId,
                    name: name,
                    phoneNo: phoneNumber)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {});
}

Widget _buildInputField(
    IconData icon, String hintText, TextEditingController _nameController) {
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

Widget _buildPhoneNoField(
    IconData icon, String hintText, TextEditingController _phoneController) {
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
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
