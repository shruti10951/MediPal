import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Individual/bottom_navigation_individual.dart';
import 'package:medipal/Individual/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(234, 255, 255, 255),
      body: Stack(
        children: [
          // Background Image with Curved Middle
          Positioned.fill(
            child: ClipPath(
              clipper: CustomShapeClipper(), // Custom clipper for curved shape
              child: Image.asset(
                'assets/images/welcome_background.png', // Replace with your image path
                width: 850,
                height: 900,
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
          Positioned(
             top: 40.0,
            left: 17.0,
            child: SizedBox(
              width: 350.0, // Set the width of the circular image
              height: 350.0, // Set the height of the circular image
              child: Image.asset(
                'assets/images/medipalcircular.png', // Replace with your image path
              ),
            ),
          ),

          // Welcome Back Text
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 16.0,
            right: 16.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold, // Make the text bold
                      fontStyle: FontStyle.italic, // Make the text italic
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Medipal - A medicine reminder app',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.6), // Light blue with opacity
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: _buildInputField(Icons.person, 'Username'),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.6), // Light blue with opacity
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: _buildPasswordField(Icons.lock, 'Password'),
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
                            style:
                                TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement forgot password action
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 120.0),
                  Container(
                    child: _buildSignInButton(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hintText) {
    return TextField(
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
      controller: _emailController,
    );
  }

  Widget _buildPasswordField(IconData icon, String hintText) {
    bool _isPasswordVisible = false;

    return TextField(
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
      controller: _passwordController,
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return Container(
      width: double.infinity, // Set width to match the parent
      child: ElevatedButton(
        onPressed: () {
          final auth = FirebaseAuth.instance;
          auth
              .signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text)
              .then((value) => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavigationIndividual()))
                  });
        },
        style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(255, 0, 0, 0), // Background color
          onPrimary: Colors.white, // Text color
          elevation: 3, // Shadow elevation
          padding: const EdgeInsets.symmetric(
              horizontal: 40, vertical: 16), // Button padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded corners
          ),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 18.0,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
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
