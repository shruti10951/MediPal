import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
      // Return null or handle the case when the document doesn't exist
      return null;
    }
  } catch (error) {
    print('Error retrieving document: $error');
    return null;
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  void _selectImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  String guardianCode = '';

  DependentBox? dependent;
  UserModel? userData; // Add user data

  void _openGuardianDialog() {
    String code = userId ?? ''; // Use the user's ID as the code
    TextEditingController codeController = TextEditingController(text: code);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Guardian Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller:
                    codeController, // Use a controller to display and edit the code
                decoration: const InputDecoration(labelText: 'Code'),
                // onChanged: (value) {
                //   setState(() {
                //     guardianCode = value;
                //   });
                // },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: codeController.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Code copied to clipboard')),
                );
              },
              child: const Text('Copy Code'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
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
                    backgroundImage:
                        _image != null ? FileImage(File(_image!.path)) : null,
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
            FutureBuilder<UserModel?>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Text('Error: Unable to load user data');
                }

                final user = snapshot.data!;
                return Column(
                  children: [
                    _buildInfoRow('Name', user.name, Icons.person),
                    _buildInfoRow('Phone', user.phoneNo, Icons.phone),
                    _buildInfoRow('Email', user.email, Icons.email),
                    if (dependent != null) dependent!,
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _openGuardianDialog();
                    setState(() {
                      dependent = const DependentBox();
                    });
                  },
                  child: const Text('Be Guardian'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // Handle the "Edit" button press
                  },
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

  _buildInfoRow(String title, String subtitle, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Colors.black.withOpacity(0.2),
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
      ),
    );
  }
}

class DependentBox extends StatelessWidget {
  const DependentBox({Key? key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 60,
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: ListTile(
            title: Text('Dependent',
                style: TextStyle(fontWeight: FontWeight.bold)),
            leading: Icon(Icons.person,
                size: 20, color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ),
    );
  }
}
