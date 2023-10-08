import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FireStoreCheck {

  Future<void> checkFirestore() async {
    await Firebase.initializeApp();
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('alarms')
          .where('userId', isEqualTo: 'avc')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          var time = data['time'];
          var name = data['message'];
          var status= data['status'];
          DateTime timestamp= DateTime.parse(time);
          DateTime timestamp2= DateTime.now();
          if(timestamp.isBefore(timestamp2) && status== 'pending'){
            print('time: $time');
            print('message: $name');
            final messaging= FirebaseMessaging.instance;
            String token= FirebaseMessaging.instance.getToken().toString();
            await messaging.sendMessage(
              to: token,
              messageId: 'test1',
              messageType: 'test2',
              data: {
                'title': 'hello',
                'body' : 'dfghj'
              }
            );
          }
        }
      } else {
        print('No documents found in Firestore query.');
      }
    } catch (error) {
      // Handle any errors that occurred during the query
      print('Error fetching alarms: $error');
    }
  }

}
