import 'package:flutter/material.dart';
import 'package:medipal/Individual/login_screen.dart';
import 'package:medipal/Individual/register_screen.dart';
import 'package:medipal/user_registration/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Positioned(
            left: 0.0,
            child: Image.asset(
              'assets/images/welcome_background.png', // Replace with your image path
               
                fit: BoxFit.cover,
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

          // Sign In Button (Transparent with Border)
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
                  primary: Color.fromARGB(0, 0, 0, 0),
                  side: const BorderSide(color: Colors.white, width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the radius as needed
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
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
                        builder: (context) => RegisterScreen(),
                      ));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(20, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        0.0), // Adjust the radius as needed
                  ),
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
}
