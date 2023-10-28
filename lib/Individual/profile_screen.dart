import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medipal/Dependent/add_guardian.dart';
import 'package:medipal/main.dart';
import 'package:medipal/models/UserModel.dart';
import 'package:medipal/Individual/dependent_details_screen.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Replace with your screen for Dependent details

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
final userId = auth.currentUser?.uid;

Future<UserModel?> fetchData() async {
  final userInfoQuery = firestore.collection('users').doc(auth.currentUser?.uid).get();

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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  bool isDependent = false;
  String guardianCode = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

 UserModel? userData;

  void _openGuardianDialog() {
    String code = userId??''; // Use the user's ID as the code
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
                onChanged: (value) {
                  setState(() {
                    guardianCode = value;
                  });
                },
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
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
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

  Widget _buildInfoRow(String title, String subtitle, IconData iconData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(iconData),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
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
            // Replace the GestureDetector with an Image.asset widget
            // Image.asset(
            //   'assets/images/medipal.png',
            //   width: 160, // Adjust the width as needed
            //   height: 160, // Adjust the height as needed
            // ),
            QrImageView(
              data: userId ?? 'error',
              version: QrVersions.auto,
              size: 200,
              gapless: false,
            ),
            const SizedBox(height: 16),
            FutureBuilder<UserModel?>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Text('Error: Unable to load user data');
                }

                final user = snapshot.data!;
                return Column(
                  children: [
                    _buildInfoRow('Name', user.name, Icons.person),
                    _buildInfoRow('Phone', user.phoneNo, Icons.phone),
                    _buildInfoRow('Email', user.email, Icons.email),
                    if (isDependent)
                      Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2,
                        child: InkWell(
                          onTap: () {
                            // Navigate to Dependent Details Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DependentDetailsScreen(),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person, // Your desired grey icon
                                  color:
                                      Colors.grey, // Set the icon color to grey
                                ),
                                SizedBox(width: 16),
                                // Add spacing between icon and text
                                Text(
                                  'Dependent Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                // Add a spacer to push the icon to the end
                                Icon(
                                  Icons
                                      .arrow_forward, // Your desired arrow icon
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
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
                    // _openGuardianDialog();
                    Visibility(
                      child: QrImageView(
                        data: userId ?? 'error',
                        version: QrVersions.auto,
                        size: 320,
                        gapless: false,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Be Guardian'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // Handle the "Edit" button press
                    // navigatorKey.currentState?.push(MaterialPageRoute(builder: (builder)=> AddGuardian()));
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
}
