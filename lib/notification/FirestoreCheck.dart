import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medipal/notification/notification_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        backgroundColor: Color.fromARGB(255, 240, 91, 91),
        textColor: Color.fromARGB(255, 255, 255, 255),
      );
    }
  }
}
