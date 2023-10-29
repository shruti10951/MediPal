import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medipal/main.dart';
import 'package:medipal/models/UserModel.dart';
import 'package:medipal/Individual/dependent_details_screen.dart';
import 'package:medipal/user_registration/choose_screen.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Replace with your screen for Dependent details

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
final userId = auth.currentUser?.uid;

Future<UserModel?> fetchData() async {
  final userInfoQuery =
      firestore.collection('users').doc(userId).get();

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
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  UserModel? userData;

  Widget _buildInfoRow(String title, String subtitle, IconData iconData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(
          iconData,
          color: const Color.fromARGB(171, 41, 45, 92),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color.fromARGB(227, 41, 45, 92),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color.fromARGB(255, 20, 22, 44),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 206, 205, 255)),
                    
              ),
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // Close the dialog
                navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> ChooseScreen()), (route) => false);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmation(); // Show the confirmation dialog
            },
          ),
        ],
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
              size: 180,
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
                    _buildInfoRow('Name', user.name, Icons.person_add_alt),
                    _buildInfoRow(
                        'Phone', user.phoneNo, Icons.phone_android_sharp),
                    _buildInfoRow('Email', user.email, Icons.mark_email_read),
                    // if (isDependent)
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
                                Icons.group, // Your desired grey icon
                                color: Color.fromARGB(255, 41, 45,
                                    92), // Set the icon color to grey
                              ),
                              SizedBox(
                                  width:
                                      16), // Add spacing between icon and text
                              Text(
                                'Dependent Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 41, 45, 92),
            
                                ),
                              ),
                              Spacer(), // Add a spacer to push the icon to the end
                              Icon(
                                Icons.arrow_forward, // Your desired arrow icon
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
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
