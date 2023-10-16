import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/models/UserModel.dart';
import 'package:medipal/user_registration/enter_otp_user_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Curved Middle
          Positioned(
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
            top: 17.0,
            left: 17.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3), // Transparent white background
                shape: BoxShape.circle, // Circular shape
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 0, 0, 0),
                ), // Set icon color to white
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back to the previous screen
                },
              ),
            ),
          ),

          // Register Text
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 16.0,
            right: 16.0,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 80.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                Text(
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

          // Registration Form
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 16.0,
            right: 16.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInputField(Icons.person, 'Name'),
                  const SizedBox(height: 16.0),
                  _buildInputField(Icons.email, 'Email'),
                  const SizedBox(height: 16.0),
                  _buildInputField(Icons.phone, 'Phone Number'),
                  const SizedBox(height: 16.0),
                  _buildPasswordField(Icons.lock, 'Password'),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Add your sign-up logic here
                      await auth
                          .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text)
                          .then((value) => verify(context, phoneController.text));
                    },
                    child: const Text('Register'),
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
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6), // Light blue with opacity
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: TextField(
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
      ),
    );
  }

  Widget _buildPasswordField(IconData icon, String hintText) {
    bool _isPasswordVisible = false;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6), // Light blue with opacity
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: TextField(
        obscureText: !_isPasswordVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
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
          UserModel userModel = UserModel(userId: auth.currentUser!.uid,
              email: emailController.text,
              phoneNo: phoneNumber,
              name: nameController.text,
              role: 'Individual',
              noOfDependents: 0,
              dependents:[]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OTPForUserPage(verificationId: verificationId, userModel: userModel)));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }
}

//Costom CLipper class with Path
class WaveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    
      var path = new Path();
      path.lineTo(0, size.height); //start path with this if you are making at bottom
      
      var firstStart = Offset(size.width / 5, size.height); 
      //fist point of quadratic bezier curve
      var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
      //second point of quadratic bezier curve
      path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

      var secondStart = Offset(size.width - (size.width / 3.24), size.height - 105); 
      //third point of quadratic bezier curve
      var secondEnd = Offset(size.width, size.height - 10);
      //fourth point of quadratic bezier curve
      path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

      path.lineTo(size.width, 0); //end with this path if you are making wave at bottom
      path.close();
      return path; 
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
     return false; //if new instance have different instance than old instance 
     //then you must return true;
  }
}