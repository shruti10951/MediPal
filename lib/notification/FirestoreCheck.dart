import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medipal/notification/notification_service.dart';

class FireStoreCheck {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();

  Future<void> checkFirestore() async {
    await Firebase.initializeApp();
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    // NotificationBody.initialize(flutterLocalNotificationsPlugin);

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('alarms')
          .where('userId', isEqualTo: user?.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // for (QueryDocumentSnapshot document in querySnapshot.docs) {
        //   Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        //   var time = data['time'];
        //   var name = data['message'];
        //   var status= data['status'];
        //   print('time: $time');
        //   print('message: $name');
        //   print('status: $status');
        //   DateTime timestamp= DateTime.parse(time);
        //   DateTime timestamp2= DateTime.now();
        //   if(timestamp.isBefore(timestamp2) && status== 'pending'){
        //
        //     NotificationBody.showNotification(title: 'Medication Reminder', body: name, fln: flutterLocalNotificationsPlugin);
        //
        //   }
        //
        // }
        // NotificationBody.showNotification(title: 'Medication Reminder', body: 'It is time to take your medicine!', fln: flutterLocalNotificationsPlugin);
        // print('object');
        print('Before calling');
        await NotificationServic.showNotification(
          title: 'Medipal',
          body: 'This is a reminder',
          payload: {
            "open" : "true"
          },
          actionButtons: [
            NotificationActionButton(key: 'key', label: 'We gooo', actionType: ActionType.Default)
          ]
        );
        print('after calling');
      } else {
        print('No documents found in Firestore query.');
      }
    } catch (error) {
      // Handle any errors that occurred during the query
      print('Error fetching alarms: $error');
    }
    // print('Before calling');
    // await NotificationServic.showNotification(title: 'Medipal', body: 'This is a reminder');
    // print('after calling');
  }
}
