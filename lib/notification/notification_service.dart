import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationServic {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'MedipalChannel',
            channelName: 'MedipalChannel',
            channelDescription: 'channelDescription',
            defaultColor: Colors.black,
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            onlyAlertOnce: true,
            playSound: true,
            criticalAlerts: true,
            locked: true,
            enableVibration: true,
          )
        ],
        debug: true);

    await AwesomeNotifications().isNotificationAllowed().then((value) async {
      if (!value) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onDismissActionReceivedMethod: onDismissActionReceived,
        onNotificationCreatedMethod: onNotificationCreated,
        onNotificationDisplayedMethod: onNotificationDisplayed);
  }

  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('On Notification Received');
    final payload = receivedNotification.payload ?? {};
    if (payload['open'] == 'true') {
      print('we goo');
    }
  }

  static Future<void> onDismissActionReceived(
      ReceivedNotification receivedNotification) async {
    debugPrint('On Notification dismissed');
  }

  static Future<void> onNotificationCreated(
      ReceivedNotification receivedNotification) async {
    debugPrint('On Notification created');
  }

  static Future<void> onNotificationDisplayed(
      ReceivedNotification receivedNotification) async {
    debugPrint('On Notification displayed');
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
  }) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'MedipalChannel',
      title: title,
      body: body,
      fullScreenIntent: true,
      notificationLayout: NotificationLayout.BigPicture,
      bigPicture: "assets/images/welcome_background.jpg",
      displayOnBackground: true,
      displayOnForeground: true,

    ));
  }
}
