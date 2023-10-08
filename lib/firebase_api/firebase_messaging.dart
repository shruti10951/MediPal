import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessage{
  final firebaseMessaging= FirebaseMessaging.instance;
  Future<void>initNotification() async{
    await firebaseMessaging.requestPermission();
    final fcmToken= await firebaseMessaging.getToken();
    print('Token $fcmToken');
  }
}