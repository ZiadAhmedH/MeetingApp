// notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _plugin.initialize(settings);
  }

  static Future<void> show(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'chat', 'Chat Messages', importance: Importance.max, priority: Priority.high);
    const iosDetails = DarwinNotificationDetails();
    await _plugin.show(0, title, body, NotificationDetails(android: androidDetails, iOS: iosDetails));
  }
}
