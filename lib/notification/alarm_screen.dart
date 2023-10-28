import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medipal/credentials/firebase_cred.dart';
import 'package:medipal/models/AlarmModel.dart';
import 'package:medipal/models/MedicationModel.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../credentials/twilio_cred.dart';

class AlarmScreen extends StatefulWidget {
  final String alarmId;

  AlarmScreen({required this.alarmId});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late AlarmModel alarm;
  late MedicationModel medication;

  Map<String, dynamic> alarmMap = {};
  Map<String, dynamic> medicationMap = {};
  Map<String, dynamic> userMap = {};

  var user;
  var role='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<void>(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error.toString()}');
          } else {
            return buildUI();
          }
        },
      ),
    );
  }

  Future<void> loadData() async {
    alarmMap = await loadAlarmData();
    medicationMap = await loadMedicationData();
    var userList = await FirebaseCred().getData();
    role = userList[1];
    user= userList[0];
  }

  Future<Map<String, dynamic>> loadMedicationData() async {
    QuerySnapshot medicationSnapshot = await FirebaseFirestore.instance
        .collection('medications')
        .where('medicationId', isEqualTo: alarmMap['medicationId'])
        .get();
    for (QueryDocumentSnapshot s in medicationSnapshot.docs) {
      medication = MedicationModel.fromDocumentSnapshot(s);
      medicationMap = medication.toMap();
    }
    return medicationMap;
  }

  Future<Map<String, dynamic>> loadAlarmData() async {
    QuerySnapshot alarmSnapshot = await FirebaseFirestore.instance
        .collection('alarms')
        .where('alarmId', isEqualTo: widget.alarmId)
        .get();
    for (QueryDocumentSnapshot s in alarmSnapshot.docs) {
      alarm = AlarmModel.fromDocumentSnapshot(s);
      alarmMap = alarm.toMap();
    }
    return alarmMap;
  }

  Widget buildUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large Alarm Icon
          AlarmIcon(),
          const SizedBox(height: 10),
          Text(
            alarmMap['time']
                    .toString()
                    .split(' ')
                    .last
                    .split(':')
                    .sublist(0, 2)
                    .join(':') ??
                'No time available',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Medicine Type Icon
          MedicineTypeIcon(medicineType: medicationMap['type'] ?? 'Pills'),
          const SizedBox(height: 10),

          // Medicine Name
          Text(
            medicationMap['name'] ?? 'No medication name available',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // Add some space below the Medicine Name
          const SizedBox(height: 10),
          // Medicine Description
          MedicineDescription(
              description:
                  medicationMap['description'] ?? 'No description available'),
          // Add some space below the Medicine Description
          const SizedBox(height: 10),
          // Quantity of Medicine
          Text(
            'Quantity: ${medicationMap['inventory']['quantity'] ?? 0}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 200),
          // Action Buttons
          ActionButtons(alarmId: widget.alarmId, alarmMap: alarmMap, userId: user.uid, role: role),
        ],
      ),
    );
  }
}

class MedicineDescription extends StatelessWidget {
  final String description;

  MedicineDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        description,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class AlarmIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace 'image_path' with the actual path to your image asset.
    return Image.asset(
      'assets/images/medipal.png',
      width: 120,
      height: 120,
    );
  }
}

class MedicineTypeIcon extends StatelessWidget {
  final String medicineType;

  MedicineTypeIcon({required this.medicineType});

  @override
  Widget build(BuildContext context) {
    String imagePath;
    if (medicineType == 'Pills') {
      imagePath = 'assets/images/pill_icon.png';
    } else if (medicineType == 'Liquid') {
      imagePath = 'assets/images/liquid_icon.png';
    } else if (medicineType == 'Injection') {
      imagePath = 'assets/images/injection_icon.png';
    } else {
      imagePath =
          'assets/images/default.png'; // Default image for unknown medicine type
    }

    return Image.asset(
      imagePath,
      width: 50, // Adjust the width as needed
      height: 50, // Adjust the height as needed
    );
  }
}

class ActionButtons extends StatelessWidget {
  final String alarmId;
  final String userId;
  final String role;
  Map<String, dynamic> alarmMap;

  ActionButtons({required this.alarmId, required this.alarmMap, required this.userId, required this.role});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularButton(
          icon: Icons.cancel,
          label: 'Cancel',
          onPressed: () {
            // Show Cancel Popup
            _showCancelDialog(context);
          },
          color: Colors.red,
        ),
        const SizedBox(width: 80), // Add space between icons
        CircularButton(
          icon: Icons.check,
          label: 'Take',
          onPressed: () async {
            alarmMap['status'] = 'taken';
            await FirebaseFirestore.instance
                .collection('alarms')
                .doc(alarmId)
                .update(alarmMap)
                .then((value) => Navigator.of(context).pop());
          },
          color: Colors.green,
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Medication'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Why are you canceling this medication?'),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter reason here',
                ),
                controller: reasonController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                var reason= reasonController.text;
                alarmMap['skipReason'] = reason;
                alarmMap['status'] = 'Skipped';
                await FirebaseFirestore.instance
                    .collection('alarms')
                    .doc(alarmId)
                    .update(alarmMap)
                    .then((value) async {
                      if(role=='dependent'){
                        final cred = await TwilioCred().readCred();
                        final guardian = await FirebaseCred().getGuardianData(userId);
                        TwilioFlutter twilioFlutter;
                        if (guardian != null) {
                          twilioFlutter = TwilioFlutter(
                            accountSid: cred[0],
                            authToken: cred[1],
                            twilioNumber: cred[2],
                          );

                          twilioFlutter.sendSMS(
                            toNumber: '+91' + guardian['phoneNo'],
                            messageBody: "Your dependent did not take the medicine! \nReason: $reason",
                          );
                          print('done');
                        } else {
                          // Handle the case where guardian is null (e.g., show an error message).
                          print('Guardian data is not available.');
                        }
                      }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

class CircularButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  CircularButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
