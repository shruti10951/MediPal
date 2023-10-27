import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medipal/models/UserModel.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
final userId = auth.currentUser?.uid;

Future<UserModel?> fetchData() async {
  final userInfoQuery = firestore.collection('users').doc(userId).get();

  try {
    final userDoc = await userInfoQuery;
    if (userDoc.exists) {
      final userData = UserModel.fromDocumentSnapshot(userDoc);
      return userData;
    } else {
      return null;
    }
  } catch (error) {
    print('Error retrieving document: $error');
    return null;
  }
}

class ProfileScreenDependent extends StatefulWidget {
  const ProfileScreenDependent({Key? key}) : super(key: key);

  @override
  _ProfileScreenDependentState createState() => _ProfileScreenDependentState();
}

class _ProfileScreenDependentState extends State<ProfileScreenDependent> {
  ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  // Variables to store user profile data
  String name = '';
  String phone = '';

  // Guardian code input controller
  final guardianCodeController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Fetch and set the user's profile data
    fetchUserProfileData();
  }

  Future<void> fetchUserProfileData() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Assuming the 'user' document is stored using the user's UID as the document ID
      final userDocument = await FirebaseFirestore.instance.collection('user').doc(currentUser.uid).get();
      if (userDocument.exists) {
        final userData = userDocument.data() as Map<String, dynamic>;
        setState(() {
          name = userData['name'] ?? '';
          phone = userData['phoneNo'] ?? '';
        });
      }
    }
  }

  // Helper function to build user profile info rows
  Widget _buildUserInfoRow(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(iconData),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  Future<void> fetchUserData() async {
    final userDoc = await firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      final userData = UserModel.fromDocumentSnapshot(userDoc);
      setState(() {
        this.userData = userData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
                    // Handle the "Edit" button press
                  },
          ),
        ],
        title: const Text('Profile (Dependent)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace the GestureDetector with an Image.asset widget
            Image.asset(
              'assets/images/medipal.png',
              width: 160, // Adjust the width as needed
              height: 160, // Adjust the height as needed
            GestureDetector(
              onTap: _selectImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: _image != null ? FileImage(File(_image!.path)) : null,
                    child: _image == null
                        ? const Icon(
                            Icons.add,
                            size: 36,
                          )
                        : null,
                  ),
                  if (_image != null)
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Display user profile data
                  _buildUserInfoRow('Name', name, Icons.person),
                  _buildUserInfoRow('Phone', phone, Icons.phone),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // Handle the "Edit" button press
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  @override
  void dispose() {
    // Dispose of the guardianCodeController to free up resources
    guardianCodeController.dispose();
    super.dispose();
  }
}
