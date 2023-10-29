import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Dependent/add_guardian.dart';
import 'package:medipal/models/UserModel.dart';

import '../main.dart';
import '../user_registration/choose_screen.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
final userId = auth.currentUser?.uid;

Future<Map<String, dynamic>?> fetchData() async {
  final userInfoQuery =
  firestore.collection('dependent').doc(userId).get();

  try {
    final userDoc = await userInfoQuery;
    if (userDoc.exists) {
      // final userData = UserModel.fromDocumentSnapshot(userDoc);
      final userData= userDoc.data() as Map<String, dynamic>;
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
              onPressed: ()  async{
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
        title: const Text('Dependent Profile'),
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
            Image.asset(
              'assets/images/medipal.png',
              width: 160,
              height: 160,
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>?>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Text('Error: Unable to load user data');
                }

                final user = snapshot.data!;
                return Column(
                  children: [
                    _buildInfoRow('Name', user['name'] ?? 'Loading...', Icons.person_add_alt),
                    _buildInfoRow(
                        'Phone', user['phoneNo'] ?? 'Loading...', Icons.phone_android_sharp),
                    // if (isDependent)
                    const SizedBox(height: 16), // Add some spacing
                    ElevatedButton(
                      onPressed: () {
                        // Handle the "Scan QR Code" button click
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddGuardian(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 41, 45, 92),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Scan QR Code',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

