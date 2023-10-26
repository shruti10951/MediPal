import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreenDependent extends StatefulWidget {
  const ProfileScreenDependent({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreenDependent> {
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
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile (Dependent)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Guardian code input field
                  TextField(
                    controller: guardianCodeController,
                    decoration: InputDecoration(labelText: 'Enter Guardian code'),
                  ),
                  const SizedBox(height: 16),
                  // Submit button
                  ElevatedButton(
                    onPressed: () {
                      // Handle the "Submit" button press
                      final guardianCode = guardianCodeController.text;
                      // Process the entered guardian code
                      print('Entered Guardian Code: $guardianCode');
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
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
