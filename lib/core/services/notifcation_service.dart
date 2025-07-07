import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'chat_channel',
    'Chat Notifications',
    description: 'Notifications for chat messages',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  /// Initializes the notification system and sets a tap handler
  static Future<void> initialize({
    required void Function(String? payload) onNotificationTap,
  }) async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        onNotificationTap(response.payload);
      },
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// Shows a notification with optional payload
  static Future<void> show(String title, String body, {String? payload}) async {
    const androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      channelDescription: 'Notifications for chat messages',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails();

    await _plugin.show(
      0, // Notification ID
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload, // 👈 Pass chat payload here
    );
  }
}
