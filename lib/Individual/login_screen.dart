import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Individual/bottom_navigation_individual.dart';
import 'package:medipal/Individual/dashboard_screen.dart';
import 'package:medipal/main.dart';
import 'package:medipal/user_registration/forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(234, 255, 255, 255),
      body: Stack(
        children: [
          // Background Gradient with Curved Middle
          Positioned.fill(
            child: ClipPath(
              clipper: CustomShapeClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(214, 152, 191, 255),
                      Color.fromARGB(255, 223, 238, 255),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: 40.0,
            left: 17.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Positioned(
            top: 150.0,
            left: 125.0,
            child: SizedBox(
              width: 140.0,
              height: 140.0,
              child: Image.asset('assets/images/medipal.png'),
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
                      color: Color.fromARGB(255, 41, 45, 92),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Medipal - A medicine reminder app',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 41, 45, 92),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: _buildInputField(
                        Icons.mark_email_read_outlined, 'Email Address'),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: _buildPasswordField(
                        Icons.password_outlined, 'Password'),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          navigatorKey.currentState?.push(MaterialPageRoute(
                              builder: (context) => ForgetPasswordPage()));
                        },
                        child: const Text(
                          'Forgot Password?',
                          style:
                              TextStyle(color: Color.fromARGB(255, 41, 45, 92)),
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
      style: const TextStyle(color: Color.fromARGB(255, 41, 45, 92)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 41, 45, 92)),
        prefixIcon: Icon(
          icon,
          color: Color.fromARGB(218, 41, 45, 92),
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
      style: const TextStyle(color: Color.fromARGB(255, 41, 45, 92)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 41, 45, 92)),
        prefixIcon: Icon(
          icon,
          color: const Color.fromARGB(218, 41, 45, 92),
        ),
        border: InputBorder.none,
      ),
      controller: _passwordController,
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final auth = FirebaseAuth.instance;
          auth
              .signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text)
              .then((value) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomNavigationIndividual()),
              (Route<dynamic> route) => false,
            );
          });
        },
        style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(255, 41, 45, 92),
          onPrimary: Colors.white,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
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
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.7);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.8,
      0,
      size.height * 0.7,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
