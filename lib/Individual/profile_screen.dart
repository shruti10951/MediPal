import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medipal/Individual/dependent_details_screen.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
  
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  bool isDependent = false; // Track Dependent status

  @override
  void initState() {
    super.initState();
    _loadDependentStatus();
  }

  _loadDependentStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDependent = prefs.getBool('isDependent') ?? false;
    });
  }

  void _openGuardianDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Guardian Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Code'),
                onChanged: (value) {
                  setState(() {
                    // Handle code input
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('isDependent', true); // Set Dependent status
                setState(() {
                  isDependent = true; // Update Dependent status
                });
                Navigator.of(context).pop();
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

  _buildInfoRow(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildInfoRow('Name', 'John Doe', Icons.person),
                  _buildInfoRow('Phone', '123-456-7890', Icons.phone),
                  _buildInfoRow('Email', 'john.doe@example.com', Icons.email),
                  if (isDependent) const DependentBox(),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _openGuardianDialog();
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

  void _selectImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }
}

class DependentBox extends StatelessWidget {
  const DependentBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the dependent details screen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DependentDetailsScreen(), // Replace with your screen
          ),
        );
      },
      child: SizedBox(
        width: 400,
        height: 60,
        child: Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(
                vertical: 0), // Adjust horizontal padding
            child: ListTile(
              title: Text('Dependent', style: TextStyle(fontWeight: FontWeight.bold)),
              leading: Icon(Icons.person, size: 20, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ),
      ),
    );
  }
}