import 'package:flutter/material.dart';
import 'package:medipal/Individual/login_screen.dart';
import 'package:medipal/Individual/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(214, 152, 191, 255),
                  Color.fromARGB(255, 223, 238, 255),
                  
                ],
              ),
            ),
          ),
          // Medipal Circular Image (Position it at the very top)
          Positioned(
            top: 120.0,
            left: 125.0,
            child: Image.asset(
              'assets/images/medipal.png', // Replace with your image path
              width: 150.0,
              height: 150.0,
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
          const Positioned(
            left: 150.0,
            top: 280.0,
            child: Text(
              'MEDIPAL',
              style: TextStyle(
                fontSize: 26.0,
                color: Color.fromARGB(255, 41, 45, 92),
                fontWeight: FontWeight.bold, // Make the text bold
                // fontStyle: FontStyle.italic, // Make the text italic
              ),
            ),
          ),

          // Quote Text at the Left Side
          const Positioned(
            left: 60.0,
            top: 320.0,
            child: Text(
              'Your medicine, our responsibility!',
              style: TextStyle(
                fontSize: 18.0,
                color: Color.fromARGB(255, 41, 45, 92),
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
                  primary: Color.fromARGB(255, 234, 244, 255),
                  side: const BorderSide(color: Color.fromARGB(255, 41, 45, 92), width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the radius as needed
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
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
                  backgroundColor: Color.fromARGB(103, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        0.0), // Adjust the radius as needed
                  ),
                ),
                child: const Text(
                  'Create an Account',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
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
