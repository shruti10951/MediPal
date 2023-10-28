import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreenDependent extends StatefulWidget {
  const ProfileScreenDependent({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreenDependent> {
  ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  bool isDependent = false; // Track Dependent status

  @override
  void initState() {
    super.initState();
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
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Icon for the logout button
            onPressed: () { 
              
            },
          ),
        ],
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
