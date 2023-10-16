import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationBody {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializeNotificationSetting =
        new InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin
        .initialize(initializeNotificationSetting);
  }

  static Future showNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    // const String imageUrl = 'android/app/src/main/res/drawable/medipal.png';

    AndroidNotificationDetails androidNotificationDetails =
        new AndroidNotificationDetails('channelId', 'channelName',
            playSound: true,
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: const DrawableResourceAndroidBitmap('medipal'),
          fullScreenIntent: true,
            );
    var not = NotificationDetails(android: androidNotificationDetails);
    await fln.show(0, title, body, not);
  }
}
