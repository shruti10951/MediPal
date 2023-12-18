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
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 223, 238, 255),
                  Color.fromARGB(213, 170, 202, 255),
                  Color.fromARGB(255, 223, 238, 255),
                  Color.fromARGB(242, 152, 191, 255),
                ],
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.05,
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

          // Circular Medipal Image and Register Text
          Positioned(
            top: MediaQuery.of(context).size.height * 0.10,
            left: 0.0,
            right: 0.0,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: Image.asset(
                    'assets/images/medipal.png',
                  ),
                ),
                const Text(
                  "MEDIPAL",
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Color.fromARGB(255, 41, 45, 92),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Registration form",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 41, 45, 92),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 180.0),
              ],
            ),
          ),

          // Registration Form
          Positioned(
            top: MediaQuery.of(context).size.height * 0.40,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInputField(
                      Icons.person_2_rounded, 'Name', nameController),
                  const SizedBox(height: 16.0),
                  _buildInputField(
                      Icons.alternate_email_outlined, 'Email', emailController),
                  const SizedBox(height: 16.0),
                  _buildNumericInputField(
                      Icons.phone_in_talk, 'Phone Number', phoneController),
                  const SizedBox(height: 16.0),
                  _buildPasswordField(Icons.password_outlined, 'Password',
                      passwordController, context),
                  const SizedBox(height: 130.0),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await auth
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text)
                            .then((value) =>
                                verify(context, phoneController.text));
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 0, 0, 0),
                      onPrimary: Colors.white,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      IconData icon, String hintText, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30.0),
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
        controller: controller,
      ),
    );
  }

  Widget _buildNumericInputField(
      IconData icon, String hintText, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30.0),
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
        controller: controller,
        keyboardType: TextInputType.phone, // Set the keyboard type to numeric
      ),
    );
  }

  Widget _buildPasswordField(IconData icon, String hintText,
      TextEditingController controller, BuildContext context) {
    bool isPasswordVisible = false;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              obscureText: !isPasswordVisible,
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
              controller: controller,
            ),
          ],
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
