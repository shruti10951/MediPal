import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Individual/bottom_navigation_individual.dart';
import 'package:medipal/models/AlarmModel.dart';
import 'package:medipal/models/MedicationModel.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../credentials/firebase_cred.dart';
import '../credentials/twilio_cred.dart';
import '../main.dart';

class AlarmScreen extends StatefulWidget {
  final String alarmId;

  AlarmScreen({required this.alarmId});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();

}

class _AlarmScreenState extends State<AlarmScreen> {

  late AlarmModel alarm;
  late MedicationModel medication;

  Map<String, dynamic> alarmMap={};
  Map<String, dynamic> medicationMap= {};

  final user= FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<void>(
        future: loadData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }else if(snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          }else{
            return buildUI();
          }
        },
      )
    );
  }

  Future<void> loadData() async{
    alarmMap= await loadAlarmData();
    medicationMap= await loadMedicationData();
  }

  Future<Map<String, dynamic>> loadMedicationData() async{
    QuerySnapshot medicationSnapshot= await FirebaseFirestore.instance.collection('medications').where('medicationId', isEqualTo: alarmMap['medicationId']).get();
    for(QueryDocumentSnapshot s in medicationSnapshot.docs){
      medication= MedicationModel.fromDocumentSnapshot(s);
      medicationMap= medication.toMap();
    }
    return medicationMap;
  }

  Future<Map<String, dynamic>> loadAlarmData()async {
    QuerySnapshot alarmSnapshot= await FirebaseFirestore.instance.collection('alarms').where('alarmId', isEqualTo: widget.alarmId).get();
    for(QueryDocumentSnapshot s in alarmSnapshot.docs){
      alarm= AlarmModel.fromDocumentSnapshot(s);
      alarmMap= alarm.toMap();
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
          // Dynamic Time
          Text(
            alarmMap['time'] ?? 'No time available',
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

          // Medicine Description
          Container(
            height: 300, // Fixed height for the description container
            child: MedicineDescription(description: medicationMap['description'] ?? 'No description available'),
          ),
          // Action Buttons
          ActionButtons(alarmId: widget.alarmId, alarmMap: alarmMap),
        ],
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

class ActionButtons extends StatelessWidget {
  final String alarmId;
  Map<String,dynamic> alarmMap;

  ActionButtons({required this.alarmId, required this.alarmMap});

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
        const SizedBox(width: 50), // Add space between icons
        CircularButton(
          icon: Icons.check,
          label: 'Take',
          onPressed: () async{
            alarmMap['status']= 'taken';
            await FirebaseFirestore.instance.collection('alarms').doc(alarmId).update(alarmMap).then((value){
              navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context)=> BottomNavigationIndividual()));
            });
          },
          color: Colors.green,
        ),
        const SizedBox(width: 50), // Add space between icons
        CircularButton(
          icon: Icons.snooze,
          label: 'Snooze',
          onPressed: () {
            // Handle snooze
          },
          color: Colors.blue,
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    TextEditingController reasonController= TextEditingController();
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
                  final data = await FirebaseCred().getData();
                  final user = data[0];
                  final cred = await TwilioCred().readCred();
                  final guardian = await FirebaseCred().getGuardianData(user.uid.toString());
                  TwilioFlutter twilioFlutter;

                  if (guardian != null) {
                    twilioFlutter = TwilioFlutter(
                      accountSid: cred[0],
                      authToken: cred[1],
                      twilioNumber: cred[2],
                    );

                    twilioFlutter.sendSMS(
                      toNumber: '+91' + guardian['phoneNo'],
                      messageBody: 'Your dependent did not take the medicine! \nReason: $reasonController.text',
                    );
                    navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context)=> BottomNavigationIndividual()));
                  } else {
                    // Handle the case where guardian is null (e.g., show an error message).
                    print('Guardian data is not available.');
                  }

                Navigator.of(context).pop();
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
