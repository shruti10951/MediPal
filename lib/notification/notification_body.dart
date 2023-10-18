import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:medipal/notification/FirestoreCheck.dart'

class NotificationBody {
  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static Future<void> initialize() async {
    AwesomeNotifications().initialize(
      null,
      // 'android/app/src/main/res/drawable/medipal.png',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: '',
          defaultColor: Colors.teal,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
          locked: true,
        ),
      ],
      debug: true,
    );
  }

  Future<void> displayNotification({
    required String title,
    required String body,
  }) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 0,
      channelKey: 'basic_channel',
      title: title,
      body: body,
      category: NotificationCategory.Alarm,
      wakeUpScreen: true,
      autoDismissible: false,
      fullScreenIntent: true,
    ));
  }
}
