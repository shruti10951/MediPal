import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medipal/credentials/twilio_cred.dart';
import 'package:medipal/notification/notification_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../credentials/firebase_cred.dart';

class FireStoreCheck {
  Future<void> checkFirestore() async {
    await Firebase.initializeApp();
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('alarms')
          .where('userId', isEqualTo: user?.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          var time = data['time'];
          var name = data['message'];
          var status = data['status'];
          var alarmId = data['alarmId'];

          DateTime timestamp = DateTime.parse(time);
          DateTime timestamp2 = DateTime.now();

          if (timestamp.isBefore(timestamp2) && status == 'pending') {
            await NotificationService.showNotification(
                title: 'Medipal',
                body: 'This is a reminder',
                payload: {
                  "open": "true",
                  "alarmId": alarmId,
                },
                actionButtons: [
                  NotificationActionButton(
                      key: 'key', label: 'Open', actionType: ActionType.Default)
                ]);
          }
        }
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error retrieving documents',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 240, 91, 91),
        textColor: const Color.fromARGB(255, 255, 255, 255),
      );
    }

    try {
      QuerySnapshot appointmentSnapshot = await firestore
          .collection('appointment')
          .where('userId', isEqualTo: user?.uid)
          .get();
      if (appointmentSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in appointmentSnapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          var time = data['appointmentTime'];

          DateTime timestamp = DateTime.parse(time);
          DateTime currentTime = DateTime.now();

          Duration difference = timestamp.difference(currentTime);
          if (difference.inHours <= 24) {
            final cred = await TwilioCred().readCred();
            TwilioFlutter twilioFlutter = TwilioFlutter(accountSid: cred[0],
                authToken: cred[1],
                twilioNumber: cred[2]);

            final user= await FirebaseCred().getData();
            String role= user[1];
            Map<String, dynamic> userData = user[0];

            String doctorName= data['doctorName'];
            String location= data['location'];
            String description= data['description'];
            String date= DateFormat('d MMM').format(data['appointmentTime']);
            String time= DateFormat.Hm().format(data['appointmentTime']);

            if(role== 'dependent'){
              var guardians= await FirebaseCred().getGuardianData(userData['userId']);
              for(Map<String, dynamic> guardian in guardians){
                twilioFlutter.sendSMS(toNumber: guardian['phoneNo'], messageBody: 'Appointment');
              }
              twilioFlutter.sendSMS(toNumber: userData['phoneNo'], messageBody: 'your appointment');
            }else{
              twilioFlutter.sendSMS(toNumber: userData['phoneNo'], messageBody: 'your appointment');
            }

          }
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error retrieving documents',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 240, 91, 91),
        textColor: const Color.fromARGB(255, 255, 255, 255),
      );
    }
  }
}
